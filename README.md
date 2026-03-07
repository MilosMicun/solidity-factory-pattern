# Token Factory Pattern — Solidity

This project demonstrates the **Factory Pattern** in Solidity: a contract responsible for deploying and tracking multiple independent contract instances.

Each deployed token is a **separate smart contract with isolated storage**, while the factory acts as a **deployment system and registry**.

This pattern is widely used in DeFi protocols to create:

- vault instances
- lending markets
- liquidity pools
- token contracts
- user wallets

---

# Architecture

The system consists of two contracts:


TokenFactory
│
├── deploys → MyToken instance
├── deploys → MyToken instance
└── deploys → MyToken instance


Each deployed token has:

- its **own address**
- its **own storage**
- its **own owner**
- its **own constructor parameters**

Even though the **logic is identical**, each instance is completely independent.

---

# Contracts

## MyToken.sol

Minimal token contract used as the deployable instance.

State variables:

```solidity
address public owner;
string public name;
string public symbol;

Constructor initializes the token:

constructor(address _owner, string memory _name, string memory _symbol) {
    owner = _owner;
    name = _name;
    symbol = _symbol;
}

This mirrors how real protocols initialize vaults, pools, or markets.

TokenFactory.sol

Responsible for deploying tokens and tracking them.

Registry
address[] public tokens;

The registry stores every deployed token address.

Event
event TokenCreated(address indexed token, address indexed owner);

Emitted on each deployment.

Events are critical because frontends and indexers rely on them.

Token Deployment
function createToken(string memory _name, string memory _symbol) external returns (address) {
    MyToken token = new MyToken(msg.sender, _name, _symbol);

    tokens.push(address(token));

    emit TokenCreated(address(token), msg.sender);

    return address(token);
}

Deployment flow:

caller
   │
   ▼
factory.createToken()
   │
   ▼
new MyToken(msg.sender, name, symbol)
   │
   ▼
tokens.push(tokenAddress)
   │
   ▼
emit TokenCreated(...)

The caller becomes the owner of the deployed token.

Registry Helper
function getTokensCount() public view returns (uint256) {
    return tokens.length;
}

Returns the total number of deployed tokens.

This helper improves readability for:

frontends

scripts

tests

Key Design Concepts
Instance Isolation

Each deployed contract has its own storage space.

Token A → storage A
Token B → storage B
Token C → storage C

Operations on one instance cannot affect another.

This is a fundamental property of the EVM.

Factory as a Deployment System

A factory is not just a deploy helper.

It often acts as a protocol entry point controlling how new instances are created.

Examples in real protocols:

lending market creation

vault deployment

pool deployment

wallet creation

Permissionless vs Controlled Deployment

Factories can operate in two modes.

Permissionless

Anyone can deploy instances.

Pros:

decentralized

open participation

Cons:

registry spam

potential malicious instances

Owner / Governance Gated

Only governance or an admin can deploy new instances.

Pros:

curated markets

controlled risk parameters

Cons:

more centralized

Most large DeFi protocols use some form of gating for safety.

Testing

The project includes a full Foundry test suite.

Tests verify both correct behavior and system invariants.

Run tests:

forge test -vv
Test Coverage
testCreateToken

Verifies basic deployment:

token is created

owner is correctly assigned

registry is updated

testCreateMultipleTokens

Ensures factory can deploy multiple instances:

multiple deployments

unique contract addresses

registry growth

owner propagation

Uses:

vm.startPrank()

to simulate different callers.

testOwnerPropagationWithPrank

Verifies that the factory correctly forwards msg.sender to the token constructor.

Ensures the deployed token owner equals the caller.

testIsolatedTokenState

Confirms that each deployed token maintains its own independent state.

Checks that:

tokenA.name  ≠ tokenB.name
tokenA.symbol ≠ tokenB.symbol

This demonstrates isolated storage per instance.

testRegistryIntegrity

Ensures the factory registry reflects deployments correctly.

Verifies:

tokens[0] == token1
tokens[1] == token2

This confirms correct ordering and registry bookkeeping.

Why This Pattern Matters

Factory patterns are foundational to many DeFi architectures.

Used in systems such as:

Uniswap pools

lending markets

vault factories

account abstraction wallets

They allow protocols to scale from:

1 contract

to

many independent instances

while keeping deployment logic centralized.

Future Extensions

Real-world factory systems often evolve to include:

clone pattern (EIP-1167 minimal proxies)

upgradeable implementations

governance-controlled deployments

parameter validation

permission management

These optimizations significantly reduce gas costs and improve protocol flexibility.

Tech Stack

Solidity

Foundry

Forge testing framework

Learning Goal

This project focuses on understanding:

contract deployment mechanics

instance isolation

protocol architecture patterns

test-driven smart contract design

These concepts are foundational for protocol engineering in DeFi systems.