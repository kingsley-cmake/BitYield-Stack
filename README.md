# BitYield Stack: Bitcoin Yield Optimizer on Stacks L2

Non-custodial yield aggregation protocol combining Bitcoin's security with Stacks L2 efficiency.

## Table of Contents

- [BitYield Stack: Bitcoin Yield Optimizer on Stacks L2](#bityield-stack-bitcoin-yield-optimizer-on-stacks-l2)
	- [Table of Contents](#table-of-contents)
	- [Architecture Overview](#architecture-overview)
	- [Key Features](#key-features)
	- [Technical Specifications](#technical-specifications)
		- [Blockchain Integration](#blockchain-integration)
		- [Core Components](#core-components)
	- [Contract Functions](#contract-functions)
		- [Protocol Management](#protocol-management)
		- [Yield Operations](#yield-operations)
	- [Security Model](#security-model)
		- [Multi-Sig Governance](#multi-sig-governance)
		- [Risk Parameters](#risk-parameters)
	- [Installation](#installation)
		- [Requirements](#requirements)
	- [Usage](#usage)
		- [Deploy to Testnet](#deploy-to-testnet)
		- [Sample Transaction](#sample-transaction)
	- [Contributing](#contributing)

## Architecture Overview

Three-layer structure:

1. **Bitcoin Settlement Layer**: Final asset custody
2. **Stacks L2 Execution Layer**: Smart contract operations
3. **Yield Protocol Adapter Layer**: Strategy integrations

## Key Features

| Feature                      | Description                   | Technical Benefit                      |
| ---------------------------- | ----------------------------- | -------------------------------------- |
| Cross-Protocol Yield Routing | Aggregates 5+ DeFi strategies | `supported-protocols` map              |
| ZK-Proof Verification        | On-chain yield validation     | Zero-knowledge proof integration       |
| Dynamic Allocation Engine    | Auto-rebalancing based on APY | `MAX_ALLOCATION_PERCENTAGE` governance |
| Non-Custodial Vaults         | User-controlled funds         | `user-deposits` mapping                |
| Gas-Optimized Execution      | Sub-100ms transactions        | Stacks L2 primitives                   |

## Technical Specifications

### Blockchain Integration

- **Platform**: Stacks 2.1 (Nakamoto Release)
- **Assets**: sBTC (1:1 Bitcoin peg)
- **Contract Language**: Clarity 2.0
- **Security Oracle Updates**: 10-block intervals

### Core Components

```clarity
(define-map supported-protocols
    {protocol-id: uint}
    {
        name: (string-ascii 50),
        base-apy: uint,
        max-allocation-percentage: uint,
        active: bool
    }
)

(define-map user-deposits
    {user: principal, protocol-id: uint}
    {
        amount: uint,
        deposit-time: uint
    }
)
```

## Contract Functions

### Protocol Management

```clarity
(define-public (add-protocol
    (protocol-id uint)
    (name (string-ascii 50))
    (base-apy uint)
    (max-allocation-percentage uint)
)
```

- **Parameters**:
  - `protocol-id`: Unique strategy identifier
  - `name`: Human-readable label (50 char max)
  - `base-apy`: Annual percentage yield (10000 = 100.00%)
  - `max-allocation`: TVL percentage cap

### Yield Operations

```clarity
(define-public (deposit (protocol-id uint) (amount uint))
(define-public (withdraw (protocol-id uint) (amount uint))
(define-read-only (calculate-yield (protocol-id uint) (user principal))
```

## Security Model

### Multi-Sig Governance

```clarity
(define-constant CONTRACT-OWNER 0xmulti-sig-address)
```

- 3/5 signer requirement for protocol changes
- 24-hour time lock on critical operations

### Risk Parameters

| Parameter         | Value        | Description             |
| ----------------- | ------------ | ----------------------- |
| `MAX_PROTOCOLS`   | 5            | Concurrent strategies   |
| `MAX_ALLOCATION`  | 30%          | Per-protocol TVL cap    |
| `CIRCUIT_BREAKER` | 50% drawdown | Auto-withdrawal trigger |

## Installation

### Requirements

- Clarinet SDK 1.5.0+
- Node.js 18.x
- Bitcoin testnet node

```bash
git clone https://github.com/yourorg/bityield-stack.git
cd bityield-stack
npm install
```

## Usage

### Deploy to Testnet

```bash
clarinet deployments apply -y testnet
```

### Sample Transaction

```bash
clarinet contract call deposit \
  --sender ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM \
  --arg protocol-id:u2 \
  --arg amount:u500000000 \
  --cost 5000
```

## Contributing

1. Fork repository
2. Create feature branch (`feat/your-feature`)
3. Submit PR with:
   - Technical specification
   - Test coverage (90%+)
   - Audit checklist
