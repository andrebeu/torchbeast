#pragma once

#include <grpc++/grpc++.h>
#include <pybind11/numpy.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include "nest_serialize.h"
#include "rpc.grpc.pb.h"
#include "rpc.pb.h"

#include "../third_party/nest/nest/nest.h"
#include "../third_party/nest/nest/nest_pybind.h"

namespace py = pybind11;

typedef nest::Nest<py::array> PyArrayNest;

namespace torchbeast {
class Client {
 public:
  Client(const std::string &address) : address_(address) {}

  void connect(int deadline_sec = 60);

  PyArrayNest call(const std::string &function, PyArrayNest inputs);

 private:
  static void fill_ndarray_pb(NDArray *array, py::array pyarray);
  static PyArrayNest array_pb_to_nest(NDArray *array_pb);

  const std::string address_;
  std::unique_ptr<RPC::Stub> stub_;
  grpc::ClientContext context_;
  std::shared_ptr<grpc::ClientReaderWriter<CallRequest, CallResponse>> stream_;
};

}  // namespace torchbeast
