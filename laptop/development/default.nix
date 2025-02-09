{pkgs, ...}: {
  imports = [
    ./kitty.nix
    ./lf.nix
    ./starship.nix
    ./python.nix
    ./rust.nix
    ./go.nix
    ./neovim.nix
  ];
  
  home.packages = with pkgs; [
    helix
    ripgrep
    fzf
    tree
    gitui
    zola
    minify
    gnumake
    # rpi-imager 
    #jdk17
    #gradle
    #jetbrains.idea-community
  ];
 
  programs.vscode = {
    enable = true;
    # package = pkgs.vscode.fhs;
  };
}


