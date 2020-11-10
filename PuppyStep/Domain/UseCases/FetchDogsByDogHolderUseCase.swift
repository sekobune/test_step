//
//  FetchDogsByDogHolderUseCase.swift
//  PuppyStep
//
//  Created by Sergey on 11/10/20.
//

import Foundation

protocol FetchDogsByDogHolderUseCase: UseCase {
    associatedtype Result: Any
    associatedtype Params: RequestValues
    typealias Completion = DogsCompletion
    
    func execute(_ requestValues: Params, completion: @escaping Completion)
}

class FetchDogsByDogHolderUseCaseImpl: FetchDogsByDogHolderUseCase {
    
    typealias Result = [Dog]
    typealias Params = DogHolderRequestValue
    
    var repository: DogsRepository

    init(dogsRepository: DogsRepository) {
        self.repository = dogsRepository
    }
    
    func execute(_ requestValues: Params, completion: @escaping Completion) {
        repository.fetchDogs(dogHolderName: requestValues.data, completion: completion)
    }
}
