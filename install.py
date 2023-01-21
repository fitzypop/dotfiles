# import argparse
import os
import subprocess
import sys

MACOS = sys.platform == "darwin"
LINUX = sys.platform.startswith("linux")
SHELL = os.getenv("SHELL", "")
WINDOWS = sys.platform.startswith("win") or (sys.platform == "cli" and os.name == "nt")


def _run_as_root():
    if os.geteuid() == 0:
        print("We're root!")
    else:
        print("We're not root.")
        subprocess.call(["sudo", "python3", *sys.argv])
        sys.exit()


def mac_installer() -> int:
    xcode_cmd = "xcode-select --install"
    brew_cmd = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

    print(f'installing dev tools with "{xcode_cmd}"')
    subprocess.run(xcode_cmd, shell=True)

    print("installing homebrew")
    subprocess.run(brew_cmd, shell=True)

    print("installing necessary packages with brew")
    subprocess.run("brew install git just", shell=True)

    # clone dotfiles repo
    subprocess.run("git clone git@github.com:fitzypop/dotfiles.git $HOME/.dotfiles")

    print("Installing remaining brew packages")
    subprocess.run("just brewinstall", shell=True)

    print("installing virtualenv")
    subprocess.run("pipx install virutalenv", shell=True)

    print("Adding fish shell to /etc/shells")
    with open("/etc/shells", "a") as myfile:
        myfile.write("/opt/homebrew/bin/fish")

    subprocess.run("chsh -s $(which fish)")

    print("All done! Close terminal session and re-open")
    return 0


def main() -> int:
    _run_as_root()
    # parser = argparse.ArgumentParser(
    #     description="Installs the latest version of Fitzypop's dotfiles."
    # )
    if WINDOWS:
        sys.stderr.write(
            "Sorry, this script doesn't support windows systems right now."
        )
        return 1

    if MACOS:
        return mac_installer()

    return 2


if __name__ == "__main__":
    raise SystemExit(main())
