//
//  tip_calculatoreSnapshotTests.swift
//  tip-calculatorTests
//
//  Created by Yasir on 20/11/2024.
//

import XCTest
import SnapshotTesting

@testable import tip_calculator



final class tip_calculatorSnapshotTests : XCTestCase {
    
    
    
    private var screenWidth : CGFloat {
        return UIScreen.main.bounds.width
    }
    

    func testLogoView(){
        
        //Given
        let size = CGSize(width: screenWidth, height: 48)
        
        //When
        let view = LogoView()
        
        //Then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testResultView(){
        //Given
        let size = CGSize(width:screenWidth, height:224)
        
        //When
        let view = ResultView()
        
        //Then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testBillingInputView(){
        //Given
        let size = CGSize(width:screenWidth, height:56)
        
        //When
        let view = ResultView()
        
        //Then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    
    func testTipInputView(){
        //Given
        let size = CGSize(width:screenWidth, height:56+56+15)
        
        //When
        let view = ResultView()
        
        //Then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    
    func testSplitInputView(){
        //Given
        let size = CGSize(width:screenWidth, height:56)
        
        //When
        let view = ResultView()
        
        //Then
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    
    
}
