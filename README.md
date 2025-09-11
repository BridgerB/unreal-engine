# Unreal Engine 5 on NixOS

A Nix flake that packages UE5 for NixOS with proper binary patching.

## Setup

1. Download UE5 from https://www.unrealengine.com/en-US/linux
   - Get `Linux_Unreal_Engine_5.6.1.zip` (28.75 GB)
   - Place in `engine/Linux_Unreal_Engine_5.6.1.zip`

## Usage

Run UE5 directly:
```bash
nix run . --impure
```

Or install it:
```bash
nix profile install . --impure
unreal-engine
```

For development:
```bash
nix develop
```

## How it works

- Uses your local UE5 zip file (requires `--impure` flag)
- Uses `autoPatchelfHook` to fix all binary dependencies
- Bundles Vulkan, X11, and essential runtime libraries
- Includes `-DDC-ForceMemoryCache` flag automatically
- Creates a clean `unreal-engine` command

## Requirements

- NixOS or Nix with flakes enabled
- UE5 zip file downloaded locally
- ~60 GB free space for installation
- Graphics card with ≥8 GB memory recommended