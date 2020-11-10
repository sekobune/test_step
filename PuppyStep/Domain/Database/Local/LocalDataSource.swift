//
//  LocalRealmModel.swift
//  PuppyStep
//
//  Created by Sergey on 11/2/20.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

protocol LocalDataSource {    
    func addDogData(dog: Dog) -> Single<Void>
    func removeDogData(dog: Dog) -> Single<Void>
    func getDogData() -> Single<Dog?>
}

class LocalRealmDataSource: LocalDataSource {
    
    private let db = try! Realm()
    
    private let disposeBag = DisposeBag()
    
    var currentDog: Dog?
    
    func addDogData(dog: Dog) -> Single<Void> {
        let dogModel = transformDogToDogModel(dogObject: dog)
        return db.rx.addData(dogModel)
    }
    
    func removeDogData(dog: Dog) -> Single<Void> {
        let dogModel = transformDogToDogModel(dogObject: dog)
        return db.rx.removeData(dogModel)
        
    }
    
    func getDogData() -> Single<Dog?> {
        return db.rx.getData()
            .map({ (element) -> Dog? in
                let currentDogModel = element as? DogDBO
                return self.transformDogModelToDog(dogModel: currentDogModel)
            })
    }
    
    private func transformDogToDogModel(dogObject: Dog) -> DogDBO {
        let dogModel = DogDBO()
        
        dogModel.name = dogObject.name!
        dogModel.breed = dogObject.breed!
        dogModel.age = dogObject.age!
        dogModel.photoUrl = dogObject.photoUrl!
        dogModel.gender = dogObject.gender!.rawValue
        dogModel.dogDescription = dogObject.dogDescription!
        dogModel.home = dogObject.home!
        
        return dogModel
    }
    
    private func transformDogModelToDog(dogModel: DogDBO?) -> Dog? {
        guard let dog = dogModel else {
            return nil
        }
        return Dog(
            name: dog.name,
            breed: dog.breed,
            age: dog.age,
            photoUrl: dog.photoUrl,
            gender: DogGender.init(rawValue: dog.gender),
            dogDescription: dog.dogDescription,
            home: dog.home
        )
    }
}
