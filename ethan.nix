{ pkgs, lib, ... }: 
let 
  onePassPath = "~/.1password/agent.sock";
in {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ethan = {
    isNormalUser = true;
    description = "Ethan";
    extraGroups = [ "networkmanager" "wheel" "podman" "docker" "input" ];
    packages = with pkgs; [
      httpie
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.ethan = { pkgs, ... }: {

    nixpkgs.config.allowUnfree = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";

    programs.kitty.enable = true;

    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host *
            IdentityAgent ${onePassPath}
      '';
    };


    programs.git = {
      enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        user = {
          email = "eknowlton@gmail.com";
          name = "Ethan Knowlton";
          signingKey = ''
            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXZDKqMWLadxiGeJbZ/6SvOlohDddNK0V8e7uNbbjw+
          '';
        };
        safe = {
          directory = "/etc/nixos";
        };
        gpg = {
          format = "ssh";
        };
        "gpg \"ssh\"" = {
          program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
        };
        commit = {
          gpgsign = true;
          verbose = true;
        };
        diff = {
          algorithm = "histogram";
          colorMoved = true;
          mnemonicPrefix = true;
          renames = true;
        };
        push = {
          autoSetupRemote = true;
        };
        help = {
          autocorrect = "prompt";
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        merge = {
          zdiff3 = true;
        };
        pull = {
          rebase = true;
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "breeze-dark";
      };
    };

    programs.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [];
        theme = "robbyrussell";
      };
    };

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

    home.packages = with pkgs; [ 
      httpie 
    ];

    home.file = {

      # wallpapers
      "wallpapers/snow-moutains.jpg" = {
        source = "/etc/nixos/wallpapers/snow-moutains.jpg";
      };

      # config files
      ".config/nwg-launchers/nwgbar/bar.json" = {
        source = "/etc/nixos/config/nwg-launchers/nwgbar/bar.json";
      };
      ".config/nyxt/config.lisp" = {
        source = "/etc/nixos/config/nyxt/config.lisp";
      };
      ".config/qutebrowser/config.py" = {
        source = "/etc/nixos/config/qutebrowser/config.py";
      };
      ".local/share/applications/figma.desktop" = {
        source = "/etc/nixos/local/share/applications/figma.desktop";
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
        font-family: "DejaVu Sans Mono for Powerline";
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
          mode = "dock";
          position = "top";
          height = 32;
          gtk-layer-shell = true;
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
              "0" = "";
              "urgent" = "";
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
            "interval" = 10;
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
            "interval" = 5;
            "states" = {
              "warning" = 22;
              "critical" = 12;
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

      wayland.windowManager.hyprland = {
        systemd.enable = true;
        systemd.variables = ["--all"];
        enable = true;
        settings = {
          "$mod" = "SUPER";
          "$terminal" = "alacritty";
          "$fileManager" = "nautilus";
          "$menu" = "wofi --show drun -I";
          "$runner" = "wofi --show run -e -I";
          "$launcher" = "nwg-drawer";
          "$systemMenu" = "nwgbar";

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

          cursor = {
            enable_hyprcursor = true;
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
            disable_hyprland_logo = false;
          };

          monitor = [
            "eDP-1,1920x1080@60.0,5760x1080,1.0" 
            "DP-3,3840x2160@60.0,1920x0,1.0"
          ];

          bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
          ];

          bind =
            [
              "$mod, Q, killactive"
              "$mod, RETURN, exec, alacritty"
              " CTRL SHIFT, X, exec, 1password"

              "$mod, GRAVE, focusurgentorlast"
              "$mod SHIFT, GRAVE, focuscurrentorlast"

              "$mod SHIFT, SPACE, togglefloating"
              "$mod SHIFT, F, fullscreen"

              "$mod, P, exec, pkill grim;  grim -g \"$(slurp)\" - | wl-copy"
              "$mod CTRL, P, exec, pkill grim; grim -g \"$(slurp)\" $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"
              "$mod SHIFT, P, exec, pkill grim; grim -o $(hyprctl monitors -j | jq -r '[ .[] | select( .focused ) ][0].name') $HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"

              "$mod, bracketleft, exec, hyprctl keyword general:layout dwindle"
              "$mod, bracketright, exec, hyprctl keyword general:layout master"
              "$mod, X, pin, # dwindle"
              "$mod, S, pseudo, # dwindle"
              "$mod, E, togglesplit, # dwindle"

              "$mod SHIFT, A, movetoworkspace, special:magica"
              "$mod SHIFT, B, movetoworkspace, special:magicb"
              "$mod, A, togglespecialworkspace, magica"
              "$mod, B, togglespecialworkspace, magicb"

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
              "$mod, ESCAPE, exec, $systemMenu"
              "$mod, F, exec, $fileManager"

              "ALT SHIFT, L ,resizeactive, 10 0"
              "ALT SHIFT, H ,resizeactive, -10 0"
              "ALT SHIFT, K,resizeactive, 0 -10"
              "ALT SHIFT, J ,resizeactive, 0 10"

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
          "suppressevent maximize, class:.*"
          "float, class:(1Password)"
          "float, class:(org.gnome.Calculator)"
          "float, class:(it.mijorus.smile)"

          "opaque, class:(), title:()"
          "noshadow, class:(), title:()"
          "noblur, class:(), title:()"

          "opacity 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"
        ];
      };
    };
  };
}
