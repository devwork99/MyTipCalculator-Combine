//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit
import Combine        /*it has all the sinks*/
import CombineCocoa   /*it has all the taps, and clicks*/



class TipInputView : UIView{
    
    
    //MARK: - Elements of Combine
    //why CurrentValueSubject here,
    //its different from PassthroughSubject, becasue it only has one value, has defalut value
    private let tipSubject : CurrentValueSubject<Tip,Never> = .init(.none)
    var valuePublisher : AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    private var cancelable = Set<AnyCancellable>()
    
    
    
    private let _headerView : HeaderView  = {
        return HeaderView(text1:"Choose", text2:"you tip")
    }()
    
    private lazy var _btn10Percent : UIButton = {
        let some = buildButton(tip: .tenPercent)
        //every time the button is tapped, send the Ten percent value, to the tip subject
        some.tapPublisher.flatMap ({
            Just(Tip.tenPercent)
        }).assign(to: \.value, on: tipSubject)
        .store(in: &cancelable)
        return some
    }()
    
    private lazy var _btn15Percent : UIButton = {
        let some = buildButton(tip: .fifteenPercent)
        some.tapPublisher.flatMap ({
            Just(Tip.fifteenPercent)
        }).assign(to: \.value, on: tipSubject)
        .store(in: &cancelable)
        return some
    }()
    
    private lazy var _btn20Percent : UIButton = {
        let some = buildButton(tip: .twentyPercent)
        some.tapPublisher.flatMap ({
            Just(Tip.twentyPercent)
        }).assign(to: \.value, on: tipSubject)
        .store(in: &cancelable)
        return some
    }()
    
    private lazy var _hStack : UIStackView = {
        let some = UIStackView(arrangedSubviews: [_btn10Percent, _btn15Percent, _btn20Percent])
        some.distribution = .fillEqually
        some.axis = .horizontal
        some.spacing = 16
        return some
    }()
    
    private lazy var _btnCustomValue : UIButton = {
        let some = UIButton(type: .custom)
        some.setTitle("Custom Value", for: .normal)
        some.titleLabel?.font = AppFont.bold(20)
        some.titleLabel?.textColor = .white
        some.backgroundColor = ThemeColors.primary
        some.addCornorRadius(radius:8.0)
        
        
        some.tapPublisher.sink { [weak self] _ in
            
            
            self?.handleCustoTipButton()
        }
        .store(in: &cancelable)
        
        
        return some
    }()
    
    
    private lazy var _vStack : UIStackView = {
        let some = UIStackView(arrangedSubviews: [
            _hStack,
            _btnCustomValue
        ])
        
        some.axis = .vertical
        some.distribution = .fillEqually
        some.spacing = 8.0
        
        
        return some
    }()
    
    private func observeTip(){
        
        tipSubject.sink { [unowned self] tipValue in
            
            //lets reset first the button states
            resetAllTipButtons()
            
            switch tipValue {
            case .none:
                break
            case .tenPercent:
                _btn10Percent.backgroundColor = ThemeColors.secondary
            case .fifteenPercent:
                _btn15Percent.backgroundColor = ThemeColors.secondary
            case .twentyPercent:
                _btn20Percent.backgroundColor = ThemeColors.secondary
                
            case .custom(let value):
                _btnCustomValue.backgroundColor = ThemeColors.secondary
                let someText = NSMutableAttributedString(
                    string:"$\(value)",
                    attributes: [.font : AppFont.bold(20)])
                
                someText.addAttributes([
                    .font : AppFont.demibold(14)
                ], range: NSMakeRange(0, 1))
                
                _btnCustomValue.setAttributedTitle(someText, for: .normal)
            }
        }
        .store(in: &cancelable)
        
        
    }
    
    func resetTIV(){
        tipSubject.send(.none)
    }
    
    private func resetAllTipButtons(){
        _btn10Percent.backgroundColor = ThemeColors.primary
        _btn15Percent.backgroundColor = ThemeColors.primary
        _btn20Percent.backgroundColor = ThemeColors.primary
        _btnCustomValue.backgroundColor = ThemeColors.primary
        
        //_btnCustomValue.setTitle("Custom Value", for: .normal)
        
        let someText = NSMutableAttributedString(
            string:"Custome value",
            attributes: [.font : AppFont.bold(20)])
        _btnCustomValue.setAttributedTitle(someText, for: .normal)
    }
    
    
    private func handleCustoTipButton(){
        
        
        let alertController : UIAlertController = {
            
            let controller = UIAlertController(title:"Input custom amount",
                                               message:nil,
                                               preferredStyle:.alert)
            
            controller.addTextField { textField in
                textField.keyboardType = .numberPad
                textField.placeholder = "Be generous!"
                textField.autocorrectionType = .no
            }
            
            let cancel = UIAlertAction(title:"Cancel", style: .cancel)
            
            
            let ok = UIAlertAction(title:"Ok", style: .default){ [weak self] _ in
                guard let text = controller.textFields?.first?.text,
                      let value = Int(text) else {
                    return
                }
                
                
                self?.tipSubject.send(.custom(value: value))
                
            }
            
            [cancel,ok].forEach(controller.addAction(_:))
            
            
            return controller
            
        }()
        
        
        parentViewController?.present(alertController, animated: true)
        
    }
    
    
    init() {
        //.zero becasue we use autolayouts and not the frame
        super.init(frame: .zero)
        setupLayout()
        observeTip()
        //print("value == \(tipSubject.value)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout(){
        //self.backgroundColor = .systemPink
        
        [_headerView, _vStack].forEach(addSubview(_:))
        
        
        _vStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        _headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(_vStack.snp.leading).offset(-24)
            make.height.equalTo(68)
            make.centerY.equalTo(_hStack.snp.centerY)
        }
        
    }
    
    private func buildButton(tip:Tip) -> UIButton{
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColors.primary
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = AppFont.bold(16)
        button.addCornorRadius(radius: 8)
        
        //button.titleLabel?.text = tip.stringValue
        
        
        let someText = NSMutableAttributedString(
            string:tip.stringValue,
            attributes: [.font : AppFont.bold(24)])
        
        someText.addAttributes([
            .font : AppFont.demibold(14)
        ], range: NSMakeRange(2, 1))
        
        button.setAttributedTitle(someText, for: .normal)
        
        return button
    }
    
}
