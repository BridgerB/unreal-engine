{
  description = "Unreal Engine development environment with Vulkan support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # nixld for running unpatched binaries
            nix-ld
            
            # Vulkan support
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
            
            # Graphics libraries
            mesa
            
            # X11 and desktop integration
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXi
            xorg.libXinerama
            xorg.libxcb
            xorg.libXScrnSaver
            xorg.libXext
            xorg.libXrender
            xorg.libXfixes
            
            # Audio
            alsa-lib
            pulseaudio
            
            # Other dependencies
            libGL
            libxkbcommon
            fontconfig
            freetype
            zlib
            openssl
            curl
            gtk3
            
            # C++ runtime libraries
            stdenv.cc.cc.lib
            glibc
            
            # Development tools
            clang
            gcc
            cmake
            ninja
            git
            
            # Desktop integration tools
            xdg-utils
            zenity
            
            # Additional Unreal Engine dependencies
            ncurses5
            libuuid
            libxslt
            icu
            
            # SDL and input dependencies
            SDL2
            udev
            systemd
            dbus
          ];
          
          shellHook = ''
            export VK_LAYER_PATH="${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d"
            export VULKAN_SDK="${pkgs.vulkan-loader}"
            export LD_LIBRARY_PATH="${pkgs.vulkan-loader}/lib:${pkgs.mesa}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.SDL2}/lib:${pkgs.udev}/lib:$LD_LIBRARY_PATH"
            
            # Fix for missing xdg-user-dir and other desktop integration
            export PATH="${pkgs.xdg-utils}/bin:$PATH"
            
            # Configure nixld for running unpatched binaries
            export NIX_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
            export NIX_LD="${pkgs.stdenv.cc.bintools.dynamicLinker}"
            
            # Additional library paths for X11, SDL, and OpenGL
            export LD_LIBRARY_PATH="${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXext}/lib:${pkgs.xorg.libXrender}/lib:${pkgs.xorg.libXfixes}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXrandr}/lib:${pkgs.xorg.libXi}/lib:${pkgs.xorg.libXinerama}/lib:${pkgs.xorg.libxcb}/lib:${pkgs.xorg.libXScrnSaver}/lib:${pkgs.libGL}/lib:$LD_LIBRARY_PATH"
            
            # SDL and input system environment
            export SDL_VIDEODRIVER=x11
            export UDEV=1
            
            # Preserve X11 environment from host
            export DISPLAY=''${DISPLAY:-:0}
            export XDG_SESSION_TYPE=''${XDG_SESSION_TYPE:-x11}
            export XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
            
            # Create config directory if it doesn't exist
            mkdir -p ~/.config/Epic/UnrealEngine/5.6/Content
            
            echo "Unreal Engine development environment loaded"
            echo "Vulkan support: $(vulkaninfo --summary 2>/dev/null && echo "✓" || echo "✗")"
            echo "SDL2 available: $(pkg-config --exists sdl2 2>/dev/null && echo "✓" || echo "✗")"
            echo "X11 Display: $DISPLAY"
            echo "Run: ./engine/Engine/Binaries/Linux/UnrealEditor -DDC-ForceMemoryCache"
            echo "Note: Use -DDC-ForceMemoryCache flag to bypass DDC cache issues"
          '';
        };
      });
}