;; Title: Lumeos
;; Summary: Bitcoin-Secured Philanthropy Protocol with Verifiable Transparency
;;
;; Description:
;; Lumeos redefines digital philanthropy by harnessing Bitcoin's security
;; via the Stacks Layer. It provides an immutable, on-chain accountability 
;; framework where every donation is visible, traceable, and governed by 
;; smart contracts. The protocol ensures milestone-based fund releases, 
;; cryptographic verification of impact, and real-time donor insight into 
;; how contributions create measurable change. Charities gain credibility 
;; through automated reporting, while donors eliminate blind trust and 
;; replace it with blockchain-proofed confidence.

;; CONSTANTS AND ERROR CODES

;; Contract ownership and governance
(define-data-var contract-owner principal tx-sender)

;; Error code registry
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-REGISTERED (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-INSUFFICIENT-FUNDS (err u103))
(define-constant ERR-BENEFICIARY-NOT-FOUND (err u104))
(define-constant ERR-UTILIZATION-NOT-FOUND (err u105))
(define-constant ERR-INVALID-INPUT (err u106))

;; Role hierarchy
(define-constant ROLE-ADMIN u1)
(define-constant ROLE-MODERATOR u2)
(define-constant ROLE-BENEFICIARY u3)

;; DATA STRUCTURES

;; User role management
(define-map roles
  { user: principal }
  { role: uint }
)

;; Registry of charitable beneficiaries
(define-map beneficiaries
  { id: uint }
  {
    name: (string-utf8 50),
    description: (string-utf8 255),
    target-amount: uint,
    received-amount: uint,
    status: (string-ascii 20),
  }
)

;; Donation ledger
(define-map donations
  { id: uint }
  {
    donor: principal,
    beneficiary-id: uint,
    amount: uint,
    timestamp: uint,
  }
)

;; Utilization milestones for allocated funds
(define-map utilization
  { id: uint }
  {
    beneficiary-id: uint,
    milestone: uint,
    description: (string-utf8 255),
    amount: uint,
    status: (string-ascii 20),
  }
)

;; STATE VARIABLES

(define-data-var beneficiary-count uint u0)
(define-data-var donation-count uint u0)
(define-data-var utilization-count uint u0)

;; UTILITY FUNCTIONS

;; Role verification
(define-private (is-authorized
    (user principal)
    (required-role uint)
  )
  (let ((role-data (default-to { role: u0 } (map-get? roles { user: user }))))
    (>= (get role role-data) required-role)
  )
)

;; Track last milestone of a beneficiary
(define-private (get-last-milestone (beneficiary-id uint))
  (var-get utilization-count)
)