//
//  ResultView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 19/07/2023.
//

import SwiftUI
import Kingfisher
import MapKit

struct ResultView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var gameManager: GameManager
    @State private var showPhotoDescription: Bool = false
    @State private var isMapMaximized: Bool = false
    var isGameSummary: Bool
    var round: Int
    var photo: Photo
    var guessedLocation: MKPointAnnotation?
    var guessedYear: Int
    var correctLocation: MKPointAnnotation {
        return MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: photo.location["lat"]!, longitude: photo.location["lng"]!))
    }
    var distance: Int {
        Int(calculateDistance(correctLocation, (guessedLocation!)).rounded() / 1000)
    }
    var correctYear: Int {
        return Int((photo.dateTaken))!
    }
    var distanceScore: Int{
        return calculateDistanceScore(distance)
    }
    var yearScore: Int{
        calculateYearScore(guessedYear, correctYear)
    }
    
    var body: some View {
        ZStack{
            VStack{
                Text("Round \(round) summary")
                    .foregroundStyle(.black)
                    .font(.custom("AmericanTypewriter", size: 30))
                    .bold()
                
                KFImage(URL(string: photo.url))
                    .resizable()
                    .scaledToFit()
                    .frame(height: isMapMaximized ? 150 : 230)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: isMapMaximized ? 3 : 5)
                    )
                    .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: isMapMaximized)
                
                if !isMapMaximized {
                    Button {
                        withAnimation{
                            showPhotoDescription.toggle()
                        }
                    } label: {
                        HStack{
                            Text("See photo description")
                                .foregroundColor(Color(hex: "#E49B0F"))
                                .font(.custom("AmericanTypewriter",size:15))
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.orange)
                        }
                        .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    }
                    
                    SliderResult(guessedYear: guessedYear, correctYear: correctYear)
                }
                
                ZStack(alignment: .topLeading){
                    ResultMapView(guess: guessedLocation!, correctLocation: correctLocation)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(10)
                        .onTapGesture {
                            isMapMaximized = true
                            showPhotoDescription = false
                        }
                        .padding(.top, isMapMaximized ? 10 : 0)
                        
                    
                    if isMapMaximized{
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .offset(y: 10)
                            .onTapGesture {
                                
                                isMapMaximized = false
                                
                            }
                    }
                }.animation(.default, value: isMapMaximized)
                ZStack{
                    HStack{
                        VStack(spacing:5){
                            Text("Year").bold()
                                .foregroundStyle(.black)
                            ScoreBar(total: false, score: yearScore)
                            Text("\(abs(correctYear - guessedYear)) years off")
                                .foregroundStyle(.black)
                                .font(.system(size:12))
                        }
                        Spacer()
                    }
                    HStack{
                        VStack(spacing:5){
                            Text("Location").bold()
                                .foregroundStyle(.black)
                            
                            ScoreBar(total: false, score: distanceScore)
                            Text("\(distance) km away")
                                .foregroundStyle(.black)
                                .font(.system(size:12))
                        }
                    }
                    HStack{
                        Spacer()
                        VStack(spacing:5){
                            Text("Total").bold()
                                .foregroundStyle(.black)
                            
                            ScoreBar(total: true, score: yearScore + distanceScore)
                            Text("")
                        }
                    }
                }.padding(EdgeInsets(top: 15, leading: 0, bottom: 20, trailing: 0))
                
                if !isGameSummary{
                    if round == 5{
                        NavigationLink(destination: GameSummaryView()) {
                            Text("See summary")
                                .font(.custom("AmericanTypewriter", size: 20))
                        }
                        .buttonStyle(CustomButtonStyle(width: 180))
                        
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Text("NEXT")
                                .font(.custom("AmericanTypewriter", size: 20))
                        }
                        .buttonStyle(CustomButtonStyle(width: 180))
                        
                    }
                }
                
                Spacer()
            }
            .padding(.all, 15)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color(hex: "FFF9A6"))
            .blur(radius: showPhotoDescription ? 5 : 0)
            .onTapGesture {
                showPhotoDescription = false
            }
            if showPhotoDescription{
                PhotoDescriptionView(photo: photo)
            }
        }
        .onAppear{
            updateScore()
            
            let roundSummary = RoundSummary(distanceScore: distanceScore, yearScore: yearScore, guessedLocation: guessedLocation!, guessedYear: guessedYear)
            gameManager.results[round - 1] = roundSummary
        }
        .onDisappear{
            dismiss()
        }
        .navigationBarBackButtonHidden(!isGameSummary)
        
    }
    
    func calculateDistance(_ guess: MKPointAnnotation, _ correctLocation: MKPointAnnotation) -> CLLocationDistance {
        let location1 = CLLocation(latitude: guess.coordinate.latitude, longitude: guess.coordinate.longitude)
        let location2 = CLLocation(latitude: correctLocation.coordinate.latitude, longitude: correctLocation.coordinate.longitude)
        
        return location1.distance(from: location2)
    }
    
    func updateScore(){
        gameManager.score += distanceScore + yearScore
    }
    
    func calculateDistanceScore(_ distance: Int) -> Int{
        let score = 5000 * exp(Double(-distance) / 2000.0)
        return Int(score.rounded())
    }
    
    func calculateYearScore(_ guessedYear: Int, _ correctYear: Int) -> Int{
        return max(0, 5000 - abs(guessedYear - correctYear) * 200)
    }
    
}



struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(isGameSummary: false, round: 5, photo: previewPhotos[0], guessedLocation: previewMapState.guess!, guessedYear: 1950)
            .environmentObject(previewGameManager)
    }
}
