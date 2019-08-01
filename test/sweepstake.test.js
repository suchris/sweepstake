let BN = web3.utils.BN
let Sweepstake = artifacts.require('Sweepstake')
let SweepstakeFactory = artifacts.require('SweepstakeFactory')
let catchRevert = require("./exceptionsHelpers.js").catchRevert

contract('Sweepstake', function(accounts) {
    const owner = accounts[0]
    const alice = accounts[1]
    const bob = accounts[2]
    const emptyAddress = '0x0000000000000000000000000000000000000000'

    const name = 'Fantastic Vacation'
    const prize = '10000000000000000'

    let instance

    beforeEach(async () => {
       instance = await Sweepstake.new(name, prize, owner)
       await instance.sendTransaction({from: owner, value: prize})
    })

    it("should emit event LogEntered when someone enters the sweepstake", async() => {
        let eventEmitted = false
        const tx = await instance.enterSweepstake({ from: alice })

        if (tx.logs[0].event == "LogEntered") {
            eventEmitted = true
        }
        assert.equal(eventEmitted, true, 'LogEntered is not emitted')

        const result = await instance.getPlayers()

        assert.equal(result[0], alice, 'the player address should be set to alice')
    })

    it("revert when sponsor try to enter a sweepstake", async() => {
        await catchRevert(instance.enterSweepstake({from: owner}))
    })

    it("revert when non sponsor try to select a winner", async() => {
        await catchRevert(instance.selectWinner({from: alice}))
    })

    it("revert when there's no player to select as a winner", async() => {
        await catchRevert(instance.selectWinner({from: owner}))
    })

    it("should emit event LogSeleted when a winner is selected", async() => {
        let eventEmitted = false

        await instance.enterSweepstake({from: alice})
        await instance.enterSweepstake({from: bob})

        const tx = await instance.selectWinner({from: owner})
        if (tx.logs[0].event == "LogSelected") {
            eventEmitted = true
        }
        assert.equal(eventEmitted, true, 'Should change state to Selected')
    })

    it("can't enter a sweepstake after winner is selected", async() => {
        let eventEmitted = false
        await instance.enterSweepstake({from: alice})
        await instance.selectWinner({from: owner})
        await catchRevert(instance.enterSweepstake({from: bob}))
    })

    it("can't select a winner after one is already selected", async() => {
        let eventEmitted = false
        await instance.enterSweepstake({from: alice})
        await instance.selectWinner({from: owner})
        await catchRevert(instance.selectWinner({from: owner}))
    })

    it("can't claim the prize if it's not the winner", async() => {
        let eventEmitted = false
        await instance.enterSweepstake({from: alice})
        await instance.selectWinner({from: owner})
        await catchRevert(instance.claimPrize({from: owner}))
    })

    it("emit event LogClaimed when winner claims the prize", async() => {
        let eventEmitted = false
        await instance.enterSweepstake({from: alice})
        await instance.selectWinner({from: owner})
        const tx = await instance.claimPrize({from: alice})

        if (tx.logs[0].event == "LogClaimed") {
            eventEmitted = true
        }

        assert.equal(eventEmitted, true, 'Prize is not claimed')
    })

    it("No balance left in sweepstake after winner claimed the prize", async() => {
        let eventEmitted = false
        await instance.enterSweepstake({from: alice})
        await instance.selectWinner({from: owner})
        await instance.claimPrize({from: alice})
        var contractBalance = await instance.getBalance()
        assert.equal(new BN(contractBalance).toString(), new BN(0).toString(), "contract balance is not zero")
    })

    it("Winner gets paid with the prize", async() => {
        let eventEmitted = false
        await instance.enterSweepstake({from: alice})
        await instance.selectWinner({from: owner})
        var aliceBalanceBefore = await web3.eth.getBalance(alice)
        await instance.claimPrize({from: alice})
        var aliceBalanceAfter = await web3.eth.getBalance(alice)
        assert.isAbove(Number(aliceBalanceAfter), Number(aliceBalanceBefore), "balance of winner is not correct, after balance should be above before balance")
        assert.isBelow(Number(aliceBalanceAfter), Number(new BN(aliceBalanceBefore).add(new BN(prize))), "balance of winner is not correct, after balance should be below before balance + prize")
    })
})