{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Name your host machine
  networking.hostName = "nixos";

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Configure networking
  networking.useiwd = true;

  # Enter keyboard layout
  services.xserver.layout = "us";
  #services.xserver.xkbVariant = "altgr-intl";

  # Define user accounts
  users.users.shigure = {
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    isNormalUser = true;
  };

  # Autologin and start IceWM
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "true"
    '';
    libinput = {
      enable = true;
      tapping = true;
      naturalScrolling = true;
    };
    xkbOptions = "caps:escape";
    windowManager.icewm.enable = true;
    displayManager.defaultSession = "icewm";
    # Autologin without a display manager
    displayManager.autoLogin = {
      enable = true;
      user = "shigure";
    };
  };


  # Install some packages
  environment.systemPackages = with pkgs; [
    fish
    btop
    libreoffice
    kdenlive
    neovim
    vim
    imv
    wineWowPackages.stable
    protonup-qt
    qutebrowser
    tigervnc
    vesktop
    krita
    davinci-resolve-studio

  ];

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable Waydroid
  virtualisation.waydroid.enable = true;

  # Enable Steam
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Rule to disable the built-in keyboard when the Corne (idVendor=4653) is plugged in
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="4653", RUN+="/bin/sh -c 'echo 1 > /sys/devices/platform/i8042/serio0/input/input2/inhibited'"

    # Rule to re-enable the built-in keyboard when the Corne is unplugged
    # This rule is more general to better catch the remove event
    ACTION=="remove", ENV{ID_VENDOR_ID}=="4653", RUN+="/bin/sh -c 'echo 0 > /sys/devices/platform/i8042/serio0/input/input2/inhibited'"
  '';

  system.stateVersion = "23.11"; # Did you read the comment?

}
