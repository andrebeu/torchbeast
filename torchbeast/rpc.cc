
#include "client.h"
#include "server.h"

PYBIND11_MODULE(rpc, m) {
  py::class_<torchbeast::Client>(m, "Client")
      .def(py::init<const std::string &>(), py::arg("address"))
      .def("connect", &torchbeast::Client::connect,
           py::arg("deadline_sec") = 60)
      .def("call", &torchbeast::Client::call);

  py::class_<torchbeast::Server>(m, "Server")
      .def(py::init<const std::string &, uint>(), py::arg("address"),
           py::arg("max_parallel_calls") = 2)
      .def("run", &torchbeast::Server::run)
      .def("running", &torchbeast::Server::running)
      .def("wait", &torchbeast::Server::wait,
           py::call_guard<py::gil_scoped_release>())
      .def("stop", &torchbeast::Server::stop,
           py::call_guard<py::gil_scoped_release>())
      .def("bind", &torchbeast::Server::bind, py::keep_alive<1, 3>(),
           py::arg("name"), py::arg("function"),
           py::arg("batch_size") = std::nullopt);
}
