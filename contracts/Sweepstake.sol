pragma solidity ^0.5.0;

import "./provableAPI.sol";

contract Sweepstake is usingProvable {
    address owner;          // address of owner
    string name;            // name of sweepstake
    uint prize;             // prize of sweepstake
    address[] players;      // all player that entered the sweepstake
    address winner;         // winner selected
    State state;            // state of the contract

    // 3 states for a contract, open to enter, winner is selected, prize is claimed
    enum State {Opened, Selected, Claimed}

    event LogOpened (string _name);
    event LogSelected (address _player);
    event LogClaimed (address _player);
    event LogEntered (address _player);
    event LogRandomNumber(uint _number);

    /// @notice create a new sweepstake
    /// @param _name name of the sweepstake
    /// @dev emit LogOpened event
    constructor (string memory _name)
        public
        payable
    {
        owner = msg.sender;
        name = _name;
        prize = msg.value;
        state = State.Opened;
        emit LogOpened(name);
    }

    /// @notice check if caller is owner
    modifier isOwner() {
        require (
            msg.sender == owner,
            "Caller is not owner"
        );
        _;
    }

    /// @notice check if caller is not owner
    modifier isNotOwner() {
        require (
            msg.sender != owner,
            "Caller is owner"
        );
        _;
    }

    /// @notice check if sweepstake is opened to enter
    modifier isOpened() {
        require (
            state == State.Opened,
            "Sweepstake is not opened to enter"
        );
        _;
    }

    /// @notice check if winner is selected
    modifier isSelected() {
        require (
            state == State.Selected,
            "Winner is not selected for the Sweepstake"
        );
        _;
    }

    /// @notice check if caller is winner
    modifier isWinner() {
        require (
            msg.sender == winner,
            "Caller is not the winner"
        );
        _;
    }

    /// @notice check if sweepstake has players entered
    modifier hasPlayers() {
        require (
            players.length > 0,
            "There's no player in this sweepstake"
        );
        _;
    }

    /// @notice caller can enter sweepstake
    /// @dev emit LogEntered event
    function enterSweepstake()
        public
        isNotOwner
        isOpened
    {
        players.push(msg.sender);
        emit LogEntered(msg.sender);
    }

    /// @notice select winner
    /// @dev emit LogSelected event
    function selectWinner()
        public
        isOwner
        isOpened
        hasPlayers
    {
        // random drawing from players
        /*
        provable_setProof(proofType_Ledger);
        bytes32 _result = provable_newRandomDSQuery(0,7,200000);
        uint randomNumber = uint256(keccak256(abi.encodePacked(_result))) % (players.length-1);
        */
        uint randomNumber = uint(keccak256(abi.encodePacked(now, msg.sender, block.difficulty))) % players.length;
        winner = players[randomNumber];

        state = State.Selected;
        emit LogSelected(winner);
        emit LogRandomNumber(randomNumber);
    }

    /// @notice return owner of the sweepstake
    /// @return sweepstake owner address
    function getOwner()
        public
        view
        returns (address)
    {
        return owner;
    }

    /// @notice get winner of the sweepstake
    /// @return sweepstake winner address
    function getWinner()
        public
        view
        returns (address)
    {
        return winner;
    }

    /// @notice get players that entered into the sweepstake
    /// @return players
    function getPlayers()
        public
        view
        returns (address[] memory)
    {
        return players;
    }

    /// @notice caller can claim prize of sweepstake
    /// @dev emit LogClaimed event
    function claimPrize()
        public
        payable
        isSelected
        isWinner
    {
        state = State.Claimed;
        msg.sender.transfer(prize);
        emit LogClaimed(msg.sender);
    }

    /// @notice return balance of sweepstake
    /// @return balance of sweepstake
    function getBalance()
        public
        view
        returns (uint)
    {
        return address(this).balance;
    }
}