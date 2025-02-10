//
//  ResultView.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit
import SnapKit

class ResultView : UIView{
    
    private let _lblHeader : UILabel = {
        LabelFactory.build(text:"Total p/person",
                           font: AppFont.demibold(18),
                           alignment: .center)
    }()
    
    
    private let _lblTotalAmount : UILabel = {
        
        let some = UILabel()
        some.textAlignment = .center
        let attributedText = NSMutableAttributedString(string:"$0",
                                                       attributes: [.font : AppFont.bold(48)])
        attributedText.addAttributes([.font : AppFont.bold(24)], range: NSMakeRange(0, 1))
        some.attributedText = attributedText
        return some
    }()
    
    
    private let _horizontalLine : UIView = {
        let some = UIView()
        some.backgroundColor = ThemeColors.separator
        return some
    }()
    
    
    private lazy var _vStack : UIStackView = {
       let some = UIStackView(arrangedSubviews: [
        _lblHeader,
        _lblTotalAmount,
        _horizontalLine,
        buildSpacerView(height:0),
        _hStack
       ])
        
        some.axis = .vertical
        some.spacing = 8
        return some
    }()
    
    
    private lazy var _billAmount : AmountView = {
        let some = AmountView(text:"Total bil", align: .left)
        return some
    }()
    
    private lazy var _tipAmount : AmountView = {
        let some = AmountView(text:"Total tip", align: .right)
        return some
    }()
    
    
    private lazy var _hStack : UIStackView = {
       let some = UIStackView(arrangedSubviews: [
        _billAmount,
        UIView(),
        _tipAmount])
                              
        some.axis = .horizontal
        some.distribution = .fillEqually
        return some
    }()
    
    
    
    
    init() {
        //.zero becasue we use autolayouts and not the frame
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout(){
        self.backgroundColor = .white
        
        addSubview(_vStack)
        _vStack.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(24.0)
            make.trailing.equalTo(snp.trailing).offset(-24.0)
            make.top.equalTo(snp.top).offset(24.0)
            make.bottom.equalTo(snp.bottom).offset(-24.0)
        }
        
        _horizontalLine.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        self.addShadow(offSet:CGSize(width:0, height: 3), color:.black, radius:12.0, opacity: 0.1)
    }
    
    
    private func buildSpacerView(height:CGFloat)->UIView{
        let some = UIView()
        some.heightAnchor.constraint(equalToConstant:height).isActive = true
        return some
    }
    
    func configure(res:ResultFinal){
        
        //set per person
        let attributedText = NSMutableAttributedString(string:"\(res.totalPerPerson.currencyFormatted)",
                                                       attributes: [.font : AppFont.bold(48)])
        attributedText.addAttributes([.font : AppFont.bold(24)], range: NSMakeRange(0, 1))
        _lblTotalAmount.attributedText = attributedText
        
        //apply total bill
        _billAmount.applyAmount(value:res.totalBill)
        
        //apply total bill
        _tipAmount.applyAmount(value: res.totalTip)
    }
    
}

//============================================================
class AmountView : UIView {
    
    private let title:String
    private let alignIn: NSTextAlignment
    
    
    private lazy var _lblLabel : UILabel = {
        LabelFactory.build(text:title, font:AppFont.bold(18), textColor:ThemeColors.text,alignment:alignIn)
    }()
    
    
    private lazy var _lblValue : UILabel = {
       let some = UILabel()
        let attributedText = NSMutableAttributedString(string:"$0", attributes: [.font : AppFont.bold(24)])
        attributedText.addAttributes([.font : AppFont.bold(16)], range: NSMakeRange(0, 1))
        some.attributedText = attributedText
        some.textColor = ThemeColors.primary
        some.textAlignment = alignIn
        return some
    }()
    
    private lazy var _vStack : UIStackView = {
       let some = UIStackView(arrangedSubviews: [_lblLabel, _lblValue])
        some.distribution = .fillEqually
        some.axis = .vertical
        return some
    }()
    
    init(text:String, align:NSTextAlignment) {
        title = text
        alignIn = align
        super.init(frame:.zero)
        setupLayout()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame:frame)
//        self.setupLayout()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        //self.backgroundColor = .red
        addSubview(_vStack)
        _vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func applyAmount(value:Double){
        let attributedText = NSMutableAttributedString(string:"\(value.currencyFormatted)", attributes: [.font : AppFont.bold(24)])
        attributedText.addAttributes([.font : AppFont.bold(16)], range: NSMakeRange(0, 1))
        _lblValue.attributedText = attributedText
    }
}

