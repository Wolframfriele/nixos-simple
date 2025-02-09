{pkgs, hyprland, ...}: {


  home.packages = with pkgs; [
    hypridle
    hyprlock
    hyprcursor
    wl-clipboard
    pavucontrol
    grim 
    slurp
    batsignal
    (import ./laptop-lid.nix { inherit pkgs; })
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      # Setup monitors
      # monitor=,preferred,auto,auto
      monitor = eDP-1, 1920x1080@60, 0x0, 1
      # monitor = DP-2, 3840x2160@60, -3840x-960, 1
      # monitor = DP-4, 3840x2160@60, -3840x-960, 1

      # Execute your favorite apps at launch
      # exec-once = ~/.config/hypr/scripts/xdg-portal-hyprland # Make sure the correct portal is running
      # exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # Wayland magic (screen sharing etc.)
      # exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP # More wayland magic (screen sharing etc.)
      # exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 # used for user sudo graphical elevation
      
      exec-once = batsignal -n BAT0 -w 30 -c 15 -d 10 -D 'systemctl suspend'
      exec-once = blueman-applet # Systray app for BT
      exec-once = nm-applet --indicator # Systray app for Network/Wifi
      exec-once = waybar & disown

      exec-once = hypridle

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        touchpad {
            natural_scroll = yes
            tap-to-click = no
            clickfinger_behavior = 1
        }

        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        accel_profile = flat
      }

      general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 4
        gaps_out = 8
        border_size = 1
        col.active_border=rgb(cdd6f4)
        col.inactive_border = rgba(595959aa)

        layout = master
      }

      misc {
        disable_hyprland_logo = yes

        mouse_move_enables_dpms = true
        key_press_enables_dpms = true
      }

      decoration {
        rounding = 2
      }
      
      animations {
        enabled = yes

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.2, 0.8, 0.2, 1.

        animation = windows, 1, 2, myBezier,
        animation = windowsOut, 1, 2, default, popin 80%
        animation = border, 1, 5, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 3, default
        animation = workspaces, 1, 2, myBezier, slidevert
      }

      master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        orientation = right
        new_status = inherit
      }

      gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = off
      }

      # windowrule v1
      #windowrule = float, ^(kitty)$
      windowrule = float,^(pavucontrol)$
      windowrule = float,^(blueman-manager)$
      windowrule = float,^(nm-connection-editor)$
      windowrule = float,^(thunar)$
      windowrule = float, title:^(btop)$
      windowrule = float, title:^(update-sys)$
      windowrule = float,^(feh)$

      # windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # rules below would make the specific app transparent
      windowrulev2 = animation popin,class:^(kitty)$,title:^(update-sys)$
      windowrulev2 = animation popin,class:^(thunar)$
      windowrulev2 = opacity 1 1,class:^(thunar)$
      windowrulev2 = opacity 1 1,class:^(VSCodium)$
      windowrulev2 = idleinhibit fullscreen,class:^(firefox)$
      windowrulev2 = idleinhibit fullscreen,class:^(vlc)$

      # workspace rules
      workspace = 4, monitor:eDP-1, default:true
      workspace = 5, monitor:DP-2, default:true

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Q, killactive, # close the active window
      bind = $mainMod, L, exec, hyprlock # Lock the screen
      bind = $mainMod, M, exec, wlogout --protocol layer-shell # show the logout window
      bind = $mainMod SHIFT, M, exit, # Exit Hyprland all together no (force quit Hyprland)

      bind = $mainMod, E, exec, anyrun # Show the graphical app launcher
      bind = $mainMod, T, exec, kitty  # open the terminal
      bind = $mainMod, B, exec, firefox # Execute firefox
      bind = $mainMod, F, exec, thunar # Show the graphical file browser

      bind = $mainMod, V, togglefloating, # Allow a window to float
      # bind = $mainMod, P, pseudo, # dwindle
      # bind = $mainMod, J, togglesplit, # dwindle
      bind = $mainMod, S, exec, grim -g "$(slurp)"# - | swappy -f - # take a screenshot

      # Bind Audio keys
      binde=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      binde=, XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
      bind =, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind =, XF86AudioPlay, exec, playerctl play-pause
      bind =, XF86AudioNext, exec, playerctl next
      bind =, XF86AudioPrev, exec, playerctl previous
      bind =, XF86audiostop, exec, playerctl stop

      # Bind Brightness keys
      binde=, XF86MonBrightnessDown, exec, brightnessctl set 5%-
      binde=, XF86MonBrightnessUp, exec, brightnessctl set +5%
      
      # Move focus with mainMod + arrow keys
      bind = $mainMod, A, layoutmsg, swapwithmaster master
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      
      # New attempt at switching of screen when closing lid
      bindl = , switch:Lid Switch, exec, laptop-lid

      env = HYPRCURSOR_THEME,McMojave
      env = HYPRCURSOR_SIZE,35
      '';
  };

  systemd.user.sessionVariables = {
    "NIXOS_OZONE_WL" = "1"; # for any ozone-based browser & electron apps to run on wayland
    "MOZ_ENABLE_WAYLAND" = "1"; # for firefox to run on wayland
    "MOZ_WEBRENDER" = "1";
    "WLR_NO_HARDWARE_CURSORS" = "1";

    # for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/
    # "LIBVA_DRIVER_NAME" = "nvidia";
    # "XDG_SESSION_TYPE" = "wayland";
    # "GBM_BACKEND" = "nvidia-drm";
    # "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    # "HYPRCURSOR_THEME" = "McMojave";
    # "WLR_EGL_NO_MODIFIRES" = "1";
  };

  # hyprlock config
  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock.conf;
  
  # hypridle config
  home.file.".config/hypr/hypridle.conf".source = ./hypridle.conf;


  programs.wlogout = {
    enable = true;
    layout = [
      {
          label = "lock";
          action = "hyprlock";
          text = "Lock";
          keybind = "l";
      }
      {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
      }
      {
          label = "logout";
          action = "loginctl terminate-user $USER";
          text = "Logout";
          keybind = "e";
      }
      {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
      }
      {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
      }
      {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
      }
    ];
  };
}
