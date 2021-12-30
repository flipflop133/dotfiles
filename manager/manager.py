import os
import subprocess
from shutil import which
from vscode_extensions.vscode_backup import backup as vscode_backup
from vscode_extensions.vscode_backup import restore as vscode_restore

SCRIPTPATH = os.path.dirname(os.path.realpath(__file__))
PACKAGESPATH = f"{SCRIPTPATH}/packages.txt"
SPACES = '  '


def backup():
    print("Running backup...\n")
    # Backup package list
    package_list = subprocess.run(["pacman", "-Qe"],
                                  capture_output=True,
                                  encoding='utf-8').stdout
    package_list = package_list.split()
    del package_list[1::2]  # Remove package version number
    f = open(PACKAGESPATH, "w")
    for package in package_list:
        f.write(f"{package}\n")
    print(f"Packages list written to {PACKAGESPATH}")
    f.close()
    # Backup vscode extensions
    vscode_backup()
    print("\nBackup completed!")


def restore():
    # Restore vscode extensions
    vscode_restore()
    # Restore dotfiles
    if which("stow") is None:
        subprocess.run(["sudo", "pacman", "-S", "stow", "--noconfirm"])
        os.system("clear")
    os.chdir("..")
    subprocess.run("stow $(find * -maxdepth 0 -type d -not -name manager)", shell=True)
    os.chdir(f'{SCRIPTPATH}')
    # Restore packages
    if which("paru") is None:
        install_paru()
    f = open(PACKAGESPATH, 'r')
    for package in f.readlines():
        subprocess.run(["paru", "-S", package.strip('\n'), "--noconfirm"])
        os.system("clear")


def install_paru():
    print("Paru is not installed.\nInstalling Paru...")
    subprocess.run(["sudo", "pacman", "-S", "--needed", "base-devel"])
    subprocess.run(["git", "clone", "https://aur.archlinux.org/paru.git"])
    os.chdir(f'{SCRIPTPATH}/paru')
    subprocess.run(["makepkg", "-si"])
    os.chdir(f'{SCRIPTPATH}')
    os.system("clear")


def menu():
    os.system("clear")
    selection = input(f"Menu\n{SPACES}1.Backup\n{SPACES}2.Restore\nChoice:")
    if selection == "1":
        os.system("clear")
        backup()
    elif selection == "2":
        os.system("clear")
        restore()
    else:
        menu()


menu()
