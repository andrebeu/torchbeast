from absl import app
from absl import flags

from atari import learner
from atari import actor

FLAGS = flags.FLAGS

flags.DEFINE_enum("role", None, ["learner", "actor"], "Role to run at.")
flags.DEFINE_string(
    "server_address",
    "localhost:12345",
    "Address of the server (e.g. localhost:12345 or unix:/tmp/torchbeast).",
)


def main(argv):
    if FLAGS.role == "actor":
        actor.main(argv)
    elif FLAGS.role == "learner":
        learner.main(argv)
    else:
        raise ValueError("Unknown role %s" % FLAGS.role)


if __name__ == "__main__":
    app.run(main)
