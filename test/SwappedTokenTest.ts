import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
require("@nomicfoundation/hardhat-ethers");


describe("SWAPPED TOKEN ", function (){

    async function deploySwappedToken(){

    const EmaxToken = await ethers.getContractFactory("EmaxToken");
    const  emaxToken = await EmaxToken.deploy();

    // const ErrorMessage = await ethers.getContractFactory("ErrorMessage");
    // const 

    const ManoToken = await ethers.getContractFactory("ManoToken");
    const  manoToken = await ManoToken.deploy();


    const [owner, account] = await ethers.getSigners();

    const SwappedToken = await ethers.getContractFactory("SwappedToken");

    const swappedToken = await SwappedToken.deploy(emaxToken.target, manoToken.target);

    return { emaxToken, manoToken, swappedToken, owner, account};
    }


    describe("Deployment", async () => {

        it("test that contract has been deployed", async () => {

        const { emaxToken, swappedToken, manoToken } = await loadFixture(deploySwappedToken);
        expect(await swappedToken.emaxToken()).to.equal(emaxToken.target);

        expect(await swappedToken.manoToken()).to.equal(manoToken.target);
        expect(await swappedToken.rateToken1ToToken2()).to.equal(1000);
        });

        describe("Exchange Mano Token", async () => {
          it("test that mano token can be exchanged", async () => {
              const { emaxToken, swappedToken, manoToken, owner, account } = await loadFixture(deploySwappedToken);
      
              const amountToExchange = 1000;
      
              const tx = await manoToken.connect(owner).approve(swappedToken.target, amountToExchange);
              await tx.wait();

              const emaxTx = await emaxToken.connect(owner).approve(swappedToken.target, 300000000);
              await emaxTx.wait();


              await swappedToken.transferEmaxFundToContract(500000);
          

              const tx1 = await swappedToken.connect(owner).manoTokenToEmaxToken(amountToExchange);

      
              const finalManoBalance = await swappedToken.checkWalletBalanceManoToken(owner.address);
              expect(finalManoBalance).to.equal(29999000);



              const checkContractBalance = await swappedToken.checkWalletBalanceEmaxToken(swappedToken.target);

              expect(checkContractBalance).to.equal(1000);


              const ownerBalanceOfEmaxToken = await swappedToken.checkWalletBalanceEmaxToken(owner.address);
              expect(ownerBalanceOfEmaxToken).to.equal(29999000);


              const contractBalanceOfEmaxToken = await swappedToken.checkWalletBalanceEmaxToken(swappedToken.target);
              expect(contractBalanceOfEmaxToken).to.equal(1000);
          });
      });
      
})
describe("Validation Check Of Swap", async () => {
  it("test that error will be thrown if for token less than 500", async () => {
      const { emaxToken, swappedToken, manoToken, owner, account } = await loadFixture(deploySwappedToken);

      const amountToExchange = 300;

      const tx = await manoToken.connect(owner).approve(swappedToken.target, amountToExchange);
      await tx.wait();

      await expect(swappedToken.connect(owner).manoTokenToEmaxToken(amountToExchange))
          .to.be.revertedWithCustomError(swappedToken, "AMOUNT_TOO_LOW_ERROR_FOR_SWAP()");
  });

  it("test that error will be thrown if account amount is greater balance for swap", async()=>{
    const { emaxToken, swappedToken, manoToken, owner, account } = await loadFixture(deploySwappedToken);

    const amountToExchange = 300000000;
    const tx = await manoToken.connect(owner).approve(swappedToken.target, amountToExchange);
    await tx.wait();

    await expect(swappedToken.connect(owner).manoTokenToEmaxToken(amountToExchange))
        .to.be.revertedWithCustomError(swappedToken, "INSUFFICIENT_BALANCE()");
  });


  it("test that error will be thrown if amount is amount swapped is greater than the contract balance ", async () => {
        const { emaxToken, swappedToken, manoToken, owner, account } = await loadFixture(deploySwappedToken);
      
              const amountToExchange = 100000;
      
              const tx = await manoToken.connect(owner).approve(swappedToken.target, amountToExchange);
              await tx.wait();

              const emaxTx = await emaxToken.connect(owner).approve(swappedToken.target, 300000000);
              // await emaxTx.wait();          

              await expect(swappedToken.connect(owner).manoTokenToEmaxToken(amountToExchange))
              .to.be.revertedWithCustomError(swappedToken,"UNABLE_TO_DISPENSE_TOKEN()");
  })

  })
});






