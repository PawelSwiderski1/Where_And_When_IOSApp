//
//  HighLight.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 15/08/2023.
//

import Foundation
import SwiftUI

struct Highlight: Identifiable, Equatable{
    var id = UUID()
    var anchor: Anchor<CGRect>
    var titles: [String]
    var cornerRadius: CGFloat
    var style: RoundedCornerStyle = .continuous
    var scale: CGFloat = 1
    var addHeight: CGFloat
    var addWidth: CGFloat = 60
}
