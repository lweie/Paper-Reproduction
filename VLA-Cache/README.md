# VLA-Cache Reproduction

Reproduction of **VLA-Cache: Efficient Vision-Language-Action Manipulation via Adaptive Token Caching**.

- Conference: NeurIPS 2025
- Paper: arXiv:2502.02175
- Official project: https://vla-cache.github.io
- Official code: https://github.com/siyuhsu/vla-cache

## Reproduction Scope

This reproduction focuses on:

- Model: OpenVLA
- Benchmark: LIBERO-Spatial
- 10 tasks
- 50 rollouts per task
- 500 rollouts per method
- BF16 inference
- OpenVLA baseline vs. OpenVLA + VLA-Cache

SIMPLER, OpenVLA-OFT, CogACT and real-robot experiments are not reproduced.

## Results

### Reproduced Results

| Method | Success | Success Rate | Average CUDA Latency | Average FLOPs |
|---|---:|---:|---:|---:|
| OpenVLA | 426 / 500 | 85.2% | Not recorded | Not recorded |
| OpenVLA + VLA-Cache | 426 / 500 | 85.2% | 52.31 ms | 1.434 T |

The baseline CUDA latency and FLOPs were printed only to the terminal during evaluation and were not preserved.

In this reproduction, enabling VLA-Cache did not reduce the LIBERO-Spatial task success rate.

### Paper Results

| Method | Success Rate | CUDA Latency | FLOPs |
|---|---:|---:|---:|
| OpenVLA | 84.4% | 51.91 ms | 1.864 T |
| OpenVLA + VLA-Cache | 83.8% | 31.83 ms | 1.355 T |

The original paper evaluates on an NVIDIA RTX 4090, while this reproduction uses an NVIDIA A100-PCIE-40GB. Therefore, absolute CUDA latency values should not be directly compared across the two hardware platforms.

## Environment

Main hardware and software:

- GPU: NVIDIA A100-PCIE-40GB
- Python 3.10
- PyTorch 2.12.1 + CUDA 13.0
- torchvision 0.27.1
- tokenizers 0.21.1
- MuJoCo 3.3.2
- robosuite 1.4.1
- NumPy 1.26.4
- TensorFlow 2.15.0
- Custom VLA-Cache Transformers fork

Other dependencies follow the installation configuration provided by the original VLA-Cache / OpenVLA repositories unless otherwise noted.

Detailed environment information is stored in:

- `env/openvla_pyproject.toml`
- `env/pip_freeze.txt`
- `env/key_versions.txt`
- `env/nvidia_smi.txt`
- `env/vla_cache_commit.txt`
- `env/libero_commit.txt`

## Compatibility Fixes

Several compatibility adjustments were required:

1. LIBERO initialization was changed to use:

       torch.load(init_states_path, weights_only=False)

2. MuJoCo was pinned to:

       mujoco==3.3.2

3. EGL was used for headless rendering:

       MUJOCO_GL=egl
       PYOPENGL_PLATFORM=egl
       MUJOCO_EGL_DEVICE_ID=0

4. LIBERO was added through `PYTHONPATH`.

5. The OpenVLA processor was configured to load locally instead of depending on Hugging Face network access.

6. The openvla_pyproject.toml is the substitute for vla-cache/src/openvla/pyproject.toml,for the former pyproject.toml'version is a little bit old so it can't run correctly.

Exact source-code modifications are stored in:

- `patches/vla_cache.diff`
- `patches/libero.diff`

## Running

Baseline:

    ./scripts/run_baseline.sh

VLA-Cache:

    ./scripts/run_vla_cache.sh

The main experimental difference is:

    Baseline:  --use_vla_cache False
    VLA-Cache: --use_vla_cache True

## Repository Structure

    VLA-Cache/
    ├── README.md
    ├── results/
    ├── env/
    ├── patches/
    ├── scripts/
    └── media/

`results/` contains evaluation logs, `env/` records the software environment, `patches/` contains compatibility modifications, and `media/` stores selected rollout results.
