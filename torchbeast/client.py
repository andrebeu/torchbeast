import nest

import numpy as np
import torchbeast.rpc


class Client(torchbeast.rpc.Client):
    def __getattr__(self, name):
        # TODO: Send available functions through at init.
        def fn(*args):
            return self.call(name, nest.map(np.array, args))

        return fn
