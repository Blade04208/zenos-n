{ pkgs, inputs, ... }:
{
  home-manager.sharedModules = [
    inputs.neux.homeManagerModules.default
  ];
}
