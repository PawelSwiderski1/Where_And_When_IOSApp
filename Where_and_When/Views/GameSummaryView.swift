//
//  GameSummaryView.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 05/08/2023.
//

import SwiftUI
import MapKit

struct GameSummaryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapState: MapState
    @EnvironmentObject var gameManager: GameManager
    @State var isMapMaximized = false
    
    var guesses: [MKPointAnnotation]{
    
        var guesses: [MKPointAnnotation] = []
        for index in (0...4){
            print(gameManager.results[index]!.guessedLocation.coordinate)
            guesses.append( gameManager.results[index]!.guessedLocation)
        }
        return guesses
    }
    var correctLocations: [MKPointAnnotation]{
        var correctLocations: [MKPointAnnotation] = []
        for index in (0...4){
            let correctLocation = MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: gameManager.photos[index]!.location["lat"] ?? 51, longitude: gameManager.photos[index]!.location["lng"] ?? -60))
        
            correctLocations.append(correctLocation)
        }
        return correctLocations
    }
    
    var body: some View {
        VStack{
            Text("Game Summary")
                .foregroundStyle(.black)
                .font(.custom("AmericanTypewriter", size: 30))
                .bold()
                .padding(.bottom, 10)
            
            Spacer()
            
            if !isMapMaximized{
                
                HStack{
                    Text("")
                    Spacer()
                    HStack{
                        Text("Year")
                            .padding(.trailing, 7)
                            .foregroundStyle(.black)
                            .font(.custom("AmericanTypewriter", size: 17))
                        Text("Location")
                            .padding(.trailing, 5)
                            .foregroundStyle(.black)
                            .font(.custom("AmericanTypewriter", size: 17))
                        Text("Total")
                            .foregroundStyle(.black)
                            .font(.custom("AmericanTypewriter", size: 19))
                            .bold()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 31))

                ForEach(1..<6){ round in
                    if gameManager.photos[1] != nil{
                        NavigationLink(destination: ResultView(guessedLocation: gameManager.results[round - 1]!.guessedLocation, isGameSummary: true, round: round, photo: gameManager.photos[round-1]!, guessedYear: gameManager.results[round-1]!.guessedYear))
                        {
                            
                            RoundSummaryRow(round: round, results: gameManager.results[round-1]!)
                                .padding(.bottom, round == 5 ? 10 : 0)
                        }
                    }
                }
            }
                    
                
            
         
            ZStack(alignment: .topLeading){
                GameSummaryMapView(guesses: guesses, correctLocations: correctLocations)
                    .cornerRadius(20)
                    .onTapGesture {
                        isMapMaximized = true
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(10)
                    .onTapGesture {
                        
                            isMapMaximized = true
                        
                    }
                    .padding(.top, isMapMaximized ? 10 : 0)
                
                if isMapMaximized{
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .offset(y: 10)
                        .onTapGesture {
                            
                                isMapMaximized = false
                            
                        }
                }
            }
            .animation(.default, value: isMapMaximized)
            .padding(.top, 0)
            .padding(.bottom, 10)

            
            Spacer()
            
            Text("You scored")
                .foregroundStyle(.black)
                .font(.custom("AmericanTypewriter", size: 30))
                .bold()
                
            Text(String(gameManager.score))
                .foregroundStyle(.black)
                .font(.custom("AmericanTypewriter", size: 30))
                .bold()
            Text("High score: \(UserDefaults.standard.integer(forKey: "HighScore"))")
                .foregroundStyle(.black)
                .font(.custom("AmericanTypewriter", size: 15))
            
            
            HStack{
                Spacer()
                Button{
                    router.clear()
                } label: {
                    Text("Home")
                        .foregroundStyle(.black)
                        .font(.custom("AmericanTypewriter", size: 22))
                }
                .buttonStyle(CustomButtonStyle(width: 130))
            
                Spacer()
                
                Button{
                    gameManager.playAgain = true
                    router.gotoContentView()
                } label: {
                    Text("Start again")
                        .foregroundStyle(.black)
                        .font(.custom("AmericanTypewriter", size: 22))
                }
                .buttonStyle(CustomButtonStyle(width: 130))
                
                Spacer()

            }
        }
        .onAppear{
            if gameManager.score > UserDefaults.standard.integer(forKey: "HighScore") {
                
                UserDefaults.standard.set(gameManager.score, forKey: "HighScore")
            }
        }
        .padding()
        .background(Color(hex: "FFF9A6"))
        .navigationBarBackButtonHidden(true)
    }
}

struct GameSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            GameSummaryView()
                .environmentObject(previewMapState)
                .environmentObject(previewGameManager)
        }
    }
}
