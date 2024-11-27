//
//  BankAccountTests.swift
//  ShoppingCart
//
//  Created by Максим Поздняков on 27.11.2024.
//

import XCTest
@testable import ShoppingCart

final class BankAccountTests: XCTestCase {
    var bankAccount: BankAccount!
    
    override func setUp() {
        super.setUp()
        bankAccount = BankAccount()
    }
    
    override func tearDown() {
        bankAccount = nil
        super.tearDown()
    }
    
    // Test 1: Initial Balance
    func testInitialBalance() {
        XCTAssertEqual(bankAccount.balance, 0.0, "Initial balance should be zero")
    }
    
    // Test 2: Deposit Positive Amount
    func testDepositPositiveAmount() {
        bankAccount.deposit(amount: 100.0)
        XCTAssertEqual(bankAccount.balance, 100.0, "Balance should increase after deposit")
        XCTAssertEqual(bankAccount.getTransactionHistory().count, 1, "Transaction history should record deposit")
        XCTAssertEqual(bankAccount.getTransactionHistory().first?.type, .deposit, "Transaction type should be deposit")
    }
    
    // Test 3: Deposit Zero or Negative Amount
    func testDepositInvalidAmount() {
        bankAccount.deposit(amount: 0)
        bankAccount.deposit(amount: -50)
        XCTAssertEqual(bankAccount.balance, 0.0, "Balance should not change for zero or negative deposits")
        XCTAssertEqual(bankAccount.getTransactionHistory().count, 0, "No transactions should be recorded")
    }
    
    // Test 4: Withdrawal with Sufficient Balance
    func testSuccessfulWithdrawal() {
        bankAccount.deposit(amount: 500.0)
        let withdrawalResult = bankAccount.withdraw(amount: 300.0)
        XCTAssertTrue(withdrawalResult, "Withdrawal should succeed")
        XCTAssertEqual(bankAccount.balance, 200.0, "Balance should decrease after withdrawal")
        XCTAssertEqual(bankAccount.getTransactionHistory().count, 2, "Transaction history should record withdrawal")
        XCTAssertEqual(bankAccount.getTransactionHistory().last?.type, .withdrawal, "Transaction type should be withdrawal")
    }
    
    // Test 5: Withdrawal with Insufficient Balance
    func testFailedWithdrawal() {
        let withdrawalResult = bankAccount.withdraw(amount: 100.0)
        XCTAssertFalse(withdrawalResult, "Withdrawal should fail")
        XCTAssertEqual(bankAccount.balance, 0.0, "Balance should remain unchanged")
        XCTAssertEqual(bankAccount.getTransactionHistory().count, 0, "No transactions should be recorded")
    }
    
    // Test 6: Taking Credit with No Existing Loan
    func testSuccessfulCreditTake() {
        let creditResult = bankAccount.takeCredit(amount: 5000.0)
        XCTAssertTrue(creditResult, "Credit should be taken successfully")
        XCTAssertEqual(bankAccount.balance, 5000.0, "Balance should increase with credit")
        XCTAssertEqual(bankAccount.creditLoan, 5000.0, "Credit loan should be recorded")
    }
    
    // Test 7: Taking Credit Beyond Limit
    func testCreditBeyondLimit() {
        let creditResult = bankAccount.takeCredit(amount: 15000.0)
        XCTAssertFalse(creditResult, "Credit should not be taken beyond limit")
        XCTAssertEqual(bankAccount.balance, 0.0, "Balance should remain unchanged")
        XCTAssertEqual(bankAccount.creditLoan, 0.0, "No credit loan should be recorded")
    }
    
    // Test 8: Taking Multiple Credits
    func testMultipleCredits() {
        let firstCreditResult = bankAccount.takeCredit(amount: 5000.0)
        let secondCreditResult = bankAccount.takeCredit(amount: 1000.0)
        XCTAssertTrue(firstCreditResult, "First credit should be successful")
        XCTAssertFalse(secondCreditResult, "Second credit should fail due to existing loan")
    }
    
    // Test 9: Paying Credit Loan
    func testSuccessfulCreditPayment() {
        _ = bankAccount.takeCredit(amount: 5000.0)
        bankAccount.deposit(amount: 6000.0)
        let paymentResult = bankAccount.payCredit(amount: 3000.0)
        XCTAssertTrue(paymentResult, "Credit payment should be successful")
        XCTAssertEqual(bankAccount.creditLoan, 2000.0, "Credit loan should decrease")
    }

    // Test 10: Failed Credit Payment
    func testFailedCreditPayment() {
        _ = bankAccount.takeCredit(amount: 5000.0)
        let paymentResult = bankAccount.payCredit(amount: 6000.0)
        XCTAssertFalse(paymentResult, "Credit payment should fail")
        XCTAssertEqual(bankAccount.creditLoan, 5000.0, "Credit loan should remain unchanged")
    }
}
