#!/usr/bin/env python3
from eth_abi import encode
from eth_utils import keccak, to_bytes
from hashlib import sha256
from hexbytes import HexBytes

SELECTOR = HexBytes(keccak(text="isValidSignature(bytes32,bytes)")[:4])
MAGIC = HexBytes(keccak(text="CHALLENGE_MAGIC"))

def sha256b(data):
    sha = sha256(data)
    return HexBytes(sha.hexdigest())

if __name__ == "__main__":
    n = 0
    while True:
        signature = to_bytes(n)
        cdata = HexBytes(SELECTOR + encode(["bytes32", "bytes"], [MAGIC, signature]))
        hash = sha256b(cdata)
        if hash[:4] == SELECTOR:
            break
        n += 1
    print(n, signature.hex())
