//
//  DetailsPresenter.swift
//  PuppyStep
//
//  Created by Sergey on 10/29/20.
//

import Foundation
import os.log

class DetailsPresenter: DetailsViewPresenter {

    private var view: DetailsView!
    private var coordinator: AppCoordinator!
        
    private var fetchDogs: FetchDogsByDogHolderUseCaseImpl
    
    private let repository = DogsDataRepository(remoteDataSource: RemoteFirestoreDataSource(), localDataSource: LocalRealmDataSource())
    
    
    required init(view: DetailsView, coordinator: AppCoordinator) {
        self.view = view
        self.coordinator = coordinator
        fetchDogs = FetchDogsByDogHolderUseCaseImpl(dogsRepository: repository)
    }
    
    func getDogsData(dogHolderName: String) {
        os_log("getAllDogsByHolderName")
        fetchDogs.execute(DogHolderRequestValue.init(data: dogHolderName)) { (dogs, success) in
            self.view.hideRefreshControl()
            if (success) {
                if (dogs.isEmpty) {
                    self.view.showEmptyDataView()
                } else {
                    self.view.hideEmptyDataView()
                    self.view.showDogsData(dogs: dogs)
                }
            } else {
                os_log("Error with getting all dogs info by holder name")
            }
        }
    }
    
    func navigateToDogInfoScreen(selectedDog: Dog) {
        coordinator.navigateToDogInfo(dog: selectedDog, isWalkingDog: false)
    }
    
}
