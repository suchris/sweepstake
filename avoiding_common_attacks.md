### Avoiding common attacks in the Sweepstake contract

This document outlines how SweepstakeFactory and Sweepstake contract mitigate some of the most common solidity contract vulnerabilities.

#### DoS with Block Gas Limit.
  Sweepstakes could have many players entered to win and many to claim a prize. As a result it may be gas spent. Instead the Sweepstake contract follows a withdraw pattern, letting winner or claimers to claim a prize.

#### Reentrancy Attacks
  When transferring Ether for the winner, state variable is updated before value is transferred. This prevents a malicious contract from double dipping into the escrow's funds.

#### Circuit breaker
  Use OpenZeppelin Pausable lifecycle modifier to implement a circuit breaker to stop new Sweepstake contract from being created. This approach still allows for existing Sweepstakes to run.