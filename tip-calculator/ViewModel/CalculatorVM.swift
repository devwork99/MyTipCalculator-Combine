//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by Yasir on 24/10/2024.
//

import Foundation
import Combine


//brain of the app, all the business logic goes in here

class CalculatorVM {

    
    private var cancellable = Set<AnyCancellable>()
    
    struct Input {
        let billPublisher : AnyPublisher<Double, Never>
        let tipPublisher : AnyPublisher<Tip, Never>
        let splitPubliser : AnyPublisher<Int, Never>
        let logoViewTapPublisher : AnyPublisher <Void, Never>
    }
    
    struct Output {
        let updateViewPublisher : AnyPublisher<ResultFinal, Never>
        let resetCalculatorPublisher : AnyPublisher <Void, Never>
    }
    
    //this is dependency injection method
    //whenever we need to create the ViewModel we inject the dependency injection
    private let audioPlayerService : AudioPlayerService
    init(audioPlayerService : AudioPlayerService = DefaultAudioPlayer()){
        self.audioPlayerService = audioPlayerService
    }
    
    
    
    //Now we need the transform the method to transform inputs to the outputs
    func transform(input:Input) -> Output {
        //let result = ResultFinal(totalPerPerson: 400.0,
        //                       totalBill: 800.0,
        //                     totalTip: 19.0)
        
        /*
        input.billPublisher.sink { value in
            print("bill publish value \(value)")
        }.store(in: &cancellable)
        
        input.tipPublisher.sink { value in
            print("tip % value == \(value)")
        }.store(in: &cancellable)
        
        input.splitPubliser.sink { value in
            print("split publish value == \(value)")
        }.store(in: &cancellable)
        */
        
        //lets calculate and evaluate
        
        let updateViewPubliser = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPubliser).flatMap { [unowned self] (bill, tip, split) in
                
                let totalTip = calculateTip(bill:bill, tip: tip)
                let totalBill = bill + totalTip
                let totalSplit = totalBill / Double(split)

                
                return Just(ResultFinal(totalPerPerson:Double(totalSplit),
                                        totalBill: totalBill,
                                        totalTip: totalTip))
                
                
            }.eraseToAnyPublisher()
        
        
        //lets play the sound here
        let resetCalcPublisher = input.logoViewTapPublisher.handleEvents(receiveOutput:{ [unowned self]  in
            audioPlayerService.playSound()
        }).flatMap {
            Just($0)
        }.eraseToAnyPublisher()
        
        
        
        
//        let result = ResultFinal(totalPerPerson: 400.0,
//                                 totalBill: 800.0,
//                                 totalTip: 19.0)
        
        
        
        
        
        
        return Output(updateViewPublisher:
                        updateViewPubliser,
                      resetCalculatorPublisher: resetCalcPublisher)
    }
    
    private func calculateTip(bill:Double, tip:Tip) -> Double {
        switch tip{
        case .none:
            return 0.0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.20
        case .custom(let amount):
            return Double(amount)
        }
    }
    
}
