//
//  DetailsContract.swift
//  PuppyStep
//
//  Created by Sergey on 10/28/20.
//

import Foundation

//MARK: - View contract
protocol DetailsView {
    func configure(presenter: DetailsViewPresenter, dogHolder: DogHolder)
    func showDogsData(dogs: [Dog])
    func hideRefreshControl()
    func showEmptyDataView()
    func hideEmptyDataView()
}

//MARK: - Presenter contract
protocol DetailsViewPresenter {
    init(view: DetailsView, coordinator: AppCoordinator)
    func getDogsData(dogHolderName: String)
    func navigateToDogInfoScreen(selectedDog: Dog)
    
    //here add taking time
//    func takeSelectedGog(selectedDog: Dog)
}
