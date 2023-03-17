{ pkgs, ... }:

{

  imports =
    [
      ./brockman/nix/module.nix
    ];

  services.brockman = {
    enable = true;
    package = pkgs.haskellPackages.callPackage ./brockman {};
    config = {
      channel = "#hsmr";
      irc = {
        host = "irc.hackint.org";
        port = 6697;
        tls = true;
      };
      bots = {
        wickie = {
          feed = "http://localhost:3162/hsmr-recent-changes.rss";
          delay = 30;
        };
      };
    };
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers."html2rss" = {
    ports = [ "3162:3000" ];
    image = "gilcreator/html2rss-web";
    volumes = [
      "/etc/nixos/machines/sicily/includes/wickie/html2rss/feeds.yml:/app/config/feeds.yml"
    ];
    environment = {
      RACK_ENV = "production";
    };
  };

}
