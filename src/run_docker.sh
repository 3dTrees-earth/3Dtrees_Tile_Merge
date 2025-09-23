#!/bin/bash

docker run -it --rm \
  --name til_mer_galaxy \
  --cpuset-cpus="0-49" \
  --memory=200g \
  --runtime=nvidia \
  --gpus device=1 \
  --user $(id -u):$(id -g) \
  -v "$(pwd)":/src \
  -v /mnt/data/kg281/data/silvilaser_prep/test_docker_til_mer/:/in \
  -v /mnt/data/kg281/data/silvilaser_prep/test_docker_til_mer/out:/out \
  --entrypoint "" \
  til_mer_galaxy \
  python /src/run.py --dataset-path /in/processed_files.zip --output-dir ./out --task merge 
