import time

import torch
import torchbeast


def pyfunc(t):
    return 42 * (t + 1)


def identity(arg):
    print(arg)
    return arg


def main():
    module = torch.jit.script(torch.nn.Linear(2, 3))

    s = torchbeast.Server("localhost:12345")

    s.bind("myfunc", module)
    s.bind("pyfunc", pyfunc)
    s.bind("identity", identity, batch_size=None)
    s.bind("batched_identity", identity, batch_size=2)

    s.run()

    try:
        while True:
            time.sleep(1)  # Could also deal with signals. I guess.
    except KeyboardInterrupt:
        s.stop()
        s.wait()


if __name__ == "__main__":
    main()
