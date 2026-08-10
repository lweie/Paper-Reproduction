#!/usr/bin/env bash
set -euo pipefail

OPENVLA_DIR="${OPENVLA_DIR:-/root/VLA-cache/vla-cache/src/openvla}"
LIBERO_DIR="${LIBERO_DIR:-/root/LIBERO}"

export PYTHONPATH="${LIBERO_DIR}:${PYTHONPATH:-}"
export MUJOCO_GL=egl
export PYOPENGL_PLATFORM=egl
export MUJOCO_EGL_DEVICE_ID="${MUJOCO_EGL_DEVICE_ID:-0}"
export TOKENIZERS_PARALLELISM=false

cd "${OPENVLA_DIR}"

python experiments/robot/libero/run_libero_eval.py \
  --pretrained_checkpoint checkpoints/openvla-7b-finetuned-libero-spatial \
  --task_suite_name libero_spatial \
  --use_vla_cache True \
  --num_trials_per_task 50 \
  --use_wandb False
