#!/usr/bin/env python3

from pwn import *

{bindings}

context.binary = {bin_name}
context.terminal = ["kitty", "--detach", "-o", "remember_window_size=no", "-o", "initial_window_width=80c", "-o", "initial_window_height=24c"]

gdbscript = """
"""

def conn():
    if args.LOCAL:
        r = process({proc_args})
        if args.GDB:
            gdb.attach(r, gdbscript)
    else:
        r = remote("addr", 1337)

    return r


def main():
    r = conn()

    # good luck pwning :)
    
    r.interactive()


if __name__ == "__main__":
    main()
