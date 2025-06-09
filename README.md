
# FundMe – Crowdfunding Smart Contract (Foundry + Chainlink)

This is a simple ETH-based crowdfunding smart contract built with **Foundry**. It lets anyone fund the contract (as long as they meet a minimum USD value), and only the contract owner can withdraw the balance. Real-time ETH/USD conversion is handled using **Chainlink Price Feeds**.

## Features

- Accepts ETH only if it’s worth **at least $5**
- Only the **contract owner** can withdraw
- Real-time ETH to USD pricing via **Chainlink Oracles**
- Unit and integration tests included
- Works locally and on testnets

## Tech Stack

- **Solidity** `^0.8.30`
- **Foundry** (Forge + Cast)
- **Chainlink Oracles**
- **Anvil** (for local testing)
- **Etherscan Verification**
- **Foundry DevOps Tools**

## Project Structure

```
fundme-tani/
├── src/
│   ├── FundMe.sol              # Main contract
│   └── PriceConverter.sol      # ETH/USD conversion logic
│
├── script/
│   ├── DeployFundMe.s.sol      # Deploys the contract
│   ├── HelperConfig.s.sol      # Price feed config per network
│   └── Interactions.s.sol      # Script to fund/withdraw
│
├── test/
│   ├── unit/
│   │   └── FundMeTest.t.sol     # Unit tests
│   └── integration/
│       └── InteractionsTest.t.sol # Full flow test
│
└── lib/                        # External dependencies (e.g., Chainlink)
```

## Getting Started

### 1. Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. Install Dependencies

```bash
forge install
```

### 3. Start Local Node

```bash
anvil
```

### 4. Build Contracts

```bash
forge build
```

### 5. Run Tests

```bash
forge test -vvvv
```

### 6. Deploy to a Testnet

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe \
  --rpc-url <your_rpc_url> \
  --private-key <your_private_key> \
  --broadcast \
  --verify \
  --etherscan-api-key <your_api_key> \
  -vvvv
```

## Script Overview

| Script                  | What It Does                      |
|------------------------|------------------------------------|
| DeployFundMe.s.sol     | Deploys the FundMe contract        |
| HelperConfig.s.sol     | Chooses the right price feed       |
| Interactions.s.sol     | Lets you fund/withdraw interactively|

## Testing Highlights

- Ensures the minimum funding threshold is enforced
- Validates that only the owner can withdraw
- Simulates one or more funders
- Includes a full fund → withdraw integration test

## Manual Interactions with Cast

```bash
cast send <contract_address> "fund()" \
  --value 0.01ether \
  --rpc-url <rpc_url> \
  --private-key <your_key>

cast send <contract_address> "withdraw()" \
  --rpc-url <rpc_url> \
  --private-key <your_key>
```

## What You’ll Learn from This

- Writing secure and gas-efficient smart contracts
- Using external libraries (e.g., Chainlink)
- Deploying and testing smart contracts in multiple environments
- Automating workflows with scripts
- Using Foundry cheatcodes like `vm.prank`, `deal`, `hoax`, etc.

## Future Improvements

- Frontend with ethers.js or web3.js
- UI feedback via events
- Access control using OpenZeppelin
- More gas optimization using custom errors and tighter code

## Author

Built by **Tanisha**, as part of a hands-on Web3 learning journey using Foundry and Solidity (ps: my first project into the world of web3).
