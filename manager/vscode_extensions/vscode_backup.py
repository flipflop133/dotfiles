"""Handle backup and restore of vscode extensions."""
from subprocess import run, PIPE
import sys
import os

VSCODEPATH = "/usr/bin/code"
EXTENSIONSPATH = f"{os.path.dirname(os.path.realpath(__file__))}/extensions.txt"

def backup():
    """Backup vscode extensions."""
    print("Running extensions backup...")
    # Retrieve vscode extensions list
    extensions_list = (run([VSCODEPATH, "--list-extensions"],
                           stdout=PIPE,
                           check=False))

    # Write vscode extensions list to file
    with open(EXTENSIONSPATH, "w", encoding="utf-8") as file:
        file.write(extensions_list.stdout.decode('utf-8'))
        file.close()
    print(f"Extensions list written to {EXTENSIONSPATH}")


def restore():
    """Restore vscode extensions."""
    print("Restoring extensions...")
    # Retrieve currently installed extensions list
    extensions_list = (run([VSCODEPATH, "--list-extensions"],
                           stdout=PIPE,
                           check=False))
    # Retrieve vscode extensions list
    try:
        with open(EXTENSIONSPATH, "r", encoding="utf-8") as file:
            extensions = file.read().split()
            up_to_date = True
            for extension in extensions:
                if extension not in extensions_list.stdout.decode('utf-8'):
                    up_to_date = False
                    print(f"Installing {extension}")
                    run([VSCODEPATH, "--install-extension", extension],
                        stdout=PIPE,
                        check=False)

    except FileNotFoundError:
        print("Make sure you put extensions.txt file in the same directory\
                 as the script.")
        sys.exit()
    if up_to_date:
        print("You are already up to date!")
    else:
        print("successfully restore extensions!")
