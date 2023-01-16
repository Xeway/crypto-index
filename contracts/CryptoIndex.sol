// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

contract CryptoIndex {
    struct Token {
        address addr;
        // percentage en % * 100, so that it supports 2 decimal places
        // e.g. 18.75% => 1875
        uint percentage;
    }

    Token[] public tokens;

    mapping(address => mapping(address => uint)) public shares;

    address public immutable quoteToken;

    ISwapRouter public immutable swapRouter;

    constructor(Token[] memory _tokens, address _quoteToken, uint _amount, uint24 _fee, address _swapRouter) {
        // we verify that the list of token doesn't contains the quote token
        // other it would swap the same token which throws an error
        for (uint i = 0; i < _tokens.length; ++i) {
            if (_tokens[i].addr == _quoteToken) {
                _tokens[i] = _tokens[_tokens.length - 1];
                delete _tokens[_tokens.length - 1];
            }
        }

        tokens = _tokens;
        quoteToken = _quoteToken;
        swapRouter = ISwapRouter(_swapRouter);

        if (_amount > 0) {
            buyTokens(_amount, _fee);
        }
    }

    function buyTokens(uint _amount, uint24 _poolFee) public {
        address m_quoteToken = quoteToken;

        // Transfer the specified amount of DAI to this contract.
        TransferHelper.safeTransferFrom(m_quoteToken, msg.sender, address(this), _amount);

        ISwapRouter m_swapRouter = swapRouter;

        // Approve the router to spend DAI.
        TransferHelper.safeApprove(m_quoteToken, address(m_swapRouter), _amount);

        Token[] memory m_tokens = tokens;

        for (uint i = 0; i < ((m_tokens[m_tokens.length - 1].addr != address(0)) ? m_tokens.length : m_tokens.length - 1); ++i) {
            uint amountIn = _amount / 10000 * m_tokens[i].percentage;

            ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
                tokenIn: m_quoteToken,
                tokenOut: m_tokens[i].addr,
                fee: _poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

            uint amountOut = m_swapRouter.exactInputSingle(params);
            shares[msg.sender][m_tokens[i].addr] += amountOut;
        }
    }
}
