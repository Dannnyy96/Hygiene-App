//
//  Restaurant.swift
//  Assignment
//
//  Created by Daniel Mcnamara on 16/02/2018.
//  Copyright © 2018 Daniel Mcnamara. All rights reserved.
//

import Foundation

class Restaurant: Codable{
    
    let id: String?
    let BusinessName: String
    let RatingValue: String
    let AddressLine1: String
    let AddressLine2: String
    let AddressLine3: String
    let PostCode: String
    let Latitude: String
    let Longitude: String
    let RatingDate: String
    let DistanceKM: String?
}
