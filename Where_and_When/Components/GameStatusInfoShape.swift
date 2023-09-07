//
//  GameStatusInfoShape.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 27/07/2023.
//

import SwiftUI

struct RoundStatusShape: Shape{
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset: CGFloat = rect.width * 0.4
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
    }
    
    
}

struct ScoreStatusShape: Shape{
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset: CGFloat = rect.width * 0.4
            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX - horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
    }
    
    
}

struct GameStatusInfoShape: View {
    var body: some View {
        RoundStatusShape()
            .cornerRadius(20)
            .foregroundColor(.brown)
            .frame(height:100)
    }
}

struct GameStatusInfoShape_Previews: PreviewProvider {
    static var previews: some View {
        GameStatusInfoShape()
    }
}
