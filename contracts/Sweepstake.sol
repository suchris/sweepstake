pragma solidity ^0.5.0;

contract Sweepstake {
    address owner;          // address of owner
    string name;            // name of sweepstake
    uint prize;             // prize of sweepstake
    address[] players;      // all player that entered the sweepstake
    address winner;         // winner selected
    State state;            // state of the contract

    // three states of the contract, open to enter, winner is selected, prize is claimed
    enum State {Opened, Selected, Claimed}

    /// @notice log sweepstake state Opened
    /// @param _name name of sweepstake
    event LogOpened (string _name);

    /// @notice log sweepstake state Selected
    /// @param _winner player was selected to be the winner
    event LogSelected (address _winner);

    /// @notice log sweepstake state Claimed
    /// @param _winner winner that claimed the prize
    event LogClaimed (address _winner);

    /// @notice log caller entered into sweepstake
    /// @param _player player entered into sweepstake
    event LogEntered (address _player);

    /// @notice log random number selected
    /// @param _number random number selected
    event LogRandomNumber(uint _number);

    /// @notice constructor creates a new sweepstake
    /// @param _name name of the sweepstake
    /// @param _prize the prize of the prize
    /// @param _owner the caller the constructor
    /// @dev emit LogOpened event
    constructor (string memory _name, uint _prize, address _owner)
        public
    {
        owner = _owner;
        name = _name;
        prize = _prize;
        state = State.Opened;
        emit LogOpened(name);
    }

    /// @notice accept funds
    function() external payable {}

    /// @notice modifier to check if caller is owner
    modifier isOwner() {
        require (
            msg.sender == owner,
            "Caller is not owner"
        );
        _;
    }

    /// @notice modifier to check if caller is not owner
    modifier isNotOwner() {
        require (
            msg.sender != owner,
            "Caller is owner"
        );
        _;
    }

    /// @notice modifier to check if sweepstake is opened to enter
    modifier isOpened() {
        require (
            state == State.Opened,
            "Sweepstake is not opened to enter"
        );
        _;
    }

    /// @notice modifier to check if winner is selected
    modifier isSelected() {
        require (
            state == State.Selected,
            "Winner is not selected for the Sweepstake"
        );
        _;
    }

    /// @notice modifier to check if caller is winner
    modifier isWinner() {
        require (
            msg.sender == winner,
            "Caller is not the winner"
        );
        _;
    }

    /// @notice modifier check if sweepstake has players entered
    modifier hasPlayers() {
        require (
            players.length > 0,
            "There's no player in this sweepstake"
        );
        _;
    }

    /// @notice function to enter sweepstake
    /// @dev emit LogEntered event
    function enterSweepstake()
        public
        isNotOwner
        isOpened
    {
        players.push(msg.sender);
        emit LogEntered(msg.sender);
    }

    /// @notice funnction to select a winner among players randomly
    /// @dev emit LogSelected event
    /// @dev emit LogRandomNumber event
    function selectWinner()
        public
        isOwner
        isOpened
        hasPlayers
    {
        // random number selected based string encoded using time, caller address and block difficulty
        uint randomNumber = uint(keccak256(abi.encodePacked(now, msg.sender, block.difficulty))) % players.length;
        
        state = State.Selected;
        winner = players[randomNumber];

        emit LogSelected(winner);
        emit LogRandomNumber(randomNumber);
    }

    /// @notice function returns owner of the sweepstake
    /// @return sweepstake owner address
    function getOwner()
        public
        view
        returns (address)
    {
        return owner;
    }

    /// @notice function returns winner of the sweepstake
    /// @return winner address
    function getWinner()
        public
        view
        returns (address)
    {
        return winner;
    }

    /// @notice function returns a list of players that entered the sweepstake
    /// @return an array of addresses of players
    function getPlayers()
        public
        view
        returns (address[] memory)
    {
        return players;
    }

    /// @notice function allows winner to claim prize of sweepstake
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

    /// @notice function returns balance of sweepstake
    /// @return balance of sweepstake
    function getBalance()
        public
        view
        returns (uint)
    {
        return address(this).balance;
    }
}