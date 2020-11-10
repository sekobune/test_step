//
//  FetchCurrentDogUseCase.swift
//  PuppyStep
//
//  Created by Sergey on 11/10/20.
//

import Foundation

protocol FetchCurrentDogUseCase: UseCase {
    associatedtype Result: Any
    typealias Completion = DogCompletion
    
    func execute(completion: @escaping Completion)
}

class FetchCurrentDogUseCaseImpl: FetchCurrentDogUseCase {

    typealias Result = Dog
    
    var repository: DogsRepository
    
    init(dogsRepository: DogsRepository) {
        self.repository = dogsRepository
    }
    
    func execute(completion: @escaping Completion) {
        repository.fetchCurrentDog(completion: completion)
    }
}
