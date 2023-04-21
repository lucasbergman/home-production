let
  mumbleHost = "mumble.bergmans.us";
  dataDirectory = "/data/murmur";
in
  {
    lib,
    pkgs,
    ...
  }: {
    security.acme.certs."${mumbleHost}" = {
      reloadServices = ["murmur.service"];
    };

    # Putting the murmur server user in the acme group shouldn't be
    # necessary (you could just stuff some setfacl commands in a hook
    # script somewhere), but I couldn't get anything else to work
    users.users.murmur = {
      extraGroups = ["acme"];
    };

    # Make sure that the murmur server storage directory exists and
    # has the right ACLs; in particular, this helps if we move the
    # block storage volume from one VM instance to another and the
    # user/group ID for murmur changes in between the two instances.
    #
    # The documentation for system.activationScripts tries to make one
    # feel guilty about using this feature, but I do what I want.
    system.activationScripts."murmur-storage" = let
      dir = lib.escapeShellArg dataDirectory;
    in {
      deps = ["users" "groups"];
      text = ''
        if ! [[ -e ${dir} ]]; then
          install -d -m 750 -o murmur -g murmur ${dir}
        else
          chmod 750 ${dir}
          chown --recursive murmur:murmur ${dir}
        fi
      '';
    };

    # Write a sops-encrypted env file for murmur in /etc
    environment.etc."murmur-password.env" = {
      source = ./murmur-password.env;
      mode = "0440";
    };

    # Decrypt the env file to /run
    systemd.services."murmur-password" = {
      description = "decrypt murmur server password";
      wantedBy = ["multi-user.target"];
      before = ["murmur.service"];
      serviceConfig.Type = "oneshot";
      path = [
        pkgs.ssh-to-age
        pkgs.sops
      ];

      script = ''
        install -m 0440 -g murmur /dev/null /run/murmur-password.env
        env SOPS_AGE_KEY=$(ssh-to-age -private-key < /etc/ssh/ssh_host_ed25519_key) \
          sops -d /etc/murmur-password.env > /run/murmur-password.env
      '';
    };

    services.murmur = {
      enable = true;
      welcometext = (
        "Welcome to Mumble at ${mumbleHost}. "
        + "This server contains chemicals known to the state of California to cause cancer."
      );
      sslCert = "/var/lib/acme/${mumbleHost}/cert.pem";
      sslKey = "/var/lib/acme/${mumbleHost}/key.pem";
      password = "$SERVER_PASSWORD";
      environmentFile = "/run/murmur-password.env";

      # Putting database= here is a bit scary since a different
      # hard-coded value appears earlier in the file, but Mumble's INI
      # file parsing seems to obey whatever value comes last
      extraConfig = ''
        database=${dataDirectory}/murmur.sqlite
      '';
    };
  }
