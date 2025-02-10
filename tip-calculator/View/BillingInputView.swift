//
//  BillingInputView.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit
import Combine
import CombineCocoa

class BillingInputView : UIView{
    
    //MARK: - Elements of Combine
    //this pass through subject will store the value of textfield, and that can be shared with other classes
    //we can do the same thing with delegates, closures, but we do with Combine way
    private let billSubject : PassthroughSubject <Double, Never> = .init()
    //but above pass through subject is private, how do we access it outside
    //we declare another publisher, that return the passthroughsubject
    //lets publish the values that we have in the textfield
    var valuePubliser : AnyPublisher<Double, Never>{
        return billSubject.eraseToAnyPublisher()
    }
    private var cancellable = Set<AnyCancellable>()
    
    
    
    private let _headerView : HeaderView  = {
        return HeaderView(text1:"Enter", text2:"you bill")
    }()
    
    
    private let _txtContainerView : UIView = {
       let some = UIView()
        some.backgroundColor = .white
        some.addCornorRadius(radius: 8.0)
        return some
    }()
    
    private let _currencyDenominationLabel : UILabel = {
        let some = LabelFactory.build(text:"$", font: AppFont.bold(24))
        //this label hug itself and takes minimum space compared to its partner
        some.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return some
    }()
    
    private lazy var _txtField : UITextField = {
        let some = UITextField()
        //the opposite of the $ text
        some.setContentHuggingPriority(.defaultLow, for: .horizontal)
        some.keyboardType = .decimalPad
        some.borderStyle = .none
        some.textColor = ThemeColors.text
        some.tintColor = ThemeColors.text
        
        //Add toolbar
        let toolbar = UIToolbar(frame: CGRect(x:0, y:0, width:frame.size.width, height:36))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        //add done button to toolbar
        let doneButton = UIBarButtonItem(title:"Done",
                                         style:.plain,
                                         target:self,
                                         action:#selector(doneButtonTapped))
        
        
        toolbar.items = [UIBarButtonItem(barButtonSystemItem:.flexibleSpace,
                                         target: nil, action:nil), doneButton]
        
        some.inputAccessoryView = toolbar
        
        return some
    }()
    
    @objc private func doneButtonTapped(){
        _txtField.endEditing(true)
    }
                            
                                         
                                         
                                         
                                         
                                         
    override init(frame:CGRect) {
        //.zero becasue we use autolayouts and not the frame
        super.init(frame: .zero)
        setupLayout()
        observeBIV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func resetBIV(){
        _txtField.text = ""
        billSubject.send(0)
    }
    
    
    //so where goes the value entered into textfield, lets Observe them first.
    private func observeBIV(){
        
        _txtField.textPublisher.sink { [unowned self] txt in
            billSubject.send(txt?.doubleValue ?? 0)
            print("text \(txt)")
            
        }.store(in: &cancellable)
        
        
    }
    
    
    private func setupLayout(){
        self.backgroundColor = .clear
        
        self.addSubview(_headerView)
        self.addSubview(_txtContainerView)
        
        
        _headerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            //make.centerY.equalTo(_txtContainerView.snp.centerY)
            //make.top.equalToSuperview()
            //make.bottom.equalToSuperview()
            make.width.equalTo(68.0)
            //make.trailing.equalTo(_txtContainerView.snp.leading).offset(-24)
        }

        _txtContainerView.addSubview(_currencyDenominationLabel)
        _txtContainerView.addSubview(_txtField)
        
        _txtContainerView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(_headerView.snp.trailing).offset(16)
        }


        _currencyDenominationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(_txtContainerView.snp.leading).offset(16)
        }
        

        _txtField.snp.makeConstraints { make in
            make.leading.equalTo(_currencyDenominationLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        
        
    }
    
}
