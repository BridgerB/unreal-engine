{ lib, stdenv, unzip, autoPatchelfHook, makeWrapper
, vulkan-loader, mesa, libGL, xorg, glibc, zlib, openssl, curl
, alsa-lib, pulseaudio, libxkbcommon, fontconfig, freetype, gtk3
, ncurses5, libuuid, libxslt, icu, SDL2, udev, systemd, dbus
, ue5src ? /home/bridger/git/unreal-engine/engine/Linux_Unreal_Engine_5.6.1.zip
}:

stdenv.mkDerivation rec {
  pname = "unreal-engine";
  version = "5.6.1";

  src = ue5src;

  nativeBuildInputs = [ 
    unzip
    autoPatchelfHook 
    makeWrapper
  ];

  buildInputs = [
    # Graphics and Vulkan
    vulkan-loader
    mesa
    libGL

    # X11 libraries
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXi
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libxcb
    xorg.libXScrnSaver
    xorg.libXfixes

    # Audio
    alsa-lib
    pulseaudio

    # Core system libraries
    glibc
    stdenv.cc.cc.lib

    # Other runtime dependencies
    libxkbcommon
    fontconfig
    freetype
    zlib
    openssl
    curl
    gtk3
    ncurses5
    libuuid
    libxslt
    icu
    SDL2
    udev
    systemd
    dbus
  ];

  # Don't strip binaries - UE5 needs debug info
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src
    runHook postUnpack
  '';

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    # Install UE5 to output directory
    mkdir -p $out/opt/unreal-engine
    cp -r . $out/opt/unreal-engine/

    # Create wrapper script for UnrealEditor
    mkdir -p $out/bin
    makeWrapper $out/opt/unreal-engine/Engine/Binaries/Linux/UnrealEditor $out/bin/unreal-engine \
      --set DISPLAY ":0" \
      --set VK_LAYER_PATH "${vulkan-loader}/share/vulkan/explicit_layer.d" \
      --set VULKAN_SDK "${vulkan-loader}" \
      --add-flags "-DDC-ForceMemoryCache" \
      --run "mkdir -p ~/.config/Epic/UnrealEngine/5.6"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unreal Engine 5 game development platform";
    homepage = "https://www.unrealengine.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}