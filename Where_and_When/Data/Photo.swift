//
//  Photo.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 10/07/2023.
//

import Foundation

struct Photo: Decodable{
    let url: String
    let dateTaken: String
    let location: Dictionary<String, Double>
    let caption: String
    let description: String
    var license: String = "No Known Copyright."
    var aspectRatio: Double = 1.0
    
}
