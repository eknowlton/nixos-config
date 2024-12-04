# this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [ 
    ./hardware-configuration.nix
    <home-manager/nixos>
    ./ethan.vim.nix
    ./ethan.hyprland.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  #virtualisation.docker.enable = true;
  #virtualisation.docker.rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  #};

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

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


  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = "xdg-desktop-portal-gtk";
      };
    };
  };

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
    extraGroups = [ "networkmanager" "wheel" "docker" "input" ];
    packages = with pkgs; [
      httpie
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.ethan = { pkgs, ... }: {

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";

    programs.kitty.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          size = 12.0;
          normal = {
            family = "DejaVu Sans Mono for Powerline";
          };
        };
        keyboard = {
          bindings = [
            {
              action = "ToggleViMode";
              key = "Space";
              mode = "~Search";
              mods = "Shift|Control";
            }
          ];
        };
        window = {
          decorations = "none";
          padding = {
            x = 5;
            y = 5;
          };
        };
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
      config = {
        common = {
          default = "xdg-desktop-portal-hyprland";
        };
      };
    };

    home.packages = with pkgs; [ 
      httpie 
    ];

    home.file = {
      "wallpapers/snow-moutains.jpg" = {
        source = "/etc/nixos/wallpapers/snow-moutains.jpg";
      };
      ".config/nwg-bar/bar.json" = {
        source = "/etc/nixos/config/nwg-bar/bar.json";
      };
    };

    programs.wofi = {
      enable = true;
      style = ''
/*
* wofi style. Colors are from authors below.
* Base16 Gruvbox dark, medium
* Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
*
*/
@define-color base00 #282828;
@define-color base01 #3C3836;
@define-color base02 #504945;
@define-color base03 #665C54;
@define-color base04 #BDAE93;
@define-color base06 #D5C4A1;
@define-color base06 #EBDBB2;
@define-color base07 #FBF1C7;
@define-color base08 #FB4934;
@define-color base09 #FE8019;
@define-color base0A #FABD2F;
@define-color base0B #B8BB26;
@define-color base0C #8EC07C;
@define-color base0D #83A598;
@define-color base0E #D3869B;
@define-color base0F #D65D0E;

window {
    opacity: 0.9;
    border:  0px;
    border-radius: 10px;
    font-family: monospace;
    font-size: 18px;
}

#input {
	border-radius: 10px 10px 0px 0px;
    border:  0px;
    padding: 10px;
    margin: 0px;
    font-size: 28px;
	color: #8EC07C;
	background-color: #554444;
}

#inner-box {
	margin: 0px;
	color: @base06;
	background-color: @base00;
}

#outer-box {
	margin: 0px;
	background-color: @base00;
    border-radius: 10px;
}

#selected {
	background-color: #608787;
}

#entry {
	padding: 0px;
    margin: 0px;
	background-color: @base00;
}

#scroll {
	margin: 5px;
	background-color: @base00;
}

