//
//  LogoView.swift
//  tip-calculator
//
//  Created by Yasir on 27/09/2024.
//

import UIKit
import SnapKit

class LogoView : UIView{
    
    
    private let _imgView :UIImageView = {
        let _img = UIImage(named:"icCalculatorBW")!
        let _imgView = UIImageView(image:_img)
        _imgView.contentMode = .scaleAspectFit
        return _imgView
    }()
    
    
    private let _lblSome : UILabel = {
        let label = UILabel()
        label.textColor = ThemeColors.text
        //label.backgroundColor = .green
        let someText = NSMutableAttributedString(string:"Mr TIP", attributes:
                                                    [.font : AppFont.demibold(16)])
        someText.addAttributes([.font :AppFont.bold(24)], range:NSMakeRange(3, 3))
        label.attributedText = someText
        return label
    }()
    
    private  let _lblCalculator : UILabel = {
        LabelFactory.build(text:"Calculator",
                           font:AppFont.demibold(20),
                           backgroundColor:.clear,
                                   alignment:.left)
    }()
    
    
    private lazy var _vStack : UIStackView = {
       let some = UIStackView(arrangedSubviews: [_lblSome, _lblCalculator])
        some.axis = .vertical
        some.spacing = 0.0
        return some
    }()
    
    private lazy var _hStack : UIStackView = {
        let some = UIStackView(arrangedSubviews: [_imgView, _vStack])
        some.axis = .horizontal
        some.spacing = 0.0
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
        
        //self.backgroundColor = .systemCyan

        self.addSubview(_hStack)
        self._hStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self._imgView.snp.makeConstraints { make in
            make.height.equalTo(_imgView.snp.width)
        }
        
        
    }
    
}








