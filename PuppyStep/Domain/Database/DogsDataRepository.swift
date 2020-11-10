//
//  DogsDataRepository.swift
//  PuppyStep
//
//  Created by Sergey on 11/9/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import RxSwift
import RxCocoa
import RealmSwift

typealias DogHoldersCompletion = (_ dogHolders: [DogHolder], _ success: Bool) -> ()
typealias DogsCompletion = (_ dogs: [Dog], _ success: Bool) -> ()
typealias DogCompletion = (_ dog: Dog?, _ success: Bool) -> ()
typealias InfoCompletion = (_ success: Bool) -> ()

protocol DogsRepository {
    func fetchDogHolders(completion: @escaping DogHoldersCompletion)
    func fetchDogs(dogHolderName: String, completion: @escaping DogsCompletion)
    func fetchCurrentDog(completion: @escaping DogCompletion)
    func walkDog(dog: Dog, completion: @escaping InfoCompletion)
    func bringWalkingDog(dog: Dog, completion: @escaping InfoCompletion)
}

public class DogsDataRepository: DogsRepository {
    
    private let remoteDataSource: RemoteDataSource
    private let localDataSource: LocalDataSource
    
    private let disposeBag = DisposeBag()

    //even if operations are fast and doesnt block UI
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler.init(qos: .background)
    
    init(remoteDataSource: RemoteDataSource, localDataSource: LocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetchDogHolders(completion: @escaping DogHoldersCompletion) {
        remoteDataSource.getAllDogHolders()
                .subscribe(onNext: { dogHolders in
                    completion(dogHolders, true)
                }, onError: { error in
                    print("Error fetching snapshots: \(error)")
                    completion([], false)
                }).disposed(by: disposeBag)      
    }
    
    func fetchDogs(dogHolderName: String, completion: @escaping DogsCompletion) {
        remoteDataSource.getAllDogsByHolderName(dogHolderName: dogHolderName)
            .subscribe(onNext: { dogs in
                completion(dogs, true)
            }, onError: { error in
                print("Error fetching snapshots: \(error)")
                completion([], false)
            }).disposed(by: disposeBag)
    }
    
    func fetchCurrentDog(completion: @escaping DogCompletion) {
        localDataSource.getDogData()
            .subscribe(onSuccess: { dog in
                completion(dog, true)
            }, onError: { error in
                completion(nil, false)
                print("Error fetching snapshots: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func walkDog(dog: Dog, completion: @escaping InfoCompletion) {
        
        let prepareOperation = localDataSource.getDogData()
        let firstOperation = localDataSource.addDogData(dog: dog).asObservable()
        let secondOperation = remoteDataSource.removeDog(removableDog: dog)
        
        //NOTE: How to do better?
        prepareOperation.do(
            onSuccess: { (currentDog) in
                if currentDog == nil {
                    firstOperation.concat(secondOperation)
                        .subscribe {
                            completion(true)
                        } onError: { error in
                            completion(false)
                        }
                        .disposed(by: self.disposeBag)
                } else {
                    completion(false)
                }
            }, onError: { (error) in
                completion(false)
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func bringWalkingDog(dog: Dog, completion: @escaping InfoCompletion) {
        let firstOperation = remoteDataSource.addDog(addedDog: dog)
        let secondOperation = localDataSource.removeDogData(dog: dog)

        firstOperation.concat(secondOperation)
            .subscribe {
                completion(true)
            } onError: { error in
                completion(false)
            }
            .disposed(by: disposeBag)
    }
}
