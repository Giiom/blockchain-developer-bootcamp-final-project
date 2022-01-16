# Final Project: Void Bank App + ERC20 Token

#### My ETH address & Linked ENS

0x4A86783c1d8Af3753980Ece6204Fc5e986065f7a
## Project Structure

The root directory of the project contains the following sub-directories:

client: contains all the frontend code, including dependencies and configuration.
contracts: contains all the solidity code.
migrations: contains the migration scripts for deploying solidity contracts to the blockchain.
node_modules: contains all smart contract dependencies
tests - contains the smart contract unit tests (written in javascript). 

```

### Installation

#### Requirements

Please ensure `Truffle v5.4.12` is installed to be able to conduct tests. You will also need to start Ganache to connect to the local blockchain network. If the Gananche network ID is not 5777 please update the correct network ID in the truffle-config.js file on line 9.

#### Clone this repository

`git clone https://github.com/giiom/blockchain-developer-bootcamp-final-project`

#### Install Dependencies

Dependencies are stored in the `package.json` file. From the main project folder run:
`npm install`  

#### Set up truffle-config.js settings

Set the port to `7545` and networkID to `5777`:

```
development: {
     host: "127.0.0.1",     
     port: 7545,            
     network_id: "5777",       
    }
```

#### Truffle Test in Development Mode

In the main project folder run:
`truffle test`

### Project Description

Users can deposit their Ether into The Void(bank). As a reward, The Voids bank account hodlers will receive 1000 Drigers for making and hodling a deposit. Account hodlers must hodl a deposit for a minimum of 1 year without making any withdrawals to receive the Driger token reward. This will help The Void in its effort to create an ETH/DRIG liquidity pool to further reward our account hodlers.

Here's how our system works:

#### Workflow

  1. User connects MetaMask wallet
  2. User deposits x ETH in their account
  3. User's balance is updated once transaction is mined
  4. User is rewarded Driger tokens for using the protocol