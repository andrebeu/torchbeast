#pragma once

#include <deque>
#include <memory>
#include <mutex>
#include <thread>

class ThreadPool {
 public:
  ThreadPool(uint num_threads) {
    threads_.reserve(num_threads);
    for (uint i = 0; i < num_threads; ++i) {
      threads_.emplace_back(&ThreadPool::thread_run, this, i);
    }
  }

  ~ThreadPool() {
    if (!threads_.empty()) {
      std::terminate();
    }
  }

  void submit(std::function<void()> task) {
    if (!task) return;
    {
      std::unique_lock<std::mutex> lock(mu_);
      tasks_.push_back(std::move(task));
    }
    cv_.notify_one();
  }

  void close() {
    {
      std::unique_lock<std::mutex> lock(mu_);
      tasks_.push_back(nullptr);
    }
    cv_.notify_all();
    for (std::thread& thread : threads_) {
      thread.join();
    }
    threads_.clear();
  }

 private:
  void thread_run(uint i) {
    while (true) {
      std::function<void()> task;
      {
        std::unique_lock<std::mutex> lock(mu_);
        while (tasks_.empty()) cv_.wait(lock);
        if (!tasks_.front()) return;
        task = std::move(tasks_.front());
        tasks_.pop_front();
      }
      task();
    }
  }

 private:
  std::mutex mu_;
  std::condition_variable cv_;
  std::vector<std::thread> threads_;
  std::deque<std::function<void()>> tasks_;
};
