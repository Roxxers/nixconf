{ pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      path = "j564983s.default";
      settings = {
        # Privacy changes
        # https://www.privacytools.io/browsers/#about_config
        "privacy.firstparty.isolate" = true;
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "browser.send_pings" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "dom.event.clipboardevents.enabled" = false;
        "media.eme.enabled" = false;
        "media.gmp-widevinecdm.enabled" = false;
        "media.navigator.enabled" = false;
        "network.cookie.cookieBehavio" = 1;
        "network.http.referer.XOriginPolicy" = 1;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "webgl.disabled" = true;
        "browser.sessionstore.privacy_level" = 2;
        "beacon.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;
        "network.prefetch-next" = false;
        "network.IDN_show_punycode" = true;
      };
    };
  };
}