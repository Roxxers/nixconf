{ pkgs, lib, config, ... }:
 


{
  home.packages = with pkgs; [
    starship
    zsh
  ];
  home.file = {
    omz_custom = {
      source = ./.omz_custom;
      # TODO: Figure out making this a variable
      target = ".config/zsh/omz_custom";
    };
    p10kTheme = {
      source = ./.p10k.zsh;
      target = ".p10k.zsh";
    };
    starshipConf = {
      source = ./starship.toml;
      target = ".config/starship.toml";
    };
  };
  programs.zsh = 
  let
  configDir = ".config/zsh";
  omz_custom = "${configDir}/omz_custom";
  kittyCompletion = if config.programs.kitty.enable == true then "kitty + complete setup zsh | source /dev/stdin\n" else "\n";
  kittyAliases = if config.programs.kitty.enable == true then {
    "klip" = "kitty +kitten clipboard"; # Kitty clipboard feature
    "icat" = "kitty +kitten icat"; # Image display
  } else {};
  # Running powerlevel10k
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  #powerlevel = "[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh";
  in
  {
    enable = true;
    dotDir = "${configDir}";
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      path = "${configDir}/zsh_history";
    };
    oh-my-zsh = {
      # Really need something here to deal with powerlevel
      enable = true;
      custom = "/home/roxie/${omz_custom}";
      #theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "extract"
        "git"
        "pass"
        "python"
        "virtualenvwrapper"
        "zsh-completions"
        "zsh-autosuggestions"
        "zsh-history-substring-search"
        "zsh-syntax-highlighting"
      ];
      extraConfig = kittyCompletion + ''eval "$(starship init zsh)"'';
    };
    sessionVariables = {
      # Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
      "PYTHONIOENCODING" = "UTF-8";
      # Pipenv config for making venvs in project dir
      "PIPENV_VENV_IN_PROJECT" = 1;

      # Go stuff
      # TODO: Replace this with a variable for go project stuff
      "GOPATH" = "$HOME/Projects/go";
      "GO111MODULE" = "on";
    };
    shellAliases = {
      # Easier navigation: .., ..., ...., .....
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      # vscode alias
      "c" = "${config.programs.vscode.package} ./";
      # ls stuff
      "ls" = "ls --color=auto";
      "la" = "ls -Ah";
      "ll" = "ls -lh";
      "lla" = "ls -Alh";
      "cls" = "colorls --dark";

    } // kittyAliases;
  };
}