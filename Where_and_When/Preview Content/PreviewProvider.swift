//
//  PreviewProvider.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 18/07/2023.
//

import Foundation
import SwiftUI

extension PreviewProvider{
    static var previewPhoto : Photo{
        let photo = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "10 July 1956", location: ["lat": 55.862434, "lng": -4.265033])
        return photo
    }
}
