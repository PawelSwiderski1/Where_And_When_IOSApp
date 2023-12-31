//
//  ApiHandler.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 10/07/2023.
//

import Foundation
import UIKit
import Kingfisher


func fetchPhotos() async throws -> Photo{
    let baseUrl = "http://www.historypin.org/en/api/pin/get.json?id="
    let id = Int.random(in: 0...300000)
    let url = URL(string: baseUrl + String(id))!
    let (data,_) = try await URLSession.shared.data(from: url)

    
    do {
        if let jsonArray = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any>
        {
            if let display = jsonArray["display"] as? Dictionary<String, String>,
               let locationWhole = jsonArray["location"] as? Dictionary<String, Any>,
               let dateTaken = jsonArray["date_taken"] as? String,
               let caption = jsonArray["description"] as? String, caption != "",
               let description = jsonArray["caption"] as? String,
               let license = jsonArray["license"] as? String{
                
                
                let dateTakenRange = NSRange(
                    dateTaken.startIndex..<dateTaken.endIndex,
                    in: dateTaken
                )

                let capturePattern = #"^(?!.*\d{4}.*\d{4}).*(\d{4}).*$"#
                let captureRegex = try! NSRegularExpression(
                    pattern: capturePattern,
                    options: []
                )

                let matches = captureRegex.matches(
                    in: dateTaken,
                    options: [],
                    range: dateTakenRange
                )

                guard let match = matches.first else {
                    return try await fetchPhotos()
                }
                let matchRange = match.range(at: 1)
                let substringRange = Range(matchRange, in: dateTaken)
                let year = String(dateTaken[substringRange!])
                
                if Int(year) ?? 1890 < 1880 {
                    return try await fetchPhotos()
                    
                } else {
            
                    let keys : Set = ["lat", "lng"]
                    let subsetDict = locationWhole.filter({ keys.contains($0.key)})
                    let location = subsetDict as! [String:Double]
                    
                    let url = display["content"]!
                    
                    let formattedCaption = caption.replacingOccurrences(of: "<br />", with: "\n")
                    let formattedDescription = description.replacingOccurrences(of: "<br />", with: "\n")
                    
                    let photo = Photo(url: url, dateTaken: year, location: location, caption: formattedCaption, description: formattedDescription, license: license)
                    
                    
                    return photo
                }
                
            } else {
                return try await fetchPhotos()
            }
        } else {
            return try await fetchPhotos()
        }
    } catch let error as NSError {
        print("Error: \(error)")
    }
           
    return try await fetchPhotos()
    
}



class ImageLoadingService {
    static let shared = ImageLoadingService()

    private init() {}

    func loadImage(url: URL, completion: @escaping (CGFloat) -> Void) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                let aspectRatio = value.image.size.height / value.image.size.width
                completion(aspectRatio)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
