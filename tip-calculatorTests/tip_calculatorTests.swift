//
//  tip_calculatorTests.swift
//  tip-calculatorTests
//
//  Created by Yasir on 27/09/2024.
//

import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {
    
    //sut : System under test, lets create a system under test
    
    private var sut : CalculatorVM!
    
    private var cancelable : Set<AnyCancellable>!
    
    private var logoViewTapSubject : PassthroughSubject<Void, Never>!
    
    private var mockAudioPlayerService : MockAudioPlayerService!
    
    override func setUp() {
        
        mockAudioPlayerService = .init()
        
        logoViewTapSubject = .init()
        
        sut = .init(audioPlayerService: mockAudioPlayerService)
        
        cancelable = .init()
    }
    
    override func tearDown() {
        
        sut = nil
        cancelable = nil
        mockAudioPlayerService = nil
        logoViewTapSubject = nil
    }
    
    
    //Test with 100$, no tip at all, and no split
    
    //$100 bil
    //no tip
    //1 person only
    
    func testBill100DollarNoTipAndOnly1Person(){
        
        //****Given****
        let bill : Double = 100.0
        let tip : Tip = .none
        let split :Int = 1
        
        //****When****
        let input = buildInput(bill: bill, tip: tip, split: split)
        
        
        //****Then****
        let output = sut.transform(input: input)
        output.updateViewPublisher.sink { result in
            
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0.0)
            XCTAssertEqual(result.totalPerPerson, 100)
            
        }.store(in: &cancelable)
        
    }
    
    
    //now lets test other permutations
    
    // - testResultWithoutTipFor2Person
    // - testResultWith10PercentTipFor2Person
    // - testResultWithCustomTipFor4Person
    
    
    func testResultWithoutTipFor2Person() {
        
        //Given
        
        let bill : Double = 100
        let tip : Tip = .none
        let split : Int = 2
        
        let input = buildInput(bill:bill, tip: tip, split: split)
        
        //When
        
        
        let output = sut.transform(input: input)
        
        
        //Then
        
        
        output.updateViewPublisher.sink { result in
            
            XCTAssertEqual(result.totalBill, 100.0)
            XCTAssertEqual(result.totalTip, 0.0)
            XCTAssertEqual(result.totalPerPerson, 50.0)
            
            
        }.store(in: &cancelable)
    }
    
    func testResultWith10PercentTipFor2Person(){
        
        
        //Given
        let bill = 100.0
        let tip : Tip = .tenPercent
        let split :Int = 2
        
        let input = buildInput(bill:bill, tip:tip, split:split)
        
        //When
        let output = sut.transform(input: input)
        
        
        
        
        //Then
        output.updateViewPublisher.sink { result in
            
            XCTAssertEqual(result.totalBill, 110.0)
            XCTAssertEqual(result.totalTip, 10.0)
            XCTAssertEqual(result.totalPerPerson, 55.0)
            
            
        }.store(in: &cancelable)
        
        
    }
    
    
    func testResultWithCustomTipFor4Person() {
        
        //Given
        let bill : Double = 100.0
        let tip : Tip = .custom(value: 25)
        let split : Int = 4
        
        let input = buildInput(bill:bill, tip:tip, split: split)
        //When
        
        let output = sut.transform(input: input)
        
        //Then
        
        
        output.updateViewPublisher.sink { result in
            
            
            XCTAssertEqual(result.totalBill, 125.0)
            XCTAssertEqual(result.totalTip, 25.0)
            XCTAssertEqual(result.totalPerPerson, 31.25)
            
            
            
        }.store(in: &cancelable)
    }
    
    
    
    //Test for when LogoViewTap
    //Rest the calculator
    //Rest sound will be played
    
    
    func testForWhenLogoViewTappedClearCalculatorAndPlaySound(){
        
        //Give
        
        let input = buildInput(bill:100, tip:.tenPercent, split:2)
        let output = sut.transform(input: input)
        let expectation1 = expectation(description: "reset the calculaor")
        
        let expectation2 = mockAudioPlayerService.expectation
        
        //Then
        
        output.resetCalculatorPublisher.sink { _ in
            //if I remove the expectation from the sink block, the test fails.
            expectation1.fulfill()
            
        }.store(in: &cancelable)
        
        
        
        //When
        //since it's a synchronous code, we place the when at the end
        
        
        logoViewTapSubject.send()
        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
    
    
    
    
    //this method will be use alot
    private func buildInput(bill:Double, tip:Tip, split:Int) -> CalculatorVM.Input {
        return .init(billPublisher: Just(bill).eraseToAnyPublisher(),
                     tipPublisher: Just(tip).eraseToAnyPublisher(),
                     splitPubliser: Just(split).eraseToAnyPublisher(),
                     logoViewTapPublisher:logoViewTapSubject.eraseToAnyPublisher())
        
    }
    
    
}



//This is POP, Protocol Oriented Programming to Mock Test
class MockAudioPlayerService : AudioPlayerService {
    
    let expectation = XCTestExpectation(description: "audio played on tap of logo view")
    
    func playSound() {
        expectation.fulfill()
    }
}
