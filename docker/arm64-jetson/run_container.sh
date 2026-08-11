#!/usr/bin/env bash
# Jetson variant. --gpus all is the NVML path and Jetson has no NVML.
# No xhost: it only works against a local X server, not through ssh -X.
# With a monitor on the Orin, run `export DISPLAY=:0; xhost +local:root` first.

set -euo pipefail

CC_DATA_DIR="${CC_DATA_DIR:-/storage}"
IMAGE="${IMAGE:-ffs}"

# ../.. -- this lives in docker/arm64-jetson/, not docker/.
DIR=$(cd "$(dirname "$0")/../.." && pwd)

docker rm -f ffs 2>/dev/null || true

exec docker run --runtime nvidia -it \
  --name ffs \
  --network=host --ipc=host \
  --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  -e DISPLAY="${DISPLAY:-}" -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$DIR":/workspace -w /workspace \
  ${CC_DATA_DIR:+-v "$CC_DATA_DIR":"$CC_DATA_DIR"} \
  "$IMAGE" bash
