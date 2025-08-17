# Lumeos

**Bitcoin-Secured Philanthropy Protocol with Verifiable Transparency**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Clarity](https://img.shields.io/badge/clarity-v3-red.svg)](https://clarity-lang.org)
[![Stacks](https://img.shields.io/badge/stacks-blockchain-orange.svg)](https://stacks.co)

## Overview

Lumeos redefines digital philanthropy by harnessing Bitcoin's security via the Stacks Layer. It provides an immutable, on-chain accountability framework where every donation is visible, traceable, and governed by smart contracts. The protocol ensures milestone-based fund releases, cryptographic verification of impact, and real-time donor insight into how contributions create measurable change. Charities gain credibility through automated reporting, while donors eliminate blind trust and replace it with blockchain-proofed confidence.

## 🚀 Key Features

### 🔒 **Bitcoin-Secured Trust**

- Built on Stacks Layer 2 for Bitcoin-level security
- Immutable transaction records and fund tracking
- Cryptographic verification of all charitable activities

### 🎯 **Milestone-Based Funding**

- Smart contract-enforced milestone approvals
- Automated fund release upon milestone completion
- Transparent progress tracking for all stakeholders

### 👥 **Role-Based Access Control**

- **Admins**: Full protocol governance and milestone approval
- **Moderators**: Beneficiary registration and oversight
- **Beneficiaries**: Registered charitable organizations

### 📊 **Real-Time Transparency**

- Complete donation history and fund utilization
- Public beneficiary registry with funding goals
- Automated reporting and impact verification

## 🏗️ Architecture

### Smart Contract Components

#### Core Data Structures

```clarity
;; User role management
(define-map roles { user: principal } { role: uint })

;; Beneficiary registry
(define-map beneficiaries { id: uint } {
  name: (string-utf8 50),
  description: (string-utf8 255),
  target-amount: uint,
  received-amount: uint,
  status: (string-ascii 20)
})

;; Donation ledger
(define-map donations { id: uint } {
  donor: principal,
  beneficiary-id: uint,
  amount: uint,
  timestamp: uint
})

;; Utilization milestones
(define-map utilization { id: uint } {
  beneficiary-id: uint,
  milestone: uint,
  description: (string-utf8 255),
  amount: uint,
  status: (string-ascii 20)
})
```

#### Role Hierarchy

- **ROLE-ADMIN (1)**: Contract governance and milestone approval
- **ROLE-MODERATOR (2)**: Beneficiary management
- **ROLE-BENEFICIARY (3)**: Registered charitable organizations

## 🛠️ Getting Started

### Prerequisites

- [Clarinet](https://docs.hiro.so/stacks/clarinet) v2.0+
- [Node.js](https://nodejs.org/) v18+
- [Stacks CLI](https://docs.hiro.so/stacks/stacks-cli)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/rejoice-x/lumeos.git
   cd lumeos
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Check contract syntax**

   ```bash
   clarinet check
   ```

4. **Run tests**

   ```bash
   npm test
   ```

## 📋 Usage

### For Contract Deployers

1. **Deploy the contract**

   ```bash
   clarinet deploy --testnet
   ```

2. **Initialize roles** (automatically done on deployment)
   - Contract deployer receives `ROLE-ADMIN`
   - Additional roles assigned via `set-role` function

### For Administrators

#### Register New Beneficiaries

```clarity
(contract-call? .lumeos register-beneficiary 
  u"Charity Name" 
  u"Description of charitable work" 
  u1000000) ;; Target amount in microSTX
```

#### Approve Milestone Utilization

```clarity
(contract-call? .lumeos approve-utilization 
  u1 ;; utilization-id
  u1) ;; beneficiary-id
```

### For Moderators

#### Assign Beneficiary Role

```clarity
(contract-call? .lumeos set-role 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM 
  u3) ;; ROLE-BENEFICIARY
```

### For Donors

#### Make a Donation

```clarity
(contract-call? .lumeos donate 
  u1 ;; beneficiary-id
  u100000) ;; amount in microSTX
```

#### View Donation History

```clarity
(contract-call? .lumeos get-donation-by-id u1)
```

### For Beneficiaries

#### Add Utilization Milestone

```clarity
(contract-call? .lumeos add-utilization 
  u1 ;; beneficiary-id
  u"Milestone description" 
  u50000) ;; amount to be utilized
```

## 🧪 Testing

The project includes comprehensive test coverage using Vitest and Clarinet SDK.

### Run All Tests

```bash
npm test
```

### Run Tests with Coverage

```bash
npm run test:report
```

### Watch Mode

```bash
npm run test:watch
```

### Example Test Structure

```typescript
import { describe, expect, it } from "vitest";

describe("Lumeos Contract Tests", () => {
  it("should register a new beneficiary", () => {
    const { result } = simnet.callPublicFn("lumeos", "register-beneficiary", [
      Cl.stringUtf8("Test Charity"),
      Cl.stringUtf8("Test Description"),
      Cl.uint(1000000)
    ], address1);
    expect(result).toBeOk(Cl.uint(1));
  });
});
```

## 📊 Contract Functions

### Public Functions

| Function | Parameters | Description | Access Level |
|----------|------------|-------------|--------------|
| `set-role` | `user`, `new-role` | Assign roles to users | Admin Only |
| `remove-role` | `user` | Remove user roles | Admin Only |
| `register-beneficiary` | `name`, `description`, `target-amount` | Register new charity | Moderator+ |
| `donate` | `beneficiary-id`, `amount` | Make donation | Public |
| `add-utilization` | `beneficiary-id`, `description`, `amount` | Add milestone | Admin Only |
| `approve-utilization` | `utilization-id`, `beneficiary-id` | Approve milestone | Admin Only |

### Read-Only Functions

| Function | Parameters | Returns | Description |
|----------|------------|---------|-------------|
| `get-beneficiary` | `id` | `beneficiary` | Beneficiary details |
| `get-donation-by-id` | `donation-id` | `donation` | Donation details |
| `get-donation-count` | - | `uint` | Total donations |
| `get-utilization-by-id` | `utilization-id` | `utilization` | Milestone details |
| `get-utilization-count` | - | `uint` | Total milestones |

## 🚨 Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| `u100` | `ERR-NOT-AUTHORIZED` | Insufficient permissions |
| `u101` | `ERR-ALREADY-REGISTERED` | Entity already exists |
| `u102` | `ERR-NOT-FOUND` | Entity not found |
| `u103` | `ERR-INSUFFICIENT-FUNDS` | Inadequate balance |
| `u104` | `ERR-BENEFICIARY-NOT-FOUND` | Beneficiary doesn't exist |
| `u105` | `ERR-UTILIZATION-NOT-FOUND` | Milestone doesn't exist |
| `u106` | `ERR-INVALID-INPUT` | Invalid parameters |

## 🔧 Development

### Code Style

- Follow [Clarity best practices](https://docs.stacks.co/docs/clarity/overview)
- Use descriptive function and variable names
- Include comprehensive documentation
- Maintain consistent error handling

### Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Review Guidelines

- Ensure all tests pass
- Follow established coding conventions
- Include appropriate error handling
- Update documentation as needed

## 🛡️ Security Considerations

### Access Control

- Role-based permissions prevent unauthorized access
- Contract owner has ultimate administrative control
- Beneficiary registration requires moderator approval

### Fund Safety

- STX tokens are held by contract until milestone approval
- Milestone-based release prevents fund misuse
- All transactions are publicly auditable

### Best Practices

- Always validate input parameters
- Use proper error handling
- Implement comprehensive logging
- Regular security audits recommended

## 🚀 Deployment

### Testnet Deployment

```bash
clarinet deploy --testnet
```

### Mainnet Deployment

```bash
clarinet deploy --mainnet
```

### Environment Configuration

Update network settings in `settings/`:

- `Devnet.toml` - Local development
- `Testnet.toml` - Stacks testnet
- `Mainnet.toml` - Production deployment

## 📈 Roadmap

### Phase 1: Core Protocol ✅

- [x] Basic donation functionality
- [x] Beneficiary registry
- [x] Role-based access control
- [x] Milestone management

### Phase 2: Enhanced Features 🔄

- [ ] Multi-signature approvals
- [ ] Automated reporting system
- [ ] Integration with external APIs
- [ ] Mobile-friendly interface

### Phase 3: Advanced Capabilities 📋

- [ ] Cross-chain compatibility
- [ ] Governance token integration
- [ ] Advanced analytics dashboard
- [ ] Third-party audit integration

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on [Stacks blockchain](https://stacks.co)
- Powered by [Bitcoin](https://bitcoin.org) security
- Developed with [Clarity](https://clarity-lang.org) smart contracts

---

**Lumeos**: Transforming philanthropy through Bitcoin-secured transparency and accountability.
