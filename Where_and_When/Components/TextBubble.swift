//
//  TextBubble.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 21/08/2023.
//

import SwiftUI

struct TextBubble<Content>: View where Content: View {
    let direction: TextBubbleShape.Direction
    let content: () -> Content
    init(direction: TextBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
            self.content = content
            self.direction = direction
    }
    
    var body: some View {
        
        content().clipShape(TextBubbleShape(direction: direction))
            .padding(.bottom, direction == .middle ? 20 : nil)
    }
}

struct TextBubbleShape: Shape {
    enum Direction {
        case left
        case right
        case middle
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        switch direction {
        case .left:
            return getLeftBubblePath(in: rect)
        case .right:
            return getRightBubblePath(in: rect)
        case .middle:
            return getMiddleBubblePath(in: rect)
        }
    }
    
    private func getLeftBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x: width - 20, y: height))
            p.addCurve(to: CGPoint(x: width, y: height - 20),
                       control1: CGPoint(x: width - 8, y: height),
                       control2: CGPoint(x: width, y: height - 8))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 21, y: 0))
            p.addCurve(to: CGPoint(x: 4, y: 20),
                       control1: CGPoint(x: 12, y: 0),
                       control2: CGPoint(x: 4, y: 8))
            p.addLine(to: CGPoint(x: 4, y: height - 11))
            p.addCurve(to: CGPoint(x: 0, y: height),
                       control1: CGPoint(x: 4, y: height - 1),
                       control2: CGPoint(x: 0, y: height))
            p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                       control1: CGPoint(x: 4.0, y: height + 0.5),
                       control2: CGPoint(x: 8, y: height - 1))
            p.addCurve(to: CGPoint(x: 25, y: height),
                       control1: CGPoint(x: 16, y: height),
                       control2: CGPoint(x: 20, y: height))
            
        }
        return path
    }
    
    private func getRightBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x:  20, y: height))
            p.addCurve(to: CGPoint(x: 0, y: height - 20),
                       control1: CGPoint(x: 8, y: height),
                       control2: CGPoint(x: 0, y: height - 8))
            p.addLine(to: CGPoint(x: 0, y: 20))
            p.addCurve(to: CGPoint(x: 20, y: 0),
                       control1: CGPoint(x: 0, y: 8),
                       control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 21, y: 0))
            p.addCurve(to: CGPoint(x: width - 4, y: 20),
                       control1: CGPoint(x: width - 12, y: 0),
                       control2: CGPoint(x: width - 4, y: 8))
            p.addLine(to: CGPoint(x: width - 4, y: height - 11))
            p.addCurve(to: CGPoint(x: width, y: height),
                       control1: CGPoint(x: width - 4, y: height - 1),
                       control2: CGPoint(x: width, y: height))
            p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                       control1: CGPoint(x: width - 4, y: height + 0.5),
                       control2: CGPoint(x: width - 8, y: height - 1))
            p.addCurve(to: CGPoint(x: width - 25, y: height),
                       control1: CGPoint(x: width - 16, y: height),
                       control2: CGPoint(x: width - 20, y: height))
            
        }
        return path
    }
    
    private func getMiddleBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: width - 20, y: height - 11))
            p.addCurve(to: CGPoint(x: width, y: height - 31),
                       control1: CGPoint(x: width - 8, y: height - 11),
                       control2: CGPoint(x: width, y: height - 19))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 21, y: 0))
            p.addCurve(to: CGPoint(x: 0, y: 20),
                       control1: CGPoint(x: 8, y: 0),
                       control2: CGPoint(x: 0, y: 8))
            p.addLine(to: CGPoint(x: 0, y: height - 31))
            //p.addLine(to: CGPoint(x: 20, y: height))
            p.addCurve(to: CGPoint(x: 20, y: height - 11),
                       control1: CGPoint(x: 0, y: height - 19),
                       control2: CGPoint(x: 8, y: height - 11))
            p.addLine(to: CGPoint(x: rect.midX - 5, y: height - 11))
            p.addCurve(to: CGPoint(x: rect.midX, y: height),
                       control1: CGPoint(x: rect.midX - 3, y: height - 10.5),
                       control2: CGPoint(x: rect.midX - 2, y: height))
            p.addCurve(to: CGPoint(x: rect.midX + 5, y: height - 11),
                       control1: CGPoint(x: rect.midX + 3, y: height),
                       control2: CGPoint(x: rect.midX + 2, y: height - 10.5))
          
        }
        return path
    }
}

struct Demo: View {
    var body: some View {
        ScrollView {
            VStack {
                TextBubble(direction: .left) {
                    Text("Hello!")
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
                TextBubble(direction: .right) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut semper quam. Phasellus non mauris sem. Donec sed fermentum eros. Donec pretium nec turpis a semper. ")
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
                TextBubble(direction: .middle) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut semper quam. Phasellus non mauris sem. Donec sed fermentum eros. Donec pretium nec turpis a semper. ")
                        .padding(.all, 20)
                        .padding(.bottom, 10)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
            }
        }
    }
}

struct TextBubble_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}
