//
//  FetchDogHoldersUseCase.swift
//  PuppyStep
//
//  Created by Sergey on 11/10/20.
//

import Foundation

protocol FetchDogHoldersUseCase: UseCase {
    associatedtype Result: Any
    typealias Completion = DogHoldersCompletion
    
    func execute(completion: @escaping Completion)
}

class FetchDogHoldersUseCaseImpl: FetchDogHoldersUseCase {
        
    typealias Result = [DogHolder]
    
    var repository: DogsRepository
    
    init(dogsRepository: DogsRepository) {
        self.repository = dogsRepository
    }
    
    func execute(completion: @escaping Completion) {
        repository.fetchDogHolders(completion: completion)
    }
}
