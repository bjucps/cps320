{
  description = "fhs shell for uv";
  inputs.unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  outputs = inputs: let
    system = "x86_64-linux";
  in {
    devShells."${system}".default =
      (
        (import inputs.unstable {inherit system;}).buildFHSEnv {
          name = "py";
          targetPkgs = pkgs:
            with pkgs; [
              python311
              uv
              ty
              ruff
              pyright
              libz
              fish
            ];
          runScript = "fish -C 'source ./.venv/bin/activate.fish'";
        }
      )
      .env;
  };
}
