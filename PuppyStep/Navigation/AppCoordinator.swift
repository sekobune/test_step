//
//  MainCoordinator.swift
//  PuppyStep
//
//  Created by Sergey on 10/25/20.
//

import Foundation
import UIKit
import PanModal

class AppCoordinator: Coordinator {
//    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        let vc = WelcomeViewController()
        let presenter = WelcomePresenter(view: vc, coordinator: self)
        vc.configure(presenter: presenter)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToSearch() {
        let vc = MapSearchViewController()
        let presenter = MapSearchPresenter(view: vc, coordinator: self)
        vc.configure(presenter: presenter)

        navigationController.pushViewController(vc, animated: true)
        navigationController.viewControllers.remove(at: 0)
    }
    
    func navigateToDetails(dogHolder: DogHolder) {
        let vc = DetailsViewController()
        let presenter = DetailsPresenter(view: vc, coordinator: self)
        vc.configure(presenter: presenter, dogHolder: dogHolder)

        navigationController.interactivePopGestureRecognizer?.delegate = vc
        navigationController.interactivePopGestureRecognizer?.isEnabled = true

        navigationController.pushViewController(vc, animated: true)
    }
    
    //swiftgen add
    func navigateToDogInfo(dog: Dog, isWalkingDog: Bool) {
        let vc = DogInfoViewController()
        let presenter = DogInfoPresenter(view: vc, coordinator: self)
        vc.configure(presenter: presenter, selectedDog: dog, isWalkingDog: isWalkingDog)

        unowned let controllingVC = navigationController.viewControllers.last
        controllingVC?.presentPanModal(vc)
    }
    
}
