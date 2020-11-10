//
//  FirestoreUtils.swift
//  PuppyStep
//
//  Created by Sergey on 10/29/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import MapKit
import RxSwift
import RxCocoa

protocol RemoteDataSource {
    func getAllDogHolders() -> Observable<[DogHolder]>
    func getAllDogsByHolderName(dogHolderName: String) -> Observable<[Dog]>
    func removeDog(removableDog: Dog) -> Observable<Void>
    func addDog(addedDog: Dog) -> Observable<Void>
}

class RemoteFirestoreDataSource: RemoteDataSource {
    
    private let db = Firestore.firestore()
    
    func getAllDogHolders() -> Observable<[DogHolder]> {
        return db.collection("DogHolders")
            .rx
            .getDocuments()
            .map({ (querySnapshot) -> [DogHolder] in
                return querySnapshot.documents.map({(document) -> DogHolder in
                    let data = document.data()
                    let coordinate = data["coordinate"] as! GeoPoint
                    return DogHolder(
                        title: data["title"] as? String,
                        address: data["address"] as? String,
                        holderDescription: data["description"] as? String,
                        coordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
                })
            })
    }
    
    func getAllDogsByHolderName(dogHolderName: String) -> Observable<[Dog]> {
        db.collection("Dogs").whereField("home", isEqualTo: dogHolderName)
            .rx
            .getDocuments()
            .map({ (querySnapshot) -> [Dog] in
                return querySnapshot.documents.map({(document) -> Dog in
                    let data = document.data()
                    return Dog(
                        name: data["name"] as? String,
                        breed: data["breed"] as? String,
                        age: data["age"] as? Int,
                        photoUrl: data["photoUrl"] as? String,
                        //replace
                        gender: DogGender.init(rawValue: data["gender"] as! String) ?? DogGender.unknown,
                        dogDescription: data["description"] as? String,
                        home: data["home"] as? String
                    )
                })
            })
    }
    
    func removeDog(removableDog: Dog) -> Observable<Void> {
        return db.collection("Dogs").whereField("name", isEqualTo: removableDog.name!)
            .rx
            .getDocuments()
            .flatMap { [weak self] selectedDogs -> Observable<Void> in
                guard let self = self,
                      let id = selectedDogs.documents.first?.documentID
                else { return .empty() }
                return self.db.collection("Dogs").document(id).rx.delete()
            }
    }
    
    func addDog(addedDog: Dog) -> Observable<Void> {
        
        return db.collection("Dogs").document()
            .rx
            .setData(
                [
                    "name" : addedDog.name!,
                    "breed": addedDog.breed!,
                    "age": addedDog.age!,
                    "photoUrl": addedDog.photoUrl!,
                    "gender": addedDog.gender!.rawValue,
                    "description": addedDog.dogDescription!,
                    "home": addedDog.home!
                ]
            )
    }
}
