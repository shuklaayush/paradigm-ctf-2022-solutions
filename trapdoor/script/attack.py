#!/usr/bin/env python3
import json
import os
import socket


HOST = "34.68.217.8"
PORT = 31337

TICKET = os.getenv("TICKET")


def get_bytecode(fn="Factorizor", contract="Factorizor"):
    with open(f"out/{fn}.sol/{contract}.json", "r") as f:
        obj = json.load(f)
        return obj["deployedBytecode"]["object"][2:]


def read(s):
    r = s.recv(1024).decode()
    print(r)
    return r


def send(s, t):
    print(t)
    s.send(f"{t}\n".encode("ascii"))


if __name__ == "__main__":
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, PORT))

    read(s)
    read(s)
    send(s, 1)

    read(s)
    send(s, TICKET)

    read(s)

    send(s, get_bytecode())

    r = read(s)
    n1, n2, _ = [int(s) for s in r.split() if s.isdigit()]

    b = n1.to_bytes(32, "big") + n2.to_bytes(32, "big")
    print()
    print(f"Flag: {b.decode('ascii')}")

    s.close()
