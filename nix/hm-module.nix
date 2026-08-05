# Home-manager module for SaySo speech-to-text
#
# Provides a systemd user service for autostart.
# Usage: imports = [ sayso.homeManagerModules.default ];
#        services.sayso.enable = true;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sayso;
in
{
  options.services.sayso = {
    enable = lib.mkEnableOption "SaySo speech-to-text user service";

    package = lib.mkOption {
      type = lib.types.package;
      defaultText = lib.literalExpression "sayso.packages.\${system}.sayso";
      description = "The SaySo package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.sayso = {
      Unit = {
        Description = "SaySo speech-to-text";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${cfg.package}/bin/sayso";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