#text {
	margin: 0px;
	padding: 2px 2px 2px 10px;
}
      '';
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
      };
      settings = {
        only = {
          layer = "top";
          position = "top";
          height = 32;
          gtk-layer-shell = true;
          mod = "dock";
          exclusive = true;
          modules-left = ["hyprland/workspaces" "hyprland/window" ];
          modules-center = [];
          modules-right = ["wireplumber" "battery" "cpu" "temperature" "backlight" "disk" "memory" "network" "tray" "clock"];
          disk = {
            "format" = "{percentage_free}%  /";
            "path" = "/";
          };
          "hyprland/window" = {
            "format" = "{}";
            "rewrite" = [
              { "(.*) - Google Chrome" = "🌎 $1"; }
              { "(.*) - Alacritty" = "> [$1]"; }
            ];
            "separate-outputs" = true;
          };
          "hyprland/workspaces" = {
            "format" = "{icon}";
            "on-click" = "activate";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "urgent" = "";
              "default" = "";
            };
            "sort-by-number" = true;
          };
          clock = {
            "format" = "{:%H:%M} ";
            "format-alt" = "{:%A, %B %d, %Y (%R)} ";
            "tooltip-format" = "<tt><small>{calendar}</small></tt>";
            "calendar" = {
              "mode" = "year";
              "mode-mon-col" = 3;
              "weeks-pos" = "right";
              "on-scroll" = 1;
              "format" = {
                "months" = "<span color='#ffead3'><b>{}</b></span>";
                "days" = "<span color='#ecc6d9'><b>{}</b></span>";
                "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
                "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            "actions" = {
              "on-click-right" = "mode";
              "on-scroll-up" = "tz_up";
              "on-scroll-down" = "tz_down";
            };
          };
          network = {
            "interface" = "wlp82s0";
            "format"= "{ifname}";
            "format-wifi"= "{essid} ({signalStrength}%) ";
            "format-ethernet"= "{ipaddr}/{cidr} 󰊗";
            "format-disconnected"= "";
            "tooltip-format"= "{ifname} via {gwaddr} 󰊗";
            "tooltip-format-wifi"= "{essid} ({signalStrength}%) ";
            "tooltip-format-ethernet"= "{ifname} ";
            "tooltip-format-disconnected"= "Disconnected";
            "max-length"= 50;
          };
          memory = {
            "interval" = 30;
            "format" = "{}% ";
            "max-length" = 10;
          };
          cpu = {
            "format" = "{icon0} {icon1} {icon2} {icon3} {icon4} {icon5} {icon6} {icon7}";
            "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };
          backlight = {
            "format" = "{percent}% {icon}";
            "format-icons" = ["" ""];
            "on-scroll-up" = "brightnessctl set +10%";
            "on-scroll-down" = "brightnessctl set 10%-";
          };
          battery = {
            "interval" = 60;
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-icons" = ["" "" "" "" ""];
            "max-length" = 25;
          };
          wireplumber = {
            "format" = "{volume}% {icon}";
            "format-muted" = "";
            "on-click" = "helvum";
            "format-icons" = ["" "" ""];
          };
        };
      };
      style = ''
            * {
            font-family: "DejaVu Sans Mono for Powerline";
            font-size: 13px;
            min-height: 0;
          }

          window#waybar {
            background-color: rgba(43, 48, 59, 0.5);
            color: #ffffff;
            transition-property: background-color;
            transition-duration: .5s;
          }

#window {
        margin: 2;
        padding-left: 8;
        padding-right: 8;
        background-color: rgba(0,0,0,0.3);
        font-size:14px;
        font-weight: bold;
        }

        button {
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 -3px transparent;
        /* Avoid rounded borders under each button name */
        border: none;
        border-radius: 0;
        }

              button:hover {
              background: inherit;
              border-top: 2px solid #c9545d;
              }

#workspaces button {
              padding: 0 4px;
              background-color: rgba(0,0,0,0.3);
              color: #fff;
              }

#workspaces button:hover {
              }
#workspaces button.active {
              background-color: rgba(0, 0, 0, 0.85);
              border-bottom: 2px solid #fff;
              }

#workspaces button.focused {
              box-shadow: inset 0 -2px #c9545d;
              background-color: rgba(0,0,0,1);
              color:#c9545d;
              border-top: 2px solid #c9545d;
              }

#workspaces button.urgent {
              background-color: #eb4d4b;
              }

#mode {
              background-color: #64727D;
              border-bottom: 3px solid #ffffff;
              }

#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#tray,
#mode,
#idle_inhibitor,
#scratchpad,
#mpd {
              margin: 2px;
              padding-left: 15px;
              padding-right: 15px;
              background-color: rgba(0,0,0,0.3);
              color: #ffffff;
              }

              /* If workspaces is the leftmost module, omit left margin */
              .modules-left > widget:first-child > #workspaces {
              margin-left: 0;
              }

              /* If workspaces is the rightmost module, omit right margin */
              .modules-right > widget:last-child > #workspaces {
              margin-right: 0;
              }

#clock {
              font-size:14px;
              font-weight: bold;
              }

#battery icon {
              color: red;
              }

#battery.charging, #battery.plugged {
              color: #ffffff;
              background-color: #26A65B;
              }

              @keyframes blink {
              to {
              background-color: #ffffff;
              color: #000000;
              }
              }

