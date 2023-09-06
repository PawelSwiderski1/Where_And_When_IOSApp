//
//  SliderResult.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 26/07/2023.
//

import SwiftUI

struct SliderResult: View {
    
    var guessedYear: Int
    var correctYear: Int
    var doOverlap: Bool {
        abs(getOffset(guessedYear) - getOffset(correctYear)) < 13
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text(String(correctYear))
                .offset(x: getOffset(correctYear) - 18)
                .font(.custom("AmericanTypewriter", size: 18))
                .shadow(color: .black, radius: 0.3)
                .bold()
                .foregroundColor(.green)
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
                Capsule()
                    .fill(Color.gray.opacity(0.25))
                    .frame(height: 10)
                    .background(
                        Capsule().stroke(.black, lineWidth: 2)
                    )
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 20))
                    .fill(Color.yellow)
                    .frame(width: 7, height: 20)
                    .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 20)).stroke(Color.black,lineWidth: 5))
                    .offset(x: getOffset(guessedYear))
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 20))
                    .fill(Color.green.opacity(doOverlap ? 0.5 : 1))
                    .frame(width: 10, height: 30)
                    .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 20)).stroke(Color.black,lineWidth: 5))
                    .offset(x: getOffset(correctYear))
                
            }
            Text(String(guessedYear))
                .offset(x:getOffset(guessedYear) - 14)
                .font(.custom("AmericanTypewriter", size: 15))
                .foregroundColor(.yellow)
                .shadow(color: .black, radius: 0.3)
        }.padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
    }
    
    func getOffset(_ year: Int) -> Double{
        let max = UIScreen.main.bounds.width - 120
        let min = Double(year - 1880)
        return min * max / 140 - 7.5
    }
}

struct SliderResult_Previews: PreviewProvider {
    static var previews: some View {
        SliderResult(guessedYear: 1984, correctYear: 1991)
    }
}
