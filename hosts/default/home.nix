{ config, pkgs, pkgs-unstable, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "idanko";
  home.homeDirectory = "/home/idanko";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w" # required for viber
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (pkgs.callPackage ./fdir.nix { })
    (pkgs.google-cloud-sdk.withExtraComponents
      [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    pkgs-unstable.elixir
    pkgs-unstable.elixir-ls
    pkgs-unstable.neovim
    pkgs-unstable.qbittorrent
    pkgs-unstable.signal-desktop
    pkgs-unstable.teams-for-linux
    pkgs-unstable.yt-dlp
    pkgs.alacritty # terminal of choice
    pkgs.anki
    pkgs.ansible
    pkgs.bemenu
    pkgs.bloomrpc
    pkgs.ccls # Language Server Protocol based on Clang
    pkgs.clang-tools
    pkgs.cliphist
    pkgs.clipnotify
    pkgs.cmake
    pkgs.dconf
    pkgs.delve # golang debugger
    pkgs.devcontainer
    pkgs.discord
    pkgs.dive # inspect docker images
    pkgs.docker-compose
    pkgs.emmet-ls
    pkgs.espeak # speach-module for speechd
    pkgs.filezilla
    pkgs.firefox
    pkgs.foliate # awz3 viewer
    pkgs.gimp
    pkgs.gnome.dconf-editor
    pkgs.gnome.gnome-tweaks
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.unite # merge title with gnome top dock
    pkgs.go
    pkgs.golangci-lint # golang linter package
    pkgs.golines # split long code lines in golang
    pkgs.google-chrome
    pkgs.gopls # golang language server protocol
    pkgs.gotools # set of go language code tools
    pkgs.graphviz
    pkgs.imv # image viewer
    pkgs.inkscape
    pkgs.krita
    pkgs.kubectl
    pkgs.lazygit
    pkgs.lf # terminal file manager
    pkgs.libnotify # provides notify-send
    pkgs.libreoffice-fresh # ms office, but better
    pkgs.libxml2 # xmllint
    pkgs.lua-language-server
    pkgs.luajit # lua interpreter
    pkgs.meld # diff folders and files
    pkgs.memtester # memory test
    pkgs.mpv
    pkgs.ngrok # route tcp from the public internet url to your host machine
    pkgs.nixd
    pkgs.nixfmt-classic
    pkgs.nodePackages.eslint # javascript linter
    pkgs.nodePackages.prettier # javascript formatter
    pkgs.nodePackages.pyright # python code formatter
    pkgs.nodePackages.typescript-language-server # typescript language server protocol
    pkgs.nodejs
    pkgs.obs-studio # record camera and desktop
    pkgs.opera
    pkgs.papirus-icon-theme
    pkgs.pistol # file previewer written in go
    pkgs.pkgs.pandoc # convert/generate documents in different formats
    pkgs.rlwrap # wrap a command to make stdin interactive
    pkgs.speechd # speech-dispatcher for foliate
    pkgs.stylua
    pkgs.tailwindcss-language-server
    pkgs.telegram-desktop
    pkgs.terraform
    pkgs.terraform-ls
    pkgs.texliveFull
    pkgs.thunderbird
    pkgs.tmux
    pkgs.typescript
    pkgs.vagrant
    pkgs.viber
    pkgs.vscode-langservers-extracted # cssls
    pkgs.wezterm
    pkgs.wireshark
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.xorg.xhost # execute `xhost +` to share clipboard between a docker container and host machine
    pkgs.yarn
    pkgs.zk # zettelkasten cli
    pkgs.zotero # citation tool
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Numix-Square";
      package = pkgs.numix-icon-theme-square;
    };
  };

  # NOTE: to see changes using gnome-tweaks (or any other method) use `dconf watch /` command.
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        text-scaling-factor = 1.25;
        font-name = "Ubuntu Medium 11";
        document-font-name = "Ubuntu Regular 11";
        monospace-font-name = "JetBrainsMono Nerd Font Mono 11";
        font-antialiasing = "rgba";
        font-hinting = "slight";
        clock-show-weekday = true;
        enable-hot-corners = false; # disable top-left hot corner.
      };
      "org/gnome/desktop/input-sources" = {
        sources = [
          (lib.gvariant.mkTuple [ "xkb" "us" ])
          (lib.gvariant.mkTuple [ "xkb" "ua" ])
        ];
        xkb-options =
          [ "terminate:ctrl_alt_bksp" "caps:ctrl_modifier" ]; # use caps as ctrl
      };
      "org/gnome/desktop/wm/keybindings" = { show-desktop = [ "<Super>d" ]; };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
        {
          binding = "<Control><Alt>h";
          command = "bemenu-commander cliphist";
          name = "Clipboard History";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
        {
          binding = "<Control><Alt>u";
          command = "bemenu-commander ref";
          name = "Ref";
        };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
        {
          binding = "<Control><Alt>i";
          command = "bemenu-commander ref-data";
          name = "Ref-Data";
        };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-temperature = (lib.gvariant.mkUint32 3700);
      };

      "org/gnome/shell" = {
        enabled-extensions = [ "dash-to-dock@micxgx.gmail.com" ];
        last-selected-power-profile = "performance";
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 900; # 15min
        sleep-inactive-ac-type = "suspend";
      };
      "org/gnome/desktop/session" = {
        idle-delay = (lib.gvariant.mkUint32 300); # 5min
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = false;
        dock-position = "BOTTOM";
        transparency-mode = "FIXED";
        background-opacity = 1.0;
        height-fraction = 1.0;
        dash-max-icon-size = 36;
        extend-height = true;
        show-apps-always-in-the-edge = false;
        dock-fixed = true;
        custom-theme-shrink = true;
        custom-background-color = true;
        isolate-workspaces = true;
        show-apps-at-top = true;
        background-color = "rgb(0,0,0)";
        running-indicator-style = "DOTS";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  xresources.properties = {
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintslight";
    "Xft.hinting" = true;
    "Xft.antialias" = true;
    "Xft.rgba" = "rgb";
  };

  systemd.user.services.cliphist-store = {
    Unit = {
      Description =
        "X11 service. Listen to clipboard events and pipe them to cliphist.";
    };
    Service = {
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c 'while ${pkgs.clipnotify}/bin/clipnotify; do ${pkgs.xclip}/bin/xclip -o -selection c | ${pkgs.cliphist}/bin/cliphist store; done'
      '';
      Restart = "always";
      TimeoutSec = 3;
      RestartSec = 3;
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  systemd.user.services.yarr = {
    Unit = {
      Description =
        "RSS / Atom viewer HTTP service, running on localhost port 7070";
    };
    Service = {
      ExecStart = ''
        ${pkgs.yarr}/bin/yarr
      '';
      Restart = "always";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/idanko/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
