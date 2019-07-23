pragma solidity ^0.5.0;

contract Sweepstake {
    address owner;
    string name;
    uint prize;
    address[] players;
    address winner;
    State state;
    enum State {Opened, Selected, Paid}

    event LogOpened (string _name);
    event LogSelected (address _player);
    event LogPaid (address _player);
    event LogEntry (address _player);
    constructor (string memory _name) public payable {
        owner = msg.sender;
        name = _name;
        prize = msg.value;
        state = State.Opened;
        emit LogOpened(name);
    }

    modifier isOwner() {
        require (
            msg.sender == owner,
            "Caller is not owner"
        );
        _;
    }

    modifier isNotOwner() {
        require (
            msg.sender != owner,
            "Caller is owner"
        );
        _;
    }

    modifier isOpened() {
        require (
            state == State.Opened,
            "Sweepstake is not opened to enter"
        );
        _;
    }

    modifier isSelected() {
        require (
            state == State.Selected,
            "Winner is not selected for the Sweepstake"
        );
        _;
    }

    modifier isWinner() {
        require (
            msg.sender == winner,
            "Caller is not the winner"
        );
        _;
    }

    modifier hasPlayers() {
        require (
            players.length > 0,
            "There's no player in this sweepstake"
        );
        _;
    }

    modifier noWinner() {
        require (
            winner == address(0x0),
            "There's no winner selected"
        );
        _;
    }
    function enter()
        public
        isNotOwner
        isOpened
    {
        players.push(msg.sender);
        emit LogEntry(msg.sender);
    }

    function selectWinner()
        public
        isOwner
        isOpened
    {
        // random drawing from players
        uint randomNumber = 0;
        winner = players[randomNumber];

        state = State.Selected;
        emit LogSelected(winner);
    }

    function getPlayers()
        public
        view
        returns (address[] memory)
    {
        return players;
    }

    function claimPrize()
        public
        payable
        isSelected
        isWinner
    {
        msg.sender.transfer(prize);
        state = State.Paid;
        emit LogPaid(msg.sender);
    }
}