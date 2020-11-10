//
//  WelcomeContract.swift
//  PuppyStep
//
//  Created by Sergey on 10/9/20.
//

import Foundation

//MARK: - View contract
protocol WelcomeView {
    func configure(presenter: WelcomeViewPresenter)
}

//MARK: - Presenter contract
protocol WelcomeViewPresenter {
    init(view: WelcomeView, coordinator: AppCoordinator)
    func navigateToSearchScreen()
}

