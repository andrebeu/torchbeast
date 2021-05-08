import concurrent.futures
import multiprocessing as mp
import signal

from absl import app
from absl import flags
from absl import logging

import numpy as np

from atari import learner
from atari import actor
from atari import main as atari_main

FLAGS = flags.FLAGS


def run_actor(actor_id):
    # Ignore SIGINT. We die when the connection to the learner fails.
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    np.random.seed()  # Get new random seed in forked process.
    FLAGS.role = "actor"
    FLAGS.actor_id = actor_id

    if actor_id > 0:  # Be less verbose for most actors.
        logging.set_verbosity(logging.WARN)

    app.run(atari_main.main)


def run_learner():
    FLAGS.role = "learner"
    app.run(atari_main.main)


def main(_):
    actor_processes = []
    for actor_id in range(FLAGS.num_actors):
        p = mp.Process(target=run_actor, args=(actor_id,))
        p.start()
        actor_processes.append(p)

    run_learner()

    for p in actor_processes:
        p.join()


if __name__ == "__main__":
    app.run(main)
