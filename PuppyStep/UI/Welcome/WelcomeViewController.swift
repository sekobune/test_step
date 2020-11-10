//
//  ViewController.swift
//  PuppyStep
//
//  Created by Sergey on 9/23/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {
    
    private var presenter: WelcomeViewPresenter!
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Views init
    private lazy var upperView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainFirst()
        return view
    }()
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "PuppyStep"
        label.font = UIFont(name: "SnellRoundhand-Bold", size: 70)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .center
        return label
    }()
    private let beginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "LogoImage"), for: .normal)
        button.backgroundColor = UIColor.mainFirst()
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    private let circleView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.mainSecond()
//        view.layer.borderColor = UIColor.mainFirst().cgColor
        view.backgroundColor = .none
        view.layer.borderColor = UIColor.mainFirst().cgColor
        view.layer.borderWidth = 4
        return view
    }()
    private let secondCircleView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.mainFirst()
//        view.layer.borderColor = UIColor.mainFirst().cgColor
        view.backgroundColor = .none
        view.layer.borderColor = UIColor.mainFirst().cgColor
        view.layer.borderWidth = 4
        return view
    }()
    private let backgroundCircleView: CircleView = {
        let view = CircleView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        arrangeSubviews()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundBottomCorners(cornerRadius: 130)
        beginButton.layer.cornerRadius = 0.5 * beginButton.bounds.size.width
        circleView.layer.cornerRadius = 0.5 * circleView.bounds.size.width
        secondCircleView.layer.cornerRadius = 0.5 * secondCircleView.bounds.size.width

        
//        UIView.animate(withDuration: 2, animations: { [self] in
//            self.circleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        })
       
        let firstObservable = scale(circleView, duration: 2, scaleValue: 1.15)
        let secondObservable = scale(secondCircleView, duration: 2, scaleValue: 1.3)
        
        firstObservable.concat(secondObservable)
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}

func scale(_ view: UIView, duration: TimeInterval, scaleValue: CGFloat) -> Observable<Void> {
    return Observable.create { (observer) -> Disposable in
        UIView.animate(withDuration: duration, animations: {
            view.transform = CGAffineTransform(scaleX: scaleValue, y: scaleValue)
        }, completion: { (_) in
            observer.onNext(())
            observer.onCompleted()
        })
        return Disposables.create()
    }
}

//MARK: - UI
private extension WelcomeViewController {
    
    func setupView() {
        view.backgroundColor = UIColor.mainSecond()
    }
    
    func addSubviews() {
        view.addSubview(upperView)
        view.addSubview(secondCircleView)
        view.addSubview(circleView)
        view.addSubview(beginButton)
        upperView.addSubview(backgroundCircleView)
        upperView.addSubview(logoLabel)
    }

    func arrangeSubviews() {
        let bottomInset = self.view.bounds.height / 1.6
        upperView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomInset)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(90)
            make.centerX.equalToSuperview()
        }
        
        beginButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(150)
            make.width.height.equalTo(self.view.bounds.height / 4)
        }
        
        circleView.snp.makeConstraints { make in
            make.centerX.equalTo(beginButton.snp.centerX)
            make.centerY.equalTo(beginButton.snp.centerY)
            make.width.height.equalTo(beginButton.snp.width)
        }
        
        secondCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(beginButton.snp.centerX)
            make.centerY.equalTo(beginButton.snp.centerY)
            make.width.height.equalTo(beginButton.snp.width)
        }
        
        backgroundCircleView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        beginButton.rx.tap
            .bind {
                let firstObservable = scale(self.circleView, duration: 0.5, scaleValue: 1)
                let secondObservable = scale(self.secondCircleView, duration: 0.4, scaleValue: 1)
                
                firstObservable.concat(secondObservable)
                    .subscribe(onCompleted: {
                        self.presenter.navigateToSearchScreen()
                    })
                    .disposed(by: self.disposeBag)
                
//                UIView.animate(
//                    withDuration: 1,
//                    animations: { [self] in
//                        self.circleView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//                    },
//                    completion: { _ in
//                        self.presenter.begin()
//                    }
//                )
                
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - View contract
extension WelcomeViewController: WelcomeView {
    
    func configure(presenter: WelcomeViewPresenter) {
        self.presenter = presenter
    }
    
}

extension UIView {
    func roundBottomCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}

extension UIView {
    func roundTopCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}
