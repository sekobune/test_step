//
//  Coordinator.swift
//  PuppyStep
//
//  Created by Sergey on 10/25/20.
//

import Foundation
import UIKit

protocol Coordinator {
//    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
