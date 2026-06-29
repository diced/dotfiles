{ pkgs, config, ... }:

{
  sops = {
    secrets = {
      "services/iscsi/iqn" = { };
      "services/iscsi/ip" = { };
    };
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.placeholder.unused";
  };

  systemd.services.iscsi-oracle-login = {
    description = "iscsi mount";
    after = [
      "network-online.target"
      "iscsid.service"
    ];
    requires = [ "iscsid.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "iscsi-login" ''
        IQN=$(cat ${config.sops.secrets."services/iscsi/iqn".path})
        IP=$(cat ${config.sops.secrets."services/iscsi/ip".path})

        ${pkgs.openiscsi}/bin/iscsiadm -m node -o new -T "$IQN" -p "$IP"
        ${pkgs.openiscsi}/bin/iscsiadm -m node -o update -T "$IQN" -n node.startup -v automatic
        ${pkgs.openiscsi}/bin/iscsiadm -m node -T "$IQN" -p "$IP" -l

        DEVICE_PATH="/dev/disk/by-path/ip-$IP-iscsi-$IQN-lun-2"
        for i in {1..15}; do
          if [ -b "$DEVICE_PATH" ]; then
            ln -sf "$DEVICE_PATH" /dev/iscsi-disk
            ${pkgs.coreutils}/bin/mkdir -p /block
            ${pkgs.util-linux}/bin/mount -t ext4 -o _netdev "$DEVICE_PATH" /block
            exit 0
          fi
          sleep 1
        done
        exit 1
      '';
      ExecStop = pkgs.writeShellScript "iscsi-logout" ''
        IQN=$(cat ${config.sops.secrets."services/iscsi/iqn".path})
        echo "Unmounting /block and logging out..."
        umount /block || true
        ${pkgs.openiscsi}/bin/iscsiadm -m node -T "$IQN" -u
      '';
    };

  };

}
