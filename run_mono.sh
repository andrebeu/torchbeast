
python -m torchbeast.monobeast \
     --env PongNoFrameskip-v4 \
     --num_actors 8 \
     --total_steps 50000 \
     --learning_rate 0.0004 \
     --epsilon 0.01 \
     --entropy_cost 0.01 \
     --batch_size 4 \
     --unroll_length 40 \
     --num_buffers 30 \
     --num_threads 4 \
     --xpid example

python -m torchbeast.monobeast \
     --env PongNoFrameskip-v4 \
     --mode test \
     --xpid example