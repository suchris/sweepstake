let SweepstakeFactory = artifacts.require('SweepstakeFactory')
let catchRevert = require("./exceptionsHelpers.js").catchRevert

contract('SweepstakeFactory', function(accounts) {
    const owner = accounts[0]
    const alice = accounts[1]
    
    let factory
    
    beforeEach(async () => {
        factory = await SweepstakeFactory.new()
    })

    it('should start out knowing the owner', async () => {
        const factoryOwner = await factory.getOwner()
        assert.equal(owner, factoryOwner, 'The sweepstake factory owner should be the owner')
    })
    
    it('should start in non paused mode', async () => {
        const state = await factory.paused()
        assert.isFalse(state)
    })
    
    it('should be pausable by the owner', async () => {
        await factory.pause({ from: owner })
        const state = await factory.paused()
        assert.isTrue(state)
    })

    it('should guard the create sweepstake method', async () => {
        await factory.pause({ from: owner })
        const state = await factory.paused()
        assert.isTrue(state)
        catchRevert(factory.createSweepstake('Fantastic Vacation'))
    })

    it('should be unpausable by owner', async () => {
        await factory.pause({ from: owner })
        let state = await factory.paused()
        assert.isTrue(state)
        
        await factory.unpause({ from: owner })
        state = await factory.paused()
        assert.isFalse(state)
    })
    
    it('should not be unpausable by others', async () => {
        await factory.pause({ from: owner })
        let state = await factory.paused()
        assert.isTrue(state)
        catchRevert(factory.pause({ from: alice }))
    })
})
