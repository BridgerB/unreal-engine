# Unreal Engine 5 on NixOS

Run UE5 on NixOS using nixld and flake environment.

## Setup

1. Download UE5 from https://www.unrealengine.com/en-US/linux
   - Get `Linux_Unreal_Engine_5.6.1.zip` (28.75 GB)
   - Extract to `engine/` directory
2. Enter flake environment:
   ```bash
   nix develop
   ```
3. Run UE5:
   ```bash
   ./engine/Engine/Binaries/Linux/UnrealEditor -DDC-ForceMemoryCache
   ```

## Notes

- Uses nixld to run unpatched UE5 binaries
- `-DDC-ForceMemoryCache` bypasses cache issues
- Includes Vulkan, X11, and essential runtime libraries