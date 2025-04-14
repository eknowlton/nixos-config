{ pkgs, ...}: {

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"
  ];

  environment.systemPackages = with pkgs; [
    wget
    google-chrome
    joplin-desktop
    _1password-cli
    _1password-gui
    git
    ranger
    feh
    nodejs_18
    onlyoffice-bin
    nix-prefetch-git
    nix-prefetch-github
    niv
    nixd
    element-desktop
    openssl
    nodePackages.intelephense
    wl-clipboard
    nwg-launchers
    nwg-displays
    nwg-drawer
    nwg-look
    podman-tui
    dive
    xfce.thunar
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    webp-pixbuf-loader
    poppler
    ffmpegthumbnailer
    libgsf
    totem
    gnome-epub-thumbnailer
    xarchiver
    file-roller
    brightnessctl
    nautilus
    dejavu_fonts
    powerline-fonts
    font-awesome
    walker
    gtk4
    gtk3
    podman-compose 
    qutebrowser
    nyxt
    xwayland
    xwayland-run
    tor-browser
    udiskie
    grim
    slurp
    appimage-run
    material-icons
    zafiro-icons
    windows10-icons
    vscode
    httpx
    hurl
    mitmproxy
    mitmproxy2swagger
    swagger-cli
    glow
    logseq
    inkscape-with-extensions
    gimp-with-plugins
    gpick
    swaynotificationcenter
    awscli2
    discord
    pinokio
    lunacy
    bat
    gnome-keyring
    zip
    unzip
  ];

  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.displayManager.ly = {
    enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.hyprland.enable = true;
  programs.hyprland.withUWSM  = false;

  programs.dconf.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

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

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config = {
      common = {
        default = "xdg-desktop-portal-hyprland";
      };
    };
  };

  services.udisks2 = {
    enable = true;
  };

  services.xserver = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.flatpak.enable = false;

  services.printing.enable = true;

  # supposed x1 carbon audio fix???
  hardware.enableAllFirmware = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    #media-session.enable = true;
  };

  services.libinput.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  programs.zsh.enable = true;

  environment.variables = { 
    PODMAN_COMPOSE_PROVIDER = "${pkgs.podman-compose.outPath}/bin/podman-compose";
    PODMAN_COMPOSE_WARNING_LOGS = "false";
  };

  environment.sessionVariables = {
    EDITOR = "vim"; 
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    powerline-fonts
    font-awesome
  ];

  nixpkgs.config.allowUnfree = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "ethan" ];
  };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  services.hardware.bolt.enable = true;

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    });
  '';
}
