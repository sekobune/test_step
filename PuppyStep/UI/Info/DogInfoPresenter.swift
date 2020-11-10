//
//  DogInfoPresenter.swift
//  PuppyStep
//
//  Created by Sergey on 11/2/20.
//

import Foundation

class DogInfoPresenter: DogInfoViewPresenter {
    
    private var view: DogInfoView!
    private var coordinator: AppCoordinator!
    
    private var bringDog: BringWalkingDogUseCaseImpl
    private var walkDog: WalkDogUseCaseImpl
    
    private let repository = DogsDataRepository(remoteDataSource: RemoteFirestoreDataSource(), localDataSource: LocalRealmDataSource())
        
    required init(view: DogInfoView, coordinator: AppCoordinator) {
        self.view = view
        self.coordinator = coordinator
        bringDog = BringWalkingDogUseCaseImpl(dogsRepository: repository)
        walkDog = WalkDogUseCaseImpl(dogsRepository: repository)
    }
    
    func bringCurrentDog(currentDog: Dog) {
        print("Bring dog \(currentDog.name!)")
        bringDog.execute(DogRequestValue.init(data: currentDog)) { (success) in
            if(success) {
                print("Success bringDog")
                self.view.closeModal()
            } else {
                print("Failure bringDog")
            }
        }
    }
    
    //check if I already have dog
    func takeSelectedDog(selectedDog: Dog) {
        walkDog.execute(DogRequestValue.init(data: selectedDog)) { (success) in
            if(success) {
                print("Success takeDog")
                self.view.closeModal()

            } else {
                print("Failure takeDog")
            }
        }
        view.closeModal()
    }
}
