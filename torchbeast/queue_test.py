import unittest
import threading

from torchbeast import queue


class QueueTest(unittest.TestCase):
    def test_simple(self):
        q = queue.Queue()
        q.put(1)
        q.put(2)
        self.assertEqual(q.get(), 1)

        q.close()
        with self.assertRaises(queue.Closed):
            q.get()

    def test_thread(self):
        q = queue.Queue(maxsize=1)

        def target():
            with self.assertRaises(queue.Closed):
                q.get(timeout=5.0)

        thread = threading.Thread(target=target)
        thread.start()

        q.close()
        thread.join()  # Should take way less than 5 sec.


if __name__ == "__main__":
    unittest.main()
