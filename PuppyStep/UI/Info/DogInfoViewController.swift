//
//  DogInfoViewController.swift
//  PuppyStep
//
//  Created by Sergey on 11/2/20.
//

import Foundation
import UIKit
import PanModal
import RxSwift
import RxCocoa

class DogInfoViewController: UIViewController {
    
    private var presenter: DogInfoViewPresenter!
    
    //free in deinit
    private let disposeBag = DisposeBag()
    
    private var currentDog: Dog!
    private var isWalkingDog: Bool!
    
    //MARK: - Views init
    private let dogNameLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont(name: "SnellRoundhand-Bold", size: 40)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .center
        return label
    }()
    private lazy var dogImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var takeBringDogButton: UIButton = {
        let button = UIButton(type: .roundedRect)
//        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.blackWhite(), for: .normal)
        button.backgroundColor = UIColor.mainFirst()
        return button
    }()
    private let dogBreedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 25)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .left
        return label
    }()
    private let dogAgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 20)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .left
        return label
    }()
    private let dogGenderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 20)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .left
        return label
    }()
    private let dogDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 16)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        arrangeSubviews()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dogImage.kf.setImage(
            with: URL(string: currentDog.photoUrl!),
            placeholder: UIImage(named: "LogoImage"),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        dogImage.kf.setImage(
//            with: URL(string: currentDog.photoUrl!),
//            placeholder: UIImage(named: "LogoImage"),
//            options: [
//                .transition(.fade(1)),
//                .cacheOriginalImage
//            ]
//        )
//    }
}

//MARK: - UI
private extension DogInfoViewController {
    
    func setupView() {
        view.backgroundColor = UIColor.mainSecond()
        
        dogImage.layer.cornerRadius = 30
        dogImage.clipsToBounds = true
        
        setupBringDogButton()
        
        dogNameLabel.text = currentDog.name!
        dogBreedLabel.text = currentDog.breed!
        dogAgeLabel.text = "Age: \(currentDog.age ?? 0)"
        dogGenderLabel.text = "Gender \(currentDog.gender!.rawValue)"
        dogDescriptionLabel.text = currentDog.dogDescription!
    }
    
    func addSubviews() {
        view.addSubview(dogNameLabel)
        view.addSubview(dogImage)
        view.addSubview(dogBreedLabel)
        view.addSubview(dogAgeLabel)
        view.addSubview(dogGenderLabel)
        view.addSubview(dogDescriptionLabel)

        view.addSubview(takeBringDogButton)
    }
    
    func arrangeSubviews() {
        dogNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
        }
        dogImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(dogNameLabel.snp.bottom).offset(15)
            make.height.equalTo(self.view.bounds.height/5)
        }
        dogBreedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(dogImage.snp.bottom).offset(10)
        }
        dogAgeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(dogBreedLabel.snp.bottom).offset(10)
        }
        dogGenderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.equalTo(dogAgeLabel.snp.bottom).offset(10)
        }
        dogDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(dogGenderLabel.snp.bottom).offset(15)
//            make.bottom.equalToSuperview().inset(self.view.bounds.height/4)
//            make.height.equalToSuperview().dividedBy(4)
        }
        takeBringDogButton.snp.makeConstraints{ make in
            make.centerY.equalTo(dogAgeLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(30)
            make.width.height.equalTo(dogImage).dividedBy(4)
        }
        
    }
    
    func setupActions() {
        takeBringDogButton.rx.tap
            .bind {
                self.isWalkingDog
                    ? self.presenter.bringCurrentDog(currentDog: self.currentDog)
                    : self.presenter.takeSelectedDog(selectedDog: self.currentDog)
                
            }
            .disposed(by: disposeBag)
    }
}

extension DogInfoViewController {
    func setupBringDogButton() {
        let buttonColor = isWalkingDog ? UIColor.lightGray : UIColor.mainFirst()
        takeBringDogButton.backgroundColor = buttonColor
        takeBringDogButton.setTitle(isWalkingDog ? "Bring" : "Take", for: .normal)
        takeBringDogButton.layer.cornerRadius = 15
        takeBringDogButton.clipsToBounds = true
    }
}

extension DogInfoViewController: DogInfoView {
    
    func configure(presenter: DogInfoViewPresenter, selectedDog: Dog, isWalkingDog: Bool) {
        self.presenter = presenter
        self.currentDog = selectedDog
        self.isWalkingDog = isWalkingDog
    }
    
    func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DogInfoViewController: PanModalPresentable {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(200)
    }
    
    var anchorModalToLongForm: Bool {
        return false
    }
}
