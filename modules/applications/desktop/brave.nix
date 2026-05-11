{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    brave
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };

  # Brave does not provide a convenient way to manage browser settings via dotfiles.
  # However, a group policy file can be used as a workaround to solve this problem.
  # A complete list of available policies is shown on the brave://policy/ page when the Show policies with no value set checkbox is enabled.
  # The same page can also be used to verify whether the settings have been applied.
  #
  # Brave group policy documentation is available at: https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy
  # Brave supports the same policies as Chromium, along with additional Brave-specific policies, (e.g managing Shields).
  # For policy and setting descriptions, the Google Chrome Enterprise policy reference
  # can also be used: https://chromeenterprise.google/intl/en_ca/policies/
  xdg.configFile."brave-policies.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = false;
    BraveNewsDisabled = true;
    BraveTalkDisabled = true;
    BraveWebDiscoveryEnabled = false;
    BraveP3AEnabled = false;
    BraveSpeedreaderEnabled = false;
    TorDisabled = true;

    # brave://settings/getStarted
    RestoreOnStartup = 1; # continue where you left

    # brave://settings/appearance
    ShowHomeButton = false;
    ShowFullUrlsInAddressBar = true;

    # brave://settings/shields
    DefaultBraveHttpsUpgradeSetting = 3; # standard upgrade
    BlockThirdPartyCookies = true;
    DefaultBraveRemember1PStorageSetting = 2; # forget me when I close the site
    # DefaultBraveAdblockSetting": 2,

    # brave://settings/braveSync/setup
    SyncTypesListDisabled = [
      "readingList"
      "tabs"
      "autofill"
      "passwords"
    ];

    # brave://settings/searchEngines
    SiteSearchSettings = [
      {
        name = "NixOS packages";
        shortcut = "nx";
        url = "https://search.nixos.org/packages?query={searchTerms}";
      }
    ];

    # brave://settings/extensions
    ExtensionInstallForcelist = [
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    ];

    # brave://settings/languages
    SpellcheckLanguage = [
      "en-US"
      "ru"
    ];
  };
}
