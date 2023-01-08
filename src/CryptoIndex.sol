// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CryptoIndex {
    address[] public tokens;

    constructor(address[] memory _tokens) payable {
        tokens = _tokens;

        if (msg.value > 0) {
            buyTokens();
        }
    }

    function buyTokens() public {
        for (int i = 0; i < tokens.length; ++i) {
            
        }
    }
}
