{ pkgs, ... }:

let
  iqn = "iqn.2015-12.com.oracleiaas:18a98fa3-f23d-46a1-8ac0-22365d2bc21f";
  ip = "169.254.2.3:3260";
in
{
  services.openiscsi = {
    enable = true;
    name = iqn;
  };

  systemd.services.iscsi-oracle-login = {
    description = "Login to Oracle iSCSI Volume";
    after = [
      "network-online.target"
      "iscsid.service"
    ];
    requires = [ "iscsid.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = [
        "${pkgs.openiscsi}/bin/iscsiadm -m node -o new -T ${iqn} -p ${ip}"
        "${pkgs.openiscsi}/bin/iscsiadm -m node -o update -T ${iqn} -n node.startup -v automatic"
        "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iqn} -p ${ip} -l"
      ];
      ExecStop = "${pkgs.openiscsi}/bin/iscsiadm -m node -T ${iqn} -u";
    };
  };

  fileSystems."/block" = {
    device = "/dev/disk/by-path/ip-${ip}-iscsi-${iqn}-lun-2";
    fsType = "ext4";
    options = [
      "_netdev"
      "x-systemd.requires=iscsi-oracle-login.service"
      "x-systemd.after=iscsi-oracle-login.service"
    ];
  };
}
