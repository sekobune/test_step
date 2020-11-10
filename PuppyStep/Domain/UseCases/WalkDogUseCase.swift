//
//  WalkDogUseCase.swift
//  PuppyStep
//
//  Created by Sergey on 11/10/20.
//

import Foundation

protocol WalkDogUseCase: UseCase {
    associatedtype Result: Any
    associatedtype Params: RequestValues
    typealias Completion = InfoCompletion
    
    func execute(_ requestValues: Params, completion: @escaping Completion)
}

class WalkDogUseCaseImpl: WalkDogUseCase {

    typealias Result = Bool
    typealias Params = DogRequestValue

    var repository: DogsRepository
    
    init(dogsRepository: DogsRepository) {
        self.repository = dogsRepository
    }
    
    func execute(_ requestValues: Params, completion: @escaping Completion) {
        repository.walkDog(dog: requestValues.data, completion: completion)
    }
}
