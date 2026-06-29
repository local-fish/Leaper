{
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
	};

	outputs = { self, nixpkgs }@inputs:
	let
		system = "x86_64-linux";
		
		pkgs = import inputs.nixpkgs{
			inherit system;
			config.allowUnfree = true;
			config.android_sdk.accept_license = true;
		};
		androidComposition = pkgs.androidenv.composeAndroidPackages {
			buildToolsVersions = [ "35.0.0" "34.0.0" "33.0.1" ];
			platformVersions = [ "36" "35" "34" "33" "28" ];
			abiVersions = [ "x86_64" "armeabi-v7a" "arm64-v8a" ];
			includeNDK = true;
			ndkVersions = [ "26.3.11579264" "27.0.12077973" ];
			cmakeVersions = [ "3.22.1" ];
		};
		androidSdk = androidComposition.androidsdk;
	in 
	{
		devShells.${system}.default = pkgs.mkShell rec {
			name="Leaper";
			ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
			GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2";
			packages = with pkgs; [
					flutter332
					androidSdk
					jdk17
					nodejs
				];
			shellHook="tmux -L Leaper new-session -A -s Leaper";
			};
		};
	}
