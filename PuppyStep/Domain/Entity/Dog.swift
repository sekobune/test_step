//
//  Dog.swift
//  PuppyStep
//
//  Created by Sergey on 10/20/20.
//

import Foundation
import RealmSwift

class Dog: NSObject {

    let name: String?
    let breed: String?
    let age: Int?
    let photoUrl: String?
    let gender: DogGender?
    let dogDescription: String?
    let home: String?
    
    init(
        name: String?,
        breed: String?,
        age: Int?,
        photoUrl: String?,
        gender: DogGender?,
        dogDescription: String?,
        home: String?
    ) {
        self.name = name
        self.breed = breed
        self.age = age
        self.photoUrl = photoUrl
        self.gender = gender
        self.dogDescription = dogDescription
        self.home = home
        
        super.init()
    }
}

enum DogGender: String, Decodable {
    case male
    case female
    case unknown
}
