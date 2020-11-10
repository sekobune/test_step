//
//  CirclesView.swift
//  PuppyStep
//
//  Created by Sergey on 10/24/20.
//

import Foundation
import UIKit

class CircleView: UIView {
    
    private let firstCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.layer.borderColor = UIColor.mainSecond().cgColor
        view.layer.borderWidth = 4
        return view
    }()
    private let secondCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.layer.borderColor = UIColor.mainSecond().cgColor
        view.layer.borderWidth = 4
        return view
    }()
    private let thirdCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.layer.borderColor = UIColor.mainSecond().cgColor
        view.layer.borderWidth = 4
        return view
    }()
    private let fourthCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.layer.borderColor = UIColor.mainSecond().cgColor
        view.layer.borderWidth = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        arrangeSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        firstCircleView.layer.cornerRadius = firstCircleView.bounds.size.height / 2
        firstCircleView.clipsToBounds = true
        secondCircleView.layer.cornerRadius = secondCircleView.bounds.size.height / 2
        secondCircleView.clipsToBounds = true
        thirdCircleView.layer.cornerRadius = thirdCircleView.bounds.size.height / 2
        thirdCircleView.clipsToBounds = true
        fourthCircleView.layer.cornerRadius = fourthCircleView.bounds.size.height / 2
        fourthCircleView.clipsToBounds = true
    }
}

private extension CircleView {
    
    func addSubviews() {
        addSubview(firstCircleView)
        addSubview(secondCircleView)
        addSubview(thirdCircleView)
        addSubview(fourthCircleView)
    }

    func arrangeSubviews() {
        firstCircleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(40)
            make.height.equalToSuperview().dividedBy(4)
            make.width.equalTo(firstCircleView.snp.height)
        }
        secondCircleView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview().offset(-50)
            make.height.equalToSuperview().dividedBy(5)
            make.width.equalTo(secondCircleView.snp.height)
        }
        thirdCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().inset(70)
            make.trailing.top.equalToSuperview().inset(-30)
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalTo(thirdCircleView.snp.height)
        }
        fourthCircleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalToSuperview().dividedBy(6)
            make.width.equalTo(fourthCircleView.snp.height)
        }
    }
}
