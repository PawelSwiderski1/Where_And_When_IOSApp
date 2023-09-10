//
//  ScoreBar.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 25/07/2023.
//

import SwiftUI

struct ScoreBar: View {
    var total: Bool
    var score: Int
    var innerWidth: CGFloat{
        if total {
            return CGFloat(score) * 80 / 10000
        } else {
            return CGFloat(score) * 80 / 5000
        }
    }
    @State private var animate: Bool = false
    
    var body: some View {
        VStack(spacing: 2){
            ZStack(alignment: .bottom){
                ZStack(alignment: .top){
                    Text(String(score))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                        .font(.system(size: 18))
                }
                Text(total ? "10000" : "5000")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size: 8))
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 7.5)
                    .frame(width: 80, height: 15)
                    .foregroundColor(Color (hue: 1.0, saturation: 0.9, brightness: 0.564, opacity: 0.327))
//                    .background(
//                        RoundedRectangle(cornerRadius: 7.5).stroke(.black, lineWidth: 1)
//                    )
                    
                if innerWidth > 7.5 {
                    RoundedRectangle(cornerRadius: 7.5)
                        .frame(width: animate ? innerWidth : 0, height: 15)
                        .foregroundColor(.black)
                        .animation(.linear (duration: 1.7), value: animate)
                        .clipShape(RoundedRectangle(cornerRadius: 7.5, style: .continuous))
                        .onAppear {
                            DispatchQueue.main.async {
                                animate = true

                            }
                        }
                }  else {
                    Circle()
                        .trim(from: 0, to: innerWidth / 15)
                        .rotationEffect(.degrees((Double(2) - (innerWidth / 7.5)) * 90))
                        .frame(width: 15)
                }
                
            }
        }.frame(width: 120)
    }
}

struct ScoreBar_Previews: PreviewProvider {
    static var previews: some View {
        ScoreBar(total: true, score: 500)
    }
}
