import { expect } from "chai";
import erc20ABI from "../erc20.abi.json";
import { interfaces } from "../typechain-types/lib/v3-core/contracts";

const tokenList: string[] = [
    "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984", // UNI
    "0x514910771AF9Ca656af840dff83E8264EcF986CA", // LINK
    "0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9", // AAVE
    "0x85F17Cf997934a597031b2E18a9aB6ebD4B9f6a4", // NEAR
    "0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2", // MKR
    "0x4d224452801ACEd8B2F0aebE155379bb5D594381", // APE
    "0xc00e94Cb662C3520282E6f5717214004A7f26888", // COMP
    "0x111111111117dC0aa78b770fA6A738034120C302", // 1INCH
    "0x0D8775F648430679A709E98d2b0Cb6250d2887EF", // BAT
    "0xc944E90C64B2c07662A292be6244BDf05Cda44a7"  // GRT
];

async function giveToken(tokenAddress: string, whales: string[], recipient: string) {
    for (let whale of whales) {
        const impersonatedSigner = await ethers.getImpersonatedSigner(whale);
        const erc20 = new ethers.Contract(tokenAddress, erc20ABI, impersonatedSigner);

        erc20.transfer(recipient, erc20.balanceOf(whale));
    }
}

describe("CryptoIndex", function () {
    describe("Deployment", function() {
        it("should deploy", async function() {
            const [owner, otherAccount] = await hre.ethers.getSigners();

            // giveToken("0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9", ["0x4da27a545c0c5B758a6BA100e3a049001de870f5"], owner.address);

            let tokens: [string, number][] = [];
            for (let token of tokenList) {
                tokens.push([token, 10000 / tokenList.length]);
            }

            const CryptoIndex = await hre.ethers.getContractFactory("CryptoIndex");
            const cryptoIndex = await CryptoIndex.deploy(
                tokens,
                "0x7EA2be2df7BA6E54B1A9C70676f668455E329d29", // USDC
                3500000000, // 3500 USDC
                3000, // 0.3% fees
                "0xE592427A0AEce92De3Edee1F18E0157C05861564", // SwapRouter
                { gasLimit: 3000000 }
            );

            console.log("Deployed contract with account : " + owner.address);

            expect((await cryptoIndex.quoteToken()).to.equal("0x7EA2be2df7BA6E54B1A9C70676f668455E329d29"));
        });
    });
});
