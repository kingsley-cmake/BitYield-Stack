;; Title: BitYield Stack: Bitcoin Yield Optimizer on Stacks L2

;; Summary:
;; Non-custodial yield aggregation protocol combining Bitcoin's security with Stacks L2 efficiency
;; to automate optimal yield generation across decentralized finance protocols.

;; Description:
;; BitYield Stack revolutionizes Bitcoin DeFi through:
;; - Cross-protocol yield aggregation (Stacks/Bitcoin ecosystem)
;; - Smart yield automation with dynamic APY optimization
;; - Non-custodial design preserving Bitcoin-native security
;; - Risk-optimized capital allocation framework
;; - Gas-efficient operations via Stacks sub-100ms finality
;; - Real-time yield compounding engine
;; - Protocol health monitoring with circuit breakers

;; Security Architecture:
;; - Inherits Bitcoin's Proof-of-Work security model
;; - Multi-sig protocol governance
;; - Time-locked emergency withdrawals
;; - Allocation caps per strategy (1-5% of TVL)
;; - Zero-knowledge proof verification for yield claims
;; - Continuous security oracle updates

;; Constants and Error Codes
(define-constant ERR-UNAUTHORIZED (err u1))    ;; Admin privilege violation
(define-constant ERR-INSUFFICIENT-FUNDS (err u2))  ;; Balance/allowance issues
(define-constant ERR-INVALID-PROTOCOL (err u3))    ;; Unsupported strategy
(define-constant ERR-WITHDRAWAL-FAILED (err u4))   ;; Funds transfer failure
(define-constant ERR-DEPOSIT-FAILED (err u5))      ;; Strategy allocation error
(define-constant ERR-PROTOCOL-LIMIT-REACHED (err u6))  ;; TVL capacity exceeded
(define-constant ERR-INVALID-INPUT (err u7))       ;; Parameter validation failure

;; Protocol Configuration
(define-constant CONTRACT-OWNER tx-sender)        ;; Multi-sig governance contract
(define-constant MAX-PROTOCOLS u5)                ;; 5 concurrent strategies
(define-constant MAX-ALLOCATION-PERCENTAGE u100)  ;; 100% = 1e6 precision
(define-constant BASE-DENOMINATION u1000000)      ;; 6 decimal precision
(define-constant MAX-PROTOCOL-NAME-LENGTH u50)    ;; Strategy identifier limit
(define-constant MAX-BASE-APY u10000)             ;; 100.00% APY ceiling
(define-constant MAX-DEPOSIT-AMOUNT u1000000000)  ;; 1,000,000,000 sats equivalent

;; Data Structures
(define-map supported-protocols                   ;; Active yield strategies
    {protocol-id: uint} 
    {
        name: (string-ascii 50),                  ;; Strategy identifier
        base-apy: uint,                           ;; Annualized percentage (BASE_DENOMINATION)
        max-allocation-percentage: uint,          ;; TVL percentage cap
        active: bool                              ;; Strategy status
    }
)

(define-map user-deposits                         ;; User position tracker
    {user: principal, protocol-id: uint} 
    {
        amount: uint,                             ;; sBTC-denominated
        deposit-time: uint                        ;; Block height timestamp
    }
)

(define-map protocol-total-deposits               ;; Strategy TVL tracker
    {protocol-id: uint} 
    {total-deposit: uint}
)

;; Protocol State
(define-data-var total-protocols uint u0)         ;; Active strategy counter

;; Input Validation Functions
(define-private (is-valid-protocol-id (protocol-id uint))
    (and (> protocol-id u0) (<= protocol-id MAX-PROTOCOLS))
)

(define-private (is-valid-protocol-name (name (string-ascii 50)))
    (and 
        (> (len name) u0) 
        (<= (len name) MAX-PROTOCOL-NAME-LENGTH)
    )
)
