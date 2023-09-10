//
//  RoundSummaryRow.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 08/08/2023.
//

import SwiftUI

struct RoundSummaryRow: View {
    var round: Int
    var results: RoundSummary
    
    var body: some View {
        HStack{
           Text("Round \(String(round))")
                .foregroundStyle(.black)
                .font(.custom("AmericanTypewriter", size: 20))
                .bold()
            Spacer()
            HStack{
                //Text(String(results.yearScore))
                VStack(alignment: .center){
                    Text(String(results.yearScore))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .font(.custom("AmericanTypewriter", size: 17))
                }
                .frame(width: 50)
                .padding(.trailing, 10)
                VStack(alignment: .center){
                    Text(String(results.distanceScore))
                        .foregroundStyle(.black)
                        .font(.custom("AmericanTypewriter", size: 17))
                }
                .frame(width: 50)
                .padding(.trailing, 15)
                VStack(alignment: .center){
                    Text(String(results.totalScore))
                        .foregroundStyle(.black)
                        .font(.custom("AmericanTypewriter", size: 17))
                        .bold()
                }
                .frame(width: 50)
            }
        }
        .padding()

        .background(
            RoundedRectangle(cornerRadius: 10)
                //.frame(width: 300, height: 50)
                .foregroundStyle(.yellow)
                .opacity(0.6)
            )
        .frame(width: .infinity, height: 50)
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))

    }
}

struct RoundSummaryRow_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RoundSummaryRow(round: 1, results: previewGameManager.results[0]!)
    }
}
