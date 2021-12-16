"""Handle backup and restore of vscode extensions."""
from subprocess import run, PIPE
import sys

VSCODEPATH = "/usr/bin/code"


def backup():
    """Backup vscode extensions."""
    print("Running backup...")
    # Retrieve vscode extensions list
    extensions_list = (run([VSCODEPATH, "--list-extensions"],
                           stdout=PIPE,
                           check=False))

    # Write vscode extensions list to file
    with open("extensions.txt", "a", encoding="utf-8") as file:
        file.write(extensions_list.stdout.decode('utf-8'))
        file.close()
    print("Extensions list written to extensions.txt")


def restore():
    """Restore vscode extensions."""
    print("Restoring extensions...")
    # Retrieve currently installed extensions list
    extensions_list = (run([VSCODEPATH, "--list-extensions"],
                           stdout=PIPE,
                           check=False))
    # Retrieve vscode extensions list
    try:
        with open("extensions.txt", "r", encoding="utf-8") as file:
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


def main():
    """Determine which function to run."""
    if sys.argv[1] == "restore":
        restore()
    elif sys.argv[1] == "backup":
        backup()


main()
