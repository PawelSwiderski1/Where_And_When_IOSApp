//
//  Slider.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 26/07/2023.
//

import SwiftUI
//import AVFoundation

struct Slider: View {
    @Binding var offset: Double
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
            Capsule()
                .fill(Color.gray.opacity(0.25))
                .background(
                    Capsule().stroke(.black, lineWidth: 2)
                )
                .frame(height: 20)
                
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 20))
                .fill(Color.yellow)
                .frame(width: 15, height: 30)
                .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 20)).stroke(Color.black, lineWidth: 5))
                .offset(x: offset)
                .gesture(DragGesture().onChanged({(value) in
                    if value.location.x > -7.5 && value.location.x <= UIScreen.main.bounds.width - 90 {
                        offset = value.location.x
                    }
                }))
            
        }
    }
    
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        Slider(offset: .constant(300))
    }
}
