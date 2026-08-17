{ pkgs, inputs, ... }:
{
  imports = [ inputs.neux.nixosModules.default ];
}
