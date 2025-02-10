//
//  HeaderView.swift
//  tip-calculator
//
//  Created by Yasir on 03/10/2024.
//

import UIKit

class HeaderView: UIView {
    
    private var text1 : String = "Enter"
    private var text2 : String = "your bill"
    
    
    private lazy var _lblLine1 : UILabel = {
        LabelFactory.build(text:text1, font:AppFont.bold(16), alignment:.left)
    }()

    private lazy var _lblLine2 : UILabel = {
        LabelFactory.build(text:text2, font:AppFont.regular(16), alignment:.left)
    }()

    
    private lazy var _vStack : UIStackView = {
       let some = UIStackView(arrangedSubviews:[_lblLine1, _lblLine2])
        some.axis = .vertical
        return some
    }()
    
    
    init(text1:String, text2:String) {
        super.init(frame:.zero)
    
        self.text1 = text1
        self.text2 =  text2
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(){
        backgroundColor = .clear
        
        self.addSubview(_vStack)
        _vStack.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
