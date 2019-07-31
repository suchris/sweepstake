# Sweepstake Smart Contract

This truffle project explores how to use the Ethereum development tools to implement sweepstakes.

## Use cases

The smart contract is set up to allow the following use cases.
  * As an owner I can create a sweepstake with a name and prize.
  * As a player I can enter for the drawing.
  * As a owner I want to randomly select a winner among entries.
  * As a player I want to redeem the winning prize if I am the winner.

## Getting started

1. Install Truffle and Ganache CLI globally. (or the GUI version of Ganache, alternatively)
    ```sh
    npm install -g truffle
    npm install -g ganache-cli
    ```

2. Clone this repository.
    ```sh
    git clone https://github.com/suchris/sweepstake
    cd sweepstake
    ```

3. Install npm packages.
    ```sh
    npm install
    ```

4. Run the development blockchain. Note, that increasing the blocktime to 3
   seconds prevents some race conditions. This value specifies the interval
   between blocks being mined on the development blockchain.
    ```sh
    ganache-cli
    ```

5. Compile and migrate the smart contracts.
    ```sh
    truffle compile
    truffle migrate
    ```

6. Run the development server for front-end hot reloading (outside the development console). Smart contract changes must be manually recompiled and migrated.
    ```sh
    npm run start
    ```
7. visit http://localhost:3000 to interact with the front end. To simulate
   multiple users, install metamask on another browser and login in with
   different accounts.
