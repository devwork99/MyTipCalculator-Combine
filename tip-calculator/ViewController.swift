//
//  ViewController.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit
import SnapKit
import Combine


class ViewController: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billingInputView = BillingInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    
    //********************************
    private let vm = CalculatorVM()
    private var cancellable = Set<AnyCancellable>()
    //********************************
    
    private lazy var _vStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billingInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        stack.axis = .vertical
        stack.spacing = 36.0
        return stack
    }()
    
    //lets add a TapGestureOnView to dismiss the keyboard
    private lazy var viewTapPublisher : AnyPublisher <Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target:self, action: nil)
        view.addGestureRecognizer(tapGesture)
        
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())//can be an Int, or Void, lets send void for now
        }.eraseToAnyPublisher()
    }()
    
    
    private lazy var logoViewTapPublisher : AnyPublisher <Void, Never> = {
       let tapGesture = UITapGestureRecognizer(target:self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        
        return tapGesture.tapPublisher.flatMap { _ in
            Just(()) //lets send an empty for now
        }.eraseToAnyPublisher()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = ThemeColors.bg
        
        setupLayout()
        bind()
        observe()
     }

    
    private func bind(){
        
        //the bind method will give the input, get it trnasformed, and receive the Output
        //this is just for test purpose
        /*
        billingInputView.valuePubliser.sink { value in
            print("vc value \(value)")
        }.store(in: &cancellable)
        */
        
        let input = CalculatorVM.Input(billPublisher: billingInputView.valuePubliser,
                                       tipPublisher: tipInputView.valuePublisher,
                                       splitPubliser: splitInputView.valuePublisher,
                                       logoViewTapPublisher: logoViewTapPublisher)
        

        //lets generate the output
        
        let outPut = vm.transform(input: input)
        
        outPut.updateViewPublisher.sink { [unowned self] res in

//            print("\n")
//            print(">>>>\(res)>>>>>>>>")
//            print("\n")
            
            resultView.configure(res: res)
                        
        }.store(in: &cancellable)
        
        
        outPut.resetCalculatorPublisher.sink { [unowned self] _ in
            
            //print("Reset initiate here")
            billingInputView.resetBIV()
            tipInputView.resetTIV()
            splitInputView.resetSIV()
            
            UIView.animate(withDuration:0.1,
                           delay:0,
                           usingSpringWithDamping:5.0,
                           initialSpringVelocity:0.5, options: .curveEaseInOut) {
                
                self.logoView.transform = .init(scaleX:1.5, y: 1.5)
                
                
            }completion: { Bool in
                
                UIView.animate(withDuration:0.1) {
                    self.logoView.transform = .identity
                }
                
            }
            
        }.store(in: &cancellable)
        
    }
    
    
    private func observe(){
        
        viewTapPublisher.sink { [unowned self] value in
            view.endEditing(true)
        }.store(in: &cancellable)
        
        
        logoViewTapPublisher.sink {  _ in
            print("LogoView is tapped")
        }.store(in: &cancellable)
        
    }
    
    
    private func setupLayout(){
        self.view.addSubview(_vStack)
        
        
        _vStack.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
        }
        //393x852
        logoView.snp.makeConstraints { make in
            //make.height.equalTo(48)
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.056)
        }
        
        resultView.snp.makeConstraints { make in
            //make.height.equalTo(224)
            //224/852 = 0.26
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.26)
        }
        
        billingInputView.snp.makeConstraints { make in
            //0.065
            //make.height.equalTo(56)
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.065)
        }
        billingInputView.addCornorRadius(radius:5)
        
        tipInputView.snp.makeConstraints { make in
            //127/852 = 0.149
            //make.height.equalTo(56+56+15)
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.149)
        }
        
        splitInputView.snp.makeConstraints { make in
            //make.height.equalTo(56)
            make.height.equalTo(UIScreen.main.bounds.size.height * 0.065)
        }
        
        
    }

}

