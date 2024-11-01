# this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  cortile = import (pkgs.fetchFromGitHub 
    { 
      owner = "eknowlton"; 
      repo = "cortile"; 
      rev= "c57b95a9572f1e9e6e93d4a5e40c3b1ecced5ba7";
      sha256= "sha256-tNWhRMVn7NOAftNYwgWanTZqXK+rWQeRadH5LJg4ZiQ=";
    }) {};
in
{
  imports = [ 
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./ethan.vim.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.deepin = {
    enable = true;
  };

  services.deepin = {
    app-services.enable = true;
    dde-daemon.enable = true;
  };

  xdg.portal.wlr.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable Flatpaks
  services.flatpak.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # supposed x1 carbon audio fix???
  hardware.enableAllFirmware = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ethan = {
    isNormalUser = true;
    description = "Ethan";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      httpie
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.ethan = { pkgs, ... }: {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";

    home.packages = with pkgs; [ 
      httpie 
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.xwayland.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  environment.variables = { 
    EDITOR = "vim"; 
  };

  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
  };

  environment.systemPackages = with pkgs; [
    deepin.deepin-wayland-protocols
    alacritty
    wget
    google-chrome
    zsh
    joplin-desktop
    _1password
    _1password-gui
    git
    ranger
    feh
    nodejs_22
    onlyoffice-bin
    nix-prefetch-git
    nix-prefetch-github
    niv
    nixd
    element-desktop
    dejavu_fonts
    openssl
    cortile 
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  hardware.opengl = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your spesha256-LRC5cLXwSu73q5uYO4IOya0p92yFlXjCBCLMyJwLJiw=cific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    prime = {
      sync.enable = true;

      # Make sure to use the correct Bus ID values for your system!
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };

  services.hardware.bolt.enable = true;

  systemd.user.services.cortile = {
    description = "Cortile tiling manager for deepin";
    enable = true;
    after = [ "graphical.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${cortile}/bin/cortile";
      Restart = "always";
    };
  };
}
