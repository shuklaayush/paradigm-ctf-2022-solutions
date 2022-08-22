#!/usr/bin/env python3
import json
from eth_utils import keccak, to_int, to_checksum_address, to_bytes, to_hex
from eth_abi.packed import encode_packed
from pprint import pprint


def decode_leaf_preimage(enc):
    index = to_int(enc[:32])
    account = to_checksum_address(enc[32:52])
    amount = to_int(enc[52:])
    return index, account, amount


def generate(proof, leaf, total_tokens, candidates):
    hash = leaf
    for i, elem in enumerate(proof):
        if hash < elem:
            preimage = hash + elem
        else:
            preimage = elem + hash

        index, account, amount = decode_leaf_preimage(preimage)
        if amount <= total_tokens:
            candidates.append(
                [index, account, amount, [to_hex(p) for p in proof[i + 1 :]]]
            )
        hash = keccak(preimage)
    return hash


def parse_entry(obj):
    index = obj["index"]
    amount = to_int(hexstr=obj["amount"])
    proof = [to_bytes(hexstr=p) for p in obj["proof"]]
    return index, amount, proof


def find_candidates(claims_obj, total_tokens):
    candidates = []
    for account, obj in claims_obj.items():
        index, amount, proof = parse_entry(obj)
        leaf = keccak(
            encode_packed(["uint256", "address", "uint96"], [index, account, amount])
        )

        generate(proof, leaf, total_tokens, candidates)

    return candidates


def print_entry(index, account, amount, proof, hexstr=False):
    print(f"Index: {index}")
    print(f"Account: {account}")
    print(f"Amount: {amount}")

    if hexstr:
        proof = [to_hex(p) for p in proof]
    print("Proof:")
    pprint(proof)


def find_pair(claims_obj, candidates, total_tokens):
    pairs = []
    for [index, account, amount, proof] in candidates:
        if amount < total_tokens:
            for account2, obj2 in claims_obj.items():
                index2, amount2, proof2 = parse_entry(obj2)

                if amount + amount2 == total_tokens:
                    pairs.append(
                        (
                            [index, account, amount, proof],
                            [index2, account2, amount2, proof2],
                        )
                    )
    return pairs


if __name__ == "__main__":
    with open("./tree.json") as f:
        obj = json.load(f)

        total_tokens = to_int(hexstr=obj["tokenTotal"])
        claims_obj = obj["claims"]

        candidates = find_candidates(claims_obj, total_tokens)
        pairs = find_pair(claims_obj, candidates, total_tokens)

        for p1, p2 in pairs:
            print("-" * 80)
            print_entry(*p1)
            print_entry(*p2, hexstr=True)
