#!/bin/bash
#
# Run via ./scripts/run_in_tmux.sh
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR/..

WORKERS=4

CONDA_ENV=${CONDA_DEFAULT_ENV:-torchbeast}
CONDA_CMD="conda activate ${CONDA_ENV}"

WINDOW_NAME=torchbeast-run

tmux new-window -d -n "${WINDOW_NAME}"

TORCHBEAST_BINARY="python -m atari.main"

COMMAND='rm -rf /tmp/torchbeast && mkdir /tmp/torchbeast && '"${TORCHBEAST_BINARY}"' --role learner --num_actors='"${WORKERS}"' --batch_size 8 --total_steps 100000 --learning_rate 0.001 --log_dir /tmp/torchbeast --alsologtostderr '"$@"' '

tmux send-keys -t "${WINDOW_NAME}" "${CONDA_CMD}" KPEnter
tmux send-keys -t "${WINDOW_NAME}" "${COMMAND}" KPEnter

tmux split-window -t "${WINDOW_NAME}"

tmux send-keys -t "${WINDOW_NAME}" "${CONDA_CMD}" KPEnter

for ((id=0; id<$WORKERS; id++)); do
    COMMAND=''"${TORCHBEAST_BINARY}"' --role actor --actor_id '"${id}"' --log_dir /tmp/torchbeast --alsologtostderr '"$@"' &'
    tmux send-keys -t "${WINDOW_NAME}" "$COMMAND" ENTER
done
