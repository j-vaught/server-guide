"""Confirm that a small Python program runs on the remote workstation."""

import platform
import socket


def main() -> None:
    print("Hello from your CESR workstation.")
    print(f"Computer: {socket.gethostname()}")
    print(f"Python: {platform.python_version()}")
    print("The file transfer and remote Python test worked.")


if __name__ == "__main__":
    main()
