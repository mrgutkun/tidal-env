{
  outputs = { self, nixpkgs }: let system = "x86_64-linux"; in {
    devShell.${system} = with import nixpkgs { inherit system; }; mkShell {
      buildInputs = [
        (buildPackages.portaudio)
        (supercollider.overrideAttrs ( oldAttrs: rec { 
          cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DAUDIOAPI=portaudio" ] ; 
          buildInputs = oldAttrs.buildInputs ++ [ portaudio ] ;
        } ) )
        # supercollider
        (haskellPackages.ghcWithPackages (a: [a.tidal]))
        (writeScriptBin "superdirt" ''
          sclang superdirt.scd
        '')
        (writeScriptBin "tidal" ''
          ghci -ghci-script BootTidal.hs
        '')
      ];
    };
  };
}
