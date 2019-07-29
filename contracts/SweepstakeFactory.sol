pragma solidity ^0.5.0;
import "./Sweepstake.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
contract SweepstakeFactory is Pausable {

    address owner;
    /// array for all of the sweepstakes created
    address[] sweepstakes;

    constructor ()
        public
    {
        owner = msg.sender;
    }

    /// @dev log when a sweepstake is created
    /// @param sweepstake of created sweepstake
    /// @param numSweepstakes The number of sweepstakes
    /// @param sweepstakes All sweepstakes in the system
    event LogSweepstakeCreated(address sweepstake, uint numSweepstakes, address[] sweepstakes);

    /// @notice factory method to create a new Sweepstake contract
    /// @param _name The sweepstake's name
    /// @dev emit LogSweepstakeCreated event
    function createSweepstake(string memory _name)
        public
        payable
        whenNotPaused
    {
        Sweepstake theSweepstake = new Sweepstake(_name);
        sweepstakes.push(address(theSweepstake));
        emit LogSweepstakeCreated(address(theSweepstake), sweepstakes.length, sweepstakes);
    }

    /// @notice get owner
    /// @return return owner address
    function getOwner()
        public
        view
        returns (address)
    {
        return owner;
    }

    /// @notice get all sweepstakes
    /// @return array of sweepstakes
    function getSweepstakes()
        public
        view
        returns (address[] memory)
    {
        return sweepstakes;
    }
}