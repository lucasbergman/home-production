let
  slb.sshPubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIF3xjVDP5aujMnlsdemCWfMicDJLQBPKl9vwzceAo8V lucas@errol"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDoNx5swAaaZgjoZ2QYnoHwgt7lBu3vbrcwWv5W/0sl8MSctF2c8dN7/Hquyk1TJ1FuwD6cIbktCZHSu2pmOmfVhzABspmL1+U89nwzS8aJTIaaSHdouvoQ1eHHSW4z01/KWXO+awd1vX+TU67pLB2I/N3nrYaLZsMgxg/tugxIkrRQZoEwJ2Q4uqIQnZ9lRamloKDoDa9ofMLgJHFQ56SRUfBNSDehTdowPUg6NwpZbfiCTYQlpXDer3IKpW7HeEwJnYJ5JPRbbVQ6n+6ULLkKcrpj5qdNTLL+V7SKDvMI44vyzHBkwY3DzNJcyPL8RwHNlAq2JrYs5kfe62YcDVP/ lucas@hedwig"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICxQDnZ2MZ0Q+APiJ7u3MnJ+T23uNTkwyf5R6YJwzX49 lucas@hedwig"
  ];
in
  {
    config,
    pkgs,
    ...
  }: {
    imports = [
      ./hardware-configuration.nix
    ];

    nix = {
      settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
    };

    # Use the GRUB 2 boot loader
    boot.loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/vda";
    };

    networking = {
      networkmanager.enable = true;

      hostName = "cheddar";
      domain = "bergmans.us";
    };

    time.timeZone = "Etc/UTC";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.lucas = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = slb.sshPubKeys;
    };

    users.users.root = {
      openssh.authorizedKeys.keys = slb.sshPubKeys;
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    # environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #   wget
    # ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.openssh.passwordAuthentication = false;
    users.mutableUsers = false;

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
    system.stateVersion = "22.11"; # Did you read the comment?
  }
