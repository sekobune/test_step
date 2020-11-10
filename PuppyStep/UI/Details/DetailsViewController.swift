//
//  DetailsViewController.swift
//  PuppyStep
//
//  Created by Sergey on 10/16/20.
//

import Foundation
import UIKit
import PanModal
import SnapKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {

    private var presenter: DetailsViewPresenter!
    
    private let disposeBag = DisposeBag()

    var selectedDogHolder: DogHolder!
    
    var dogsArray: [Dog] = []
    
    //MARK: - Views init
    private let holderNameLabel: UnderlinedLabel = {
        let label = UnderlinedLabel()
        label.font = UIFont(name: "SnellRoundhand-Bold", size: 40)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .center
        return label
    }()
    private let refreshControl = UIRefreshControl()
    private let dogsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DogCollectionViewCell.self, forCellWithReuseIdentifier: DogCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    private let emptyDataLabel: UILabel = {
        let label = UILabel()
        label.text = "All dogs are walking"
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 30)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .center
        return label
    }()
    private let emptyDataImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "LogoImage")
        return imageView
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
        presenter.getDogsData(dogHolderName: selectedDogHolder.title ?? "Unknown")
    }
}

//MARK: - UI
private extension DetailsViewController {
    
    func setupView() {
        view.backgroundColor = UIColor.mainSecond()
        holderNameLabel.text = selectedDogHolder.title
        dogsCollection.dataSource = self
        dogsCollection.delegate = self
        dogsCollection.refreshControl = refreshControl
        hideEmptyDataView()
    }
    
    func addSubviews() {
        view.addSubview(holderNameLabel)
        view.addSubview(dogsCollection)
        view.addSubview(emptyDataImage)
        view.addSubview(emptyDataLabel)
    }

    func arrangeSubviews() {
        holderNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(30)
        }
        
        dogsCollection.snp.makeConstraints { make in
            make.top.equalTo(holderNameLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        emptyDataImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(self.view.bounds.width / 2)
        }
        
        emptyDataLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyDataImage.snp.bottom).inset(20)
        }
    }
    
    func setupActions() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.presenter.getDogsData(dogHolderName: self.selectedDogHolder.title!)
            })
            .disposed(by: self.disposeBag)
    }
    
}

//I don't like to use navigationController here but for swipe to pop only from this screen it's needed
extension DetailsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer) {
            return true
        }
        return false
    }
}

//BUG: Remove dog operation doesnt remove dog from collection view
extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //NOTE: If I add this code, pictures in cells will repeat
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogCollectionViewCell.reuseIdentifier, for: indexPath) as? DogCollectionViewCell else {
//            return UICollectionViewCell()
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DogCollectionViewCell.reuseIdentifier, for: indexPath) as! DogCollectionViewCell
        cell.configure(with: dogsArray[indexPath.row])
        cell.styleCell()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.94, height: collectionView.frame.height/6.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.navigateToDogInfoScreen(selectedDog: dogsArray[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundView?.backgroundColor = UIColor.secondaryPressed()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundView?.backgroundColor = UIColor.secondary()
        }
    }
}

//MARK: - View contract
extension DetailsViewController: DetailsView {
    
    func configure(presenter: DetailsViewPresenter, dogHolder: DogHolder) {
        self.presenter = presenter
        self.selectedDogHolder = dogHolder
    }
    
    func showDogsData(dogs: [Dog]) {
        print(dogs.count)
        dogsArray = dogs.sorted(by: {$0.name! < $1.name!})
        dogsCollection.reloadData()
    }
    
    func hideRefreshControl() {
        self.refreshControl.endRefreshing()
    }
    
    func showEmptyDataView() {
        emptyDataImage.isHidden = false
        emptyDataLabel.isHidden = false
    }
    
    func hideEmptyDataView() {
        emptyDataImage.isHidden = true
        emptyDataLabel.isHidden = true
    }
}
