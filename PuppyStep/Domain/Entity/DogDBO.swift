//
//  DogRealm.swift
//  PuppyStep
//
//  Created by Sergey on 11/2/20.
//

import Foundation
import RealmSwift

class DogDBO: Object {
    @objc dynamic var name = ""
    @objc dynamic var breed = ""
    @objc dynamic var age = 0
    @objc dynamic var photoUrl = ""
    @objc dynamic var gender = ""
    @objc dynamic var dogDescription = ""
    @objc dynamic var home = ""
}
