//
//  DogsDataRepository.swift
//  PuppyStep
//
//  Created by Sergey on 11/9/20.
//

import Foundation

protocol UseCase {
    var repository: DogsRepository { get set }
}

protocol RequestValues {
    associatedtype DataType: Any
    var data: DataType { get set }
}

class DogRequestValue: RequestValues {
    
    typealias DataType = Dog
    
    var data: DataType
    public init(data: DataType) {
        self.data = data
    }
}

class DogHolderRequestValue: RequestValues {
    
    typealias DataType = String
    
    var data: DataType
    public init(data: DataType) {
        self.data = data
    }
}

class CityRequestValue: RequestValues {
    
    typealias DataType = String
    
    var data: DataType
    public init(data: DataType) {
        self.data = data
    }
}
