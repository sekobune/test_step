//
//  DogHolder.swift
//  PuppyStep
//
//  Created by Sergey on 10/10/20.
//

import Foundation
import MapKit

class DogHolder: NSObject, MKAnnotation {
    let title: String?
    let address: String?
    let holderDescription: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        address: String?,
        holderDescription: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.address = address
        self.holderDescription = holderDescription
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
}

