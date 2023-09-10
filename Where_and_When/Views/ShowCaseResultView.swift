//
//  ShowCaseResultView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 22/08/2023.
//

import SwiftUI
import Kingfisher
import MapKit

struct ShowCaseResultView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var gameManager: GameManager
    var guessedLocation: MKPointAnnotation?
    @State private var showPhotoDescription: Bool = false
    @State private var isMapMaximized: Bool = false
    var isGameSummary: Bool
    var round: Int = 1
    var photo: Photo{
        let photo = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "1956", location: ["lat": 55.862434, "lng": -4.265033], caption: "This is caption", description: "This is description")
        return photo
    }
    var guessedYear: Int
    var correctLocation: MKPointAnnotation {
        return MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: photo.location["lat"]!, longitude: photo.location["lng"]! ))
    }
    var distance: Int {
        Int(calculateDistance(correctLocation, (guessedLocation!)).rounded() / 1000)
    }
    var correctYear: Int {
        return Int(photo.dateTaken)!
    }
    var distanceScore: Int{
        return calculateDistanceScore(distance)
    }
    var yearScore: Int{
        calculateYearScore(guessedYear, correctYear)
    }
    
    @State private var currentHighlight = 0
    @State private var currentTitle = 0
    @State private var showTitle = true
    @State private var showNextButton = true
    @State private var showHighlights = false
    
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
                    .allowsHitTesting(false)
                    
                    SliderResult(guessedYear: guessedYear, correctYear: correctYear)
                        .showCase(order: 0, titles: ["Green color indicates the correct year, and orange is your guess"], cornerRadius: 10, addHeight: 20)
                }
                
                ZStack(alignment: .topLeading){
                    ResultMapView(guess: guessedLocation!, correctLocation: correctLocation)
                        //.frame(maxWidth: .infinity, maxHeight: .infinity)
                        //.frame(height: isMapMaximized ? 200 : 150)
                        .cornerRadius(10)
                        .onTapGesture {
                            if currentTitle == 1{
                                isMapMaximized = true
                                currentHighlight -= 1
                                currentTitle += 1
                            }
                        }
                        .padding(.top, isMapMaximized ? 10 : 0)
                        .showCase(order: 1, titles: ["On the map you can see the correct location and your guess", "Tap anywhere on the map to enlarge it", "Click X to minimize the map"], cornerRadius: 10, addHeight: 20)
                        
                    
                    if isMapMaximized{
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .offset(y: 10)
                            .onTapGesture {
                                isMapMaximized = false
                                showTitle = false
                                currentHighlight += 1
                                showNextButton = true
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
                    .showCase(order: 2, titles: ["Based on a formula, you earn points for the year and location", "Tap anywhere on the map to enlarge it"], cornerRadius: 10, addHeight: 10)
                
                
                Button {
                    dismiss()
                } label: {
                    Text("NEXT")
                        .font(.custom("AmericanTypewriter", size: 20))
                }
                .buttonStyle(CustomButtonStyle(width: 180))
                .allowsHitTesting(false)
                
                
                
                
                Spacer()
            }
            .padding(.all, 15)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color(hex: "FFF9A6"))
            .blur(radius: showPhotoDescription ? 5 : 0)
//            .onTapGesture {
//                showPhotoDescription = false
//            }
            if showPhotoDescription{
                PhotoDescriptionView(photo: photo)
            }
        }
        .onAppear{
            updateScore()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                withAnimation{
                    showHighlights = true
                    currentHighlight = 0
                }
            }
            let roundSummary = RoundSummary(distanceScore: distanceScore, yearScore: yearScore,  guessedLocation: guessedLocation!, guessedYear: guessedYear)
            gameManager.results[round - 1] = roundSummary
        }
        .onDisappear{
            dismiss()
        }
        .navigationBarBackButtonHidden(!isGameSummary)
        .modifier(ShowCaseRootResultView(currentHighlight: $currentHighlight, currentTitle: $currentTitle, showTitle: $showTitle, showNextButton: $showNextButton, showHighlights: $showHighlights) {
        })
        
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



struct ShowCaseResultView_Previews: PreviewProvider {
    static var previews: some View {
       ShowCaseResultView(guessedLocation: previewMapState.guess!, isGameSummary: false, round: 1, guessedYear: 1950)
            .environmentObject(previewGameManager)
    }
}
