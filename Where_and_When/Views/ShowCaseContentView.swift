//
//  ShowCaseContentView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 18/08/2023.
//

import SwiftUI
import CoreData
import MapKit
import Kingfisher


struct ShowCaseContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapState: MapState
    var photo: Photo{
        let photo = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "10 July 1956", location: ["lat": 55.862434, "lng": -4.265033], caption: "This is caption", description: "This is description")
        return photo
    }
    @State private var distance: Int = 500
    @State private var isMapClicked: Bool = false
    @State private var guessedYear = 50.0
    @State var offset = 0.0
    @State var showPhotoView = false
    @State var didGuess: Bool = false
    @State private var enablePhotoClick = false
    @State private var enablePhotoViewQuit = false
    @State private var currentHighlight = 0
    @State private var currentTitle = 0
    @State private var showTitle = true
    @State private var showNextButton = true

    
    
    var body: some View {
        ZStack{
            VStack(spacing: 11){
                ZStack(alignment: .top){
                    HStack{
                        VStack{
                            Text("Round")
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                .font(.custom("AmericanTypewriter", size: 20))
                            
                            Text("\(gameManager.round) / 5")
                                .foregroundStyle(.white)
                                .font(.custom("AmericanTypewriter", size: 20))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                        }.background(
                            RoundStatusShape()
                                .cornerRadius(10)
                                .foregroundColor(Color(hex:"#ffcda6"))
                                .frame(width: 100)
                        )
                        Spacer()
                        VStack{
                            Text("Score")
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                .font(.custom("AmericanTypewriter", size: 20))
                            Text("\(gameManager.score)")
                                .foregroundStyle(.white)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                                .font(.custom("AmericanTypewriter", size: 20))
                        }.background(
                            ScoreStatusShape()
                                .cornerRadius(10)
                                .foregroundColor(Color(hex:"#ffcda6"))
                                .frame(width: 100))
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    ZStack(alignment: .topTrailing){
                        KFImage(URL(string: photo.url ))
                            .placeholder{
                                ProgressView()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            }
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                if showPhotoView{
                                    withAnimation{
                                        currentHighlight += 1
                                        currentTitle = 0
                                        showPhotoView = false
                                        enablePhotoClick = false
                                        enablePhotoViewQuit = false
                                    }
                                } else {
                                    if !isMapClicked{
                                        currentHighlight += 1
                                        currentTitle = 0
                                        enablePhotoClick = false
                                        showPhotoView = true
                                        showNextButton = true
                                    }
                                    withAnimation{
                                        isMapClicked = false
                                    }
                                }
                            }
                            .allowsHitTesting(enablePhotoClick)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: isMapClicked ? 2 : 3)
                            )
                            .frame(maxWidth: isMapClicked ? UIScreen.main.bounds.width - 220 : nil, maxHeight: UIScreen.main.bounds.height/3)
                            .showCase(order: 0, titles: ["Your goal is to guess where and when the photo was taken", "Click on the photo to have a better look"], cornerRadius: 10, style: .continuous, addHeight: 20)
                    }
                    .offset(y: isMapClicked ? 0 : 80)
                }
                
                
                Spacer()
                
                
                ZStack(alignment: .top){
                    
                    
                    MapView(didGuess: $didGuess, mapState: mapState)
                        .frame(height: isMapClicked ? UIScreen.main.bounds.height/2 : UIScreen.main.bounds.height/4)
                        .cornerRadius(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 3)
                        )
                        .onTapGesture {
            
                            if currentTitle == 0{
                                currentTitle = 1
                            }
                            
                        }
                        .allowsHitTesting(currentHighlight == 2)
                        .showCase(order: 2, titles: ["Place a marker on the map to guess the location", "You can click this button to enlarge the map", "Click again to minimize the map"], cornerRadius: 10, style: .continuous, addHeight: 30)
                    
                    Image(systemName: "arrow.up.and.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, Color(hex: "#ffcda6"))
                        .offset(y: -13)
                        .frame(width: 25)
                        .onTapGesture {
                            withAnimation{
                                if currentTitle != 0{
                                    isMapClicked.toggle()
                                    if currentTitle == 1{
                                        currentTitle = 2
                                    } else if currentTitle == 2{
                                        showTitle = false
                                        showNextButton = true
                                    }
                                }
                                
                            }
                        }
                        .allowsHitTesting(currentHighlight == 2)
                }
                
                
                Slider(offset: $offset)
                    .padding(EdgeInsets(top: 17, leading: 40, bottom: 0, trailing: 40))
                    .showCase(order: 3, titles: ["Use the silder to guess the year", "When you're ready, click guess to see how you did"], cornerRadius: 10, style: .continuous, addHeight: 140)
                    .allowsHitTesting(currentHighlight == 3)
                
                Text("\(String(getSliderYear(offset)))")
                    .foregroundStyle(.black)
                    .font(.custom("AmericanTypewriter", size: 30))
                    
                
                NavigationLink(destination: ShowCaseResultView(guessedLocation: mapState.guess, isGameSummary: false, round: gameManager.round, guessedYear: getSliderYear(offset))
                ){
                    Text(didGuess ? "GUESS" : "Place marker on the map")
                        .font(.custom("AmericanTypewriter", size: 20))
                    
                }
                .isDetailLink(false)
                .buttonStyle(CustomButtonStyle(width: didGuess ? 180: 250))
                .opacity(didGuess ? 1 : 0.5)
                .disabled(!(currentHighlight == 3 && currentTitle == 1))
                
                
            }
            .background(Color(hex: "FFF9A6"))
            .blur(radius: showPhotoView ? 5 : 0)
            .onTapGesture {
                if showPhotoView && enablePhotoViewQuit{
                    withAnimation{
                        showPhotoView = false
                        currentHighlight += 1
                        currentTitle = 0
                        enablePhotoClick = false
                        enablePhotoViewQuit = false
                    }
                }
            }
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: 1, height: 1)
                .showCase(order: 1, titles: [""], cornerRadius: 10, style: .continuous, addHeight: 0)
            
            if showPhotoView{
                PhotoView(photo: photo)
            }
            
           
        }
        .onAppear{
            didGuess = false
            offset = 0.0
            
            mapState.reset()
            
            gameManager.round += 1
            
            
        }
        .onDisappear{
            isMapClicked = false
        }
        .modifier(ShowCaseRootContentView(enablePhotoClick: $enablePhotoClick, enablePhotoViewQuit: $enablePhotoViewQuit, currentHighlight: $currentHighlight, currentTitle: $currentTitle, showTitle: $showTitle, showNextButton: $showNextButton) {
        }
        )
        
        .navigationBarBackButtonHidden(true)
        
    }
    
    
    
    
    
    
    func getSliderYear(_ offset: Double) -> Int{
        let max = UIScreen.main.bounds.width - 90
        let min = offset + 7.5
        let year = (1880 + 140 * min / max).rounded()
        return Int(year)
    }
    
}




struct ShowCaseContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ShowCaseContentView()
        }.environmentObject(previewGameManager)
            .environmentObject(previewMapState)
        
        
    }
}
