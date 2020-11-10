//
//  DogHolderViewCell.swift
//  PuppyStep
//
//  Created by Sergey on 10/20/20.
//

import Foundation
import UIKit
import Kingfisher

class DogCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier = "DogCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 30)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .right
        return label
    }()
    
    private let breedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AmericanTypewriter", size: 20)
        label.textColor = UIColor.blackWhite()
        label.textAlignment = .right
        return label
    }()
    
    private let photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        //        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImage.layer.cornerRadius = 0.5 * photoImage.bounds.size.height
        photoImage.clipsToBounds = true
    }
    
    func configure(with dog: Dog) {
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        
        guard let photoUrlString = dog.photoUrl else { return }
        
        let url = URL(string: photoUrlString)
        let processor = RoundCornerImageProcessor(cornerRadius: 0.5 * photoImage.bounds.size.height)
        
        photoImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "LogoImage"),
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
    }
}

private extension DogCollectionViewCell {
    func addSubviews() {
        addSubview(nameLabel)
        addSubview(breedLabel)
        addSubview(photoImage)
    }
    
    func arrangeSubviews() {
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.trailing.equalToSuperview().inset(15)
        }
        breedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(15)
        }
        photoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(self.contentView.bounds.height/1.3)
        }
    }
}

extension DogCollectionViewCell {
    func styleCell() {
        self.contentView.layer.cornerRadius = 30
        self.contentView.layer.borderWidth = 1.0
        
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = UIColor.secondary()
        self.backgroundView?.layer.cornerRadius = 30
        //        self.contentView.layer.backgroundColor = UIColor.secondary().cgColor
        
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
                
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
    }
}
