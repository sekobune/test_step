//
//  DogInfoContract.swift
//  PuppyStep
//
//  Created by Sergey on 11/2/20.
//

import Foundation

protocol DogInfoView {
    func configure(presenter: DogInfoViewPresenter, selectedDog: Dog, isWalkingDog: Bool)
    func closeModal()
}

protocol DogInfoViewPresenter {
    init(view: DogInfoView, coordinator: AppCoordinator)
    func takeSelectedDog(selectedDog: Dog)
    func bringCurrentDog(currentDog: Dog)
}
