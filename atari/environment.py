from absl import flags

from atari import atari_wrappers

FLAGS = flags.FLAGS

# Environment settings.
flags.DEFINE_string("env", "Pong", "Gym environment.")


def create_env():

    env_version = "v4"  # "v0" for "sticky actions".
    full_env_name = f"{FLAGS.env}NoFrameskip-{env_version}"
    # env = gym.make(full_env_name, full_action_space=True)

    return atari_wrappers.wrap_pytorch(
        atari_wrappers.wrap_deepmind(
            atari_wrappers.make_atari(full_env_name),
            clip_rewards=False,
            frame_stack=True,
            scale=False,
        )
    )
