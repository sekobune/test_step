//
//  File.swift
//  PuppyStep
//
//  Created by Sergey on 10/9/20.
//

import Foundation

class WelcomePresenter: WelcomeViewPresenter {
    
    private var view: WelcomeView!
    private var coordinator: AppCoordinator!
    
    required init(view: WelcomeView, coordinator: AppCoordinator) {
        self.view = view
        self.coordinator = coordinator
    }
    
    func navigateToSearchScreen() {
        coordinator.navigateToSearch()
    }
    
}
