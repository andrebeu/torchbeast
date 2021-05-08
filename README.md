![Cute TorchBeast Logo](./TorchBeast-Logo-Vertical.png)

# TorchBeast 2.0
A PyTorch implementation of an
[IMPALA](https://arxiv.org/abs/1802.01561)-ish agent.


## BibTeX

We have a [paper](https://arxiv.org/abs/1910.03552).

```
@article{torchbeast2019,
  title={{TorchBeast: A PyTorch Platform for Distributed RL}},
  author={Heinrich K\"{u}ttler and Nantas Nardelli and Thibaut Lavril and Marco Selvatici and Viswanath Sivakumar and Tim Rockt\"{a}schel and Edward Grefenstette},
  year={2019},
  journal={arXiv preprint arXiv:1910.03552},
  url={https://github.com/facebookresearch/torchbeast},
}
```

## Installation

### MacOS

Create a new Conda environment, and install TorchBeast's requirements:

```shell
conda create -n torchbeast python=3.7
conda activate torchbeast
pip install -r requirements.txt
```

On MacOS, we can use homebrew to install gRPC:

```shell
brew install grpc
```

On MacOS, PyTorch can be installed as per its [website](https://pytorch.org/get-started/locally/):

```shell
pip install torch
```

Compile and install the [nest
library](https://github.com/fairinternal/nest) and the C++ parts of
TorchBeast:

```shell
git submodule update --init third_party/nest
pip install third_party/nest/
TORCHBEAST_LIBS_PREFIX=/usr/local CXX=c++ python3 setup.py install
TORCHBEAST_LIBS_PREFIX=/usr/local CXX=c++ python3 setup.py build develop  # To get some path magic.
```

### devfair

Set up a fresh environment:

```shell
module purge

module load cuda/9.2
module load cudnn/v7.3-cuda.9.2
module load NCCL/2.2.13-1-cuda.9.2

module load anaconda3
```

Create a new Conda environment, and install PolyBeast's requirements:

```shell
conda create -n torchbeast python=3.7
conda activate torchbeast
pip install -r requirements.txt
```

Compile PyTorch
[yourself](https://github.com/pytorch/pytorch#from-source) or install
our wheel (for reasons:
[1](https://github.com/pytorch/pytorch/issues/18128),
[2](https://github.com/pytorch/pytorch/pull/28536)) via:

```shell
 pip install /private/home/hnr/wheels/torch-1.3.0a0+ee77ccb-cp37-cp37m-linux_x86_64.whl
```

(If you're not on the right FAIR cluster, reach out to hnr@ on how
to access that file.)

Get and compile gRPC:
```shell
git submodule update --init --recursive
conda install -c anaconda protobuf
./scripts/install_grpc.sh
```

Compile the [nest library](https://github.com/fairinternal/nest):

```shell
pip install third_party/nest/
```

Compile and install TorchBeast:

```shell
export LD_LIBRARY_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}/lib:${LD_LIBRARY_PATH}
CXX=c++ python3 setup.py build develop  # To get some path magic.
CXX=c++ python3 setup.py install
```

## Running TorchBeast

### Via tmux

To run in a new tmux window (panel), run:

```shell
./scripts/run_in_tmux.sh --learner_device=cpu --inference_device=cpu
```

### Manually

In one command:

```shell
python -m scripts.run_single_machine --num_actors 4 --batch_size 2
```

Or starting the learner and actors separately:

Start the learner:

```shell
python -m atari.main --role learner --batch_size 8 --num_actors 4
```

In a different terminal, start a few actors:

```shell
for i in {0..3}; do python -m atari.main --role actor --actor_id $i & done
```

The `--log_dir` flag can be used to save logging data (combine with
`--alsologtostderr` to still see things on the command line). Example
learner command:

```shell
rm -rf /tmp/torchbeast && mkdir /tmp/torchbeast && \
    python -m atari.main --role learner --batch_size 8 \
    --num_actors 2 --total_steps 100000 --learning_rate 0.001 \
    --log_dir /tmp/torchbeast --alsologtostderr
```

and for an actor:

```shell
python -m atari.main --role actor --actor_id 0 \
    --log_dir /tmp/torchbeast --alsologtostderr
```
