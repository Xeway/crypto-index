// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

struct Token {
    IERC20 addr;
    // percentage en % * 100, so that it supports 2 decimal places
    // e.g. 18.75% => 1875
    uint percentage;
}

contract CryptoIndex {
    Token[] public tokens;

    mapping(address => mapping(address => uint)) public shares;

    address public immutable quoteToken;

    ISwapRouter public immutable swapRouter;

    constructor(Token[] calldata _tokens, address _quoteToken, uint _amount, ISwapRouter _swapRouter) {
        // we verify that the list of token doesn't contains the quote token
        // other it would swap the same token which throws an error
        for (uint i = 0; i < _tokens.length; ++i) {
            if (_tokens[i] == _quoteToken) {
                _tokens[i] = _tokens[_tokens.length - 1];
                _tokens.pop();
            }
        }

        tokens = _tokens;
        quoteToken = _quoteToken;
        swapRouter = _swapRouter;

        if (_amount > 0) {
            buyTokens();
        }
    }

    function buyTokens(uint _amount) public {
        TransferHelper.safeTransferFrom(quoteToken, msg.sender, address(this), _amount);

        ISwapRouter m_swapRouter = swapRouter;

        TransferHelper.safeApprove(DAI, address(m_swapRouter), amountIn);

        Token[] m_tokens = tokens;

        for (uint i = 0; i < m_tokens.length; ++i) {
            uint amountIn = msg.value / 10000 * m_tokens[i].percentage;

            ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
                tokenIn: USDC,
                tokenOut: m_tokens[i].addr,
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            amountOut = m_swapRouter.exactInputSingle(params);
            shares[msg.sender][m_tokens[i].addr] += amountOut;
        }
    }
}