#battery.warning:not(.charging) {
              background-color: #f53c3c;
              color: #ffffff;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
              }

#battery.critical:not(.charging) {
              background-color: #f53c3c;
              color: #ffffff;
              animation-name: blink;
              animation-duration: 0.5s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
              }

              label:focus {
              background-color: #000000;
              }

#network.disconnected {
              background-color: #f53c3c;
              }

#temperature.critical {
              background-color: #eb4d4b;
              }

#idle_inhibitor.activated {
              background-color: #ecf0f1;
              color: #2d3436;
              }

#tray > .passive {
              -gtk-icon-effect: dim;
              }

#tray > .needs-attention {
              -gtk-icon-effect: highlight;
              background-color: #eb4d4b;
              }

      '';
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload =
          [ "$HOME/wallpapers/snow-moutains.jpg" ];

          wallpaper = [
            ", $HOME/wallpapers/snow-moutains.jpg"
            ];
            };
            };

            wayland.windowManager.hyprland.settings = {
              "$mod" = "SUPER";
              "$terminal" = "alacritty";
              "$fileManager" = "nautilus";
              "$menu" = "wofi --show drun -I";
              "$runner" = "wofi --show run -e -I";
              "$launcher" = "nwg-drawer";

              exec = [
              ];

              input = {
                kb_layout = "us";
                follow_mouse = 2;
                touchpad = {
                  natural_scroll = true;
                  scroll_factor = 2;
                };
                sensitivity = 0;
                scroll_factor = 3;
              };

              gestures = {
                workspace_swipe = "on";
              };

              general = {
                gaps_in = 4;
                gaps_out = 8;
                border_size = 2;

                layout = "master";

                allow_tearing = false;
              };

              decoration = {
                rounding = 5;
                active_opacity = 1;
                inactive_opacity = 0.65;

                blur = {
                  enabled = false;
                  size = 3;
                  passes = 1;
                };

                drop_shadow = "no";
                shadow_range = 4;
                shadow_render_power = 3;
              };

              dwindle = {
                pseudotile = "yes";
                preserve_split = "yes";
              };

              group = {
                groupbar = {
                  font_size = 11;
                  height = 25;
                  text_color = "rgb(ffffff)";
                };
              };

              misc = {
                force_default_wallpaper = -1;
                disable_hyprland_logo = true;
              };

              monitor = [
                "eDP-1, 1920x1080, 0x0, 1"
                ];

                bind =
                [
                "$mod, Q, killactive"
                "$mod, B, exec, google-chrome-stable"
                "$mod, RETURN, exec, alacritty"

                "$mod, GRAVE, focusurgentorlast"
                "$mod SHIFT, GRAVE, focuscurrentorlast"

                "$mod, H, movefocus, l"
                "$mod, L, movefocus, r"
                "$mod, K, movefocus, u"
                "$mod, J, movefocus, d"

                "$mod SHIFT, H, movewindow, l"
                "$mod SHIFT, L, movewindow, r"
                "$mod SHIFT, K, movewindow, u"
                "$mod SHIFT, J, movewindow, d"

                "$mod ALT, J, movecurrentworkspacetomonitor, l"
                "$mod ALT, K, movecurrentworkspacetomonitor, r"

                "$mod, W, exec, $menu"
                "$mod SHIFT, W, exec, $runner"
                "$mod, SPACE, exec, $launcher"
                "$mod, F, exec, $fileManager"
                ]
                ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
        "$mod, code:1${toString i}, workspace, ${toString ws}"
        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]
        )
        9)
        );

        windowrulev2 = [
        "opaque, class:(), title:()"
        "noshadow, class:(), title:()"
        "noblur, class:(), title:()"
        ];
        };
        };

  # Install firefox.
  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;

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

  fonts.packages = with pkgs; [
    dejavu_fonts
    powerline-fonts
    font-awesome
  ];

  environment.systemPackages = with pkgs; [
    wget
    google-chrome
    zsh
    joplin-desktop
    _1password
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
    brightnessctl
    gnome.nautilus
    dejavu_fonts
    powerline-fonts
    font-awesome
    walker
    gtk4
    gtk3
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

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
}
