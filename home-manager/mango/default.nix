{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib)
    concatMap
    hm
    mkIf
    range
    ;

  terminal = "ghostty";
  browser = "google-chrome-stable";
  menu = "noctalia msg panel-toggle launcher";

  landscape = "DP-2";
  portrait = "DP-1";

  tagKey = t: if t == 10 then "0" else toString t;

  tagMonitor = t: if t <= 5 then landscape else portrait;

  tagBinds = map (t: "SUPER,${tagKey t},viewcrossmon,${toString t},${tagMonitor t}") (range 1 10);

  tagMoveBinds = concatMap (
    t:
    let
      key = tagKey t;
      n = toString t;
      mon = tagMonitor t;
    in
    [
      "SUPER+SHIFT,${key},tagcrossmon,${n},${mon}"
      "SUPER+SHIFT,${key},viewcrossmon,${n},${mon}"
    ]
  ) (range 1 10);

  screenshot =
    grimArgs:
    "mkdir -p ~/shots && f=~/shots/$(date +%Y-%m-%d_%H-%M-%S).png && grim ${grimArgs}\"$f\" && wl-copy < \"$f\"";
in
{
  config = mkIf (pkgs.stdenv.hostPlatform.isLinux && osConfig.host.profile.desktop) {
    home.activation.reloadMango = hm.dag.entryAfter [ "linkGeneration" ] ''
      if [[ ! -v DRY_RUN ]]; then
        for sock in /run/user/$(id -u)/mango-*.sock; do
          [[ -S $sock ]] || continue
          MANGO_INSTANCE_SIGNATURE=$sock \
            ${config.wayland.windowManager.mango.package}/bin/mmsg dispatch reload_config \
            || true
        done
      fi
    '';

    wayland.windowManager.mango = {
      enable = true;
      systemd.enable = true;

      autostart_sh = ''
        noctalia &
        tailscale systray &
      '';

      bottomPrefixes = [ "source" ];

      settings = {
        "source-optional" = [
          "~/.config/mango/noctalia.conf"
          "~/.config/mango/local.conf"
        ];

        env = [ "XCURSOR_SIZE,24" ];

        monitorrule = [
          "name:^${landscape}$,width:3840,height:2160,refresh:60,x:0,y:672,scale:1.25,rr:0"
          "name:^${portrait}$,width:3840,height:2160,refresh:60,x:3072,y:0,scale:1.25,rr:1"
        ];

        gappih = 5;
        gappiv = 5;
        gappoh = 20;
        gappov = 20;
        borderpx = 2;
        border_radius = 0;
        smartgaps = 0;
        focused_opacity = 1.0;
        unfocused_opacity = 1.0;
        rootcolor = "0x14121bff";
        bordercolor = "0x14121bff";
        focuscolor = "0xcdbdffff";

        blur = 1;
        blur_layer = 1;
        blur_optimized = 0;
        blur_params_num_passes = 1;
        blur_params_radius = 3;

        shadows = 1;
        layer_shadows = 0;
        shadow_only_floating = 0;
        shadows_size = 4;
        shadowscolor = "0x1a1a1aee";

        animations = 1;
        layer_animations = 1;
        animation_type_open = "zoom";
        animation_type_close = "zoom";
        zoom_initial_ratio = 0.87;
        zoom_end_ratio = 1.0;
        animation_duration_open = 410;
        animation_duration_close = 150;
        animation_duration_move = 480;
        animation_duration_tag = 194;
        animation_duration_focus = 0;
        animation_curve_open = "0.23,1,0.32,1";
        animation_curve_move = "0.23,1,0.32,1";
        animation_curve_close = "0,0,1,1";
        animation_curve_tag = "0.5,0.5,0.75,1";

        tag_num = 10;
        tagrule = map (t: "id:${toString t},layout_name:dwindle") (range 1 10);
        dwindle_preserve_split = 1;
        dwindle_manual_split = 0;

        xkb_rules_layout = "us";
        sloppyfocus = 1;
        trackpad_natural_scrolling = 0;
        cursor_size = 24;
        cursor_hide_timeout = 3;
        cursor_hide_on_keypress = 1;

        focus_cross_monitor = 1;
        xwayland_ignore_scale = 1;

        bind = [
          "SUPER,Return,spawn,${terminal}"
          "SUPER,w,spawn,${browser}"
          "SUPER,r,spawn,${menu}"
          "SUPER,Tab,spawn,noctalia msg window-switcher"
          "SUPER,e,spawn,noctalia msg session lock"
          "SUPER,comma,spawn,noctalia msg settings-toggle"
          "SUPER,n,spawn,noctalia msg panel-toggle control-center"

          "SUPER+SHIFT,q,killclient"
          "SUPER,f,togglefullscreen"
          "SUPER+SHIFT,space,togglefloating"
          "SUPER,v,dwindle_toggle_split_direction"

          "SUPER+SHIFT,c,reload_config"
          "SUPER+SHIFT,e,quit"

          "SUPER,left,focusdir,left"
          "SUPER,right,focusdir,right"
          "SUPER,up,focusdir,up"
          "SUPER,down,focusdir,down"

          "SUPER+SHIFT,left,exchange_client,left"
          "SUPER+SHIFT,right,exchange_client,right"
          "SUPER+SHIFT,up,exchange_client,up"
          "SUPER+SHIFT,down,exchange_client,down"

          "SUPER,bracketleft,focusmon,left"
          "SUPER,bracketright,focusmon,right"
          "SUPER+SHIFT,bracketleft,tagmon,left,1"
          "SUPER+SHIFT,bracketright,tagmon,right,1"

          "SUPER,space,spawn,wl-kbptr"

          "SUPER,s,spawn_shell,${screenshot "-g \"$(slurp)\" "}"
          "SUPER+SHIFT,s,spawn_shell,${screenshot ""}"
        ]
        ++ tagBinds;

        bindc = tagMoveBinds;

        bindl = [
          "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
          "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
          "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
          "NONE,XF86AudioMicMute,spawn,noctalia msg mic-mute"
          "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
          "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"
          "NONE,XF86AudioNext,spawn,noctalia msg media next"
          "NONE,XF86AudioPause,spawn,noctalia msg media toggle"
          "NONE,XF86AudioPlay,spawn,noctalia msg media toggle"
          "NONE,XF86AudioPrev,spawn,noctalia msg media previous"
        ];

        mousebind = [
          "SUPER,btn_left,moveresize,curmove"
          "SUPER,btn_right,moveresize,curresize"
        ];

        axisbind = [
          "SUPER,UP,viewtoleft_have_client"
          "SUPER,DOWN,viewtoright_have_client"
        ];

        gesturebind = [
          "none,left,3,viewtoleft"
          "none,right,3,viewtoright"
        ];

        layerrule = [
          "noanim:1,layer_name:noctalia-.*"
          "noblur:1,noanim:1,layer_name:^selection$"
        ];
      };
    };
  };
}
