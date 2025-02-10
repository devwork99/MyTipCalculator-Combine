//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit
import QuartzCore
import Combine
import CombineCocoa


class SplitInputView : UIView{
    
    //MARK: - Elements of Combine
    private var cancelable = Set<AnyCancellable>()
    private let splitSubject : CurrentValueSubject<Int,Never> = .init(1)
    var valuePublisher : AnyPublisher <Int,Never> {
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    
    
    private lazy var _headerView : HeaderView  = {
        return HeaderView(text1:"Split", text2:"the total")
    }()
    
    private lazy var _btnDecrement : UIButton = {
        let some = buildButton(text:"-", cornors: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        
        some.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }.assign(to:\.value, on: splitSubject)
        .store(in: &cancelable)
        
        
        return some
    }()
    
    private lazy var _btnIncrement : UIButton = {
        let some = buildButton(text:"+", cornors: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        
        //FLAT MAP
        //it combines multiple arrays of same type to one array
        //in here it says, it transform all publishers into a one publiser
        some.tapPublisher.flatMap { [unowned self] _ in
            
            Just(splitSubject.value + 1)
            
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancelable)
        
        return some
    }()
    
    private lazy var _lblCount : UILabel = {
        let some = LabelFactory.build(text:"1", font: AppFont.bold(20))
        //some.backgroundColor = .gray
        return some
    }()
    
    private lazy var _hStack : UIStackView = {
        let some = UIStackView(arrangedSubviews: [_btnDecrement, _lblCount, _btnIncrement])
        some.axis = .horizontal
        //some.distribution = .fillEqually
        some.spacing = 0.0
        some.backgroundColor = .white
        return some
    }()
    
    init() {
        //.zero becasue we use autolayouts and not the frame
        super.init(frame: .zero)
        setupLayout()
        observeSplitNumber()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func observeSplitNumber(){
     
        splitSubject.sink { [unowned self] quantity in
            _lblCount.text = "\(quantity)"
        }.store(in: &cancelable)
        
    }
    
    func resetSIV(){
        splitSubject.send(1)
    }
    
    private func setupLayout(){
        //self.backgroundColor = .systemYellow

        [_headerView,_hStack].forEach(addSubview(_:))
        
        
        _headerView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(68)
        }
        
        
        _hStack.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(_headerView.snp.trailing).offset(24)
        }
        
        [_btnDecrement, _btnIncrement].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
    }
    
    private func buildButton(text:String, cornors:CACornerMask) -> UIButton {
        let some = UIButton(type:.custom)
        some.setTitle(text, for: .normal)
        some.titleLabel?.textColor = ThemeColors.primary
        some.titleLabel?.font = AppFont.bold(20)
        some.backgroundColor = ThemeColors.primary
        some.addRounderCorners(corners:cornors, radius: 8)
        return some
    }
    
    
    
}
