// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../contracts/CryptoIndex.sol";

contract CryptoIndexTest is Test {
    /*Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }*/

    CryptoIndex public cryptoIndex;

    function setUp() public {
        CryptoIndex.Token[] memory tokens = new CryptoIndex.Token[](10);
        tokens[0] = CryptoIndex.Token(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984, 1000); // UNI - 10%
        tokens[1] = CryptoIndex.Token(0x514910771AF9Ca656af840dff83E8264EcF986CA, 1000); // LINK - 10%
        tokens[2] = CryptoIndex.Token(0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9, 1000); // AAVE - 10%
        tokens[3] = CryptoIndex.Token(0x85F17Cf997934a597031b2E18a9aB6ebD4B9f6a4, 1000); // NEAR - 10%
        tokens[4] = CryptoIndex.Token(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2, 1000); // MKR - 10%
        tokens[5] = CryptoIndex.Token(0x4d224452801ACEd8B2F0aebE155379bb5D594381, 1000); // APE - 10%
        tokens[6] = CryptoIndex.Token(0xc00e94Cb662C3520282E6f5717214004A7f26888, 1000); // COMP - 10%
        tokens[7] = CryptoIndex.Token(0x111111111117dC0aa78b770fA6A738034120C302, 1000); // 1INCH - 10%
        tokens[8] = CryptoIndex.Token(0x0D8775F648430679A709E98d2b0Cb6250d2887EF, 1000); // BAT - 10%
        tokens[9] = CryptoIndex.Token(0xc944E90C64B2c07662A292be6244BDf05Cda44a7, 1000); // GRT - 10%

        cryptoIndex = new CryptoIndex(
            tokens,
            0x7EA2be2df7BA6E54B1A9C70676f668455E329d29, // USDC
            3500000000, // 3500 USDC
            3000, // 0.3% fees
            0xE592427A0AEce92De3Edee1F18E0157C05861564 // SwapRouter
        );

        assertEq(cryptoIndex.quoteToken(), 0x7EA2be2df7BA6E54B1A9C70676f668455E329d29);
    }
}
