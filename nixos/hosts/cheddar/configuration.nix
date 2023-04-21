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
      ./services/mumble.nix
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

    fileSystems."/data" = {
      device = "/dev/vdb";
      fsType = "ext4";
    };

    environment.etc."gcp-instance-creds.json" = {
      source = ./gcp-instance-creds.json;
      mode = "0440";
    };

    networking = {
      networkmanager.enable = true;
      firewall.enable = false;

      hostName = "cheddar";
      domain = "bergmans.us";
    };

    time.timeZone = "Etc/UTC";

    users = {
      # Users can only be made declaratively
      mutableUsers = false;

      users.root.openssh.authorizedKeys.keys = slb.sshPubKeys;

      users.lucas = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = slb.sshPubKeys;
      };
    };

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    systemd.services."instance-key" = {
      description = "decrypt instance key";
      wantedBy = ["multi-user.target"];
      before = ["acme-cheddar.bergmans.us.service"];
      serviceConfig = {
        Type = "oneshot";
        UMask = 0337;
      };
      path = [
        pkgs.jq
        pkgs.ssh-to-age
        pkgs.sops
      ];

      script = ''
        install -m 0440 -g ${config.security.acme.defaults.group} \
          /dev/null /run/gcp-instance-creds.json
        env SOPS_AGE_KEY=$(ssh-to-age -private-key < /etc/ssh/ssh_host_ed25519_key) \
          sops -d /etc/gcp-instance-creds.json > /run/gcp-instance-creds.json

        install -m 0444 /dev/null /run/gcp-creds.env
        cat >/run/gcp-creds.env <<EOF
        GCE_PROJECT=$(jq -r .project_id </run/gcp-instance-creds.json)
        GCE_SERVICE_ACCOUNT_FILE=/run/gcp-instance-creds.json
        EOF
      '';
    };

    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "lucas@bergmans.us";
        dnsProvider = "gcloud";
        credentialsFile = "/run/gcp-creds.env";
      };

      certs."cheddar.bergmans.us" = {};
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?
  }
