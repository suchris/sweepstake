### Design patterns and consideration
  This document outlines the design patterns used for writing the Solidity contracts.

#### Create Sweepstake
  A sweepstake is created when someone, now known as the owner, creates an sweepstake contract to award a prize. Other people may choose to enter in the sweepstake in hope of winning the prize without paying a fee. At some point in time, owner can select a winner randomly. Once a winner is selected, such person can claim the prize.

#### Manage state to track winner and prize payout
  Sweepstake allows the winner to claim the funds when a winner is selected. In this case the winner is one of many users enters into the Sweepstake contract. It is possible for a malicious player to redeem funds if care isn't taken into managing state.

  The solution is to track if the sweepstake can be awarded to a player that is the winner and use `isSelected` modifier and `isWinner` to guard the `claimPrize` function.

#### Restricting access based on Roles

  The owner is the sweepstake's creator who will transfer funds to the Sweepstake contract as prize. The prize will be rewarded to a winner among players that entered into the contest. As the creator, there are certain functions he has exclusive access to. The modifier `isOwner` works nicely in this example. It limits the ability to select a winner and change contract state only to the owner.

#### Fail fast, fail loud

  The approach I took is to fail early and loud using multiple modifiers to limit gas costs and short circuit/revert execution. The names relate to the Sweepstake contract state in a meaningful way and helps to remove the noise of overly complicated logic.

  An Sweepstake has different states to identify different stages of the contract. Players can enter the sweepstake only when sweepstake is at state `isOpened`. Only owner can select a winner and change the state to `isSelected`.

  Winner can claim prize when contract is at state `isSelected`, once a prize is paid out, state of the contract is changed to `isClaimed`.