//
//  ContentView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 10/07/2023.
//

import SwiftUI
import CoreData
import MapKit
import Kingfisher


struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapState: MapState
    var photo: Photo?{
        if gameManager.round != 0{
            return gameManager.photos[gameManager.round - 1]
        }
        return nil
    }
    @State private var downloaded = false
    @State private var distance: Int = 500
    @State private var isMapClicked: Bool = false
    @State private var guessedYear = 1953.0
    @State var offset = 100.0
    @State var showPhotoView = false
    @State var didGuess: Bool = false
    
    var body: some View {
            ZStack{
                if downloaded{
                    VStack(spacing: 11){
                        ZStack(alignment: .top){
                            HStack{
                                VStack{
                                    Text("Round")
                                        .foregroundStyle(.black)
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                        .font(.custom("AmericanTypewriter", size: 20))
                                    
                                    Text("\(gameManager.round) / 5")
                                        .foregroundStyle(Color(hex:"#000000"))
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
                                        .foregroundStyle(.black)
                                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                                        .font(.custom("AmericanTypewriter", size: 20))
                                    Text("\(gameManager.score)")
                                        .foregroundStyle(.black)
                                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                                        .font(.custom("AmericanTypewriter", size: 20))
                                }.background(
                                    ScoreStatusShape()
                                        .cornerRadius(10)
                                        .foregroundColor(Color(hex:"#ffcda6"))
                                        .frame(width: 100))
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            
                            ZStack(alignment: .topTrailing){
                                KFImage(URL(string: photo?.url ?? "url"))
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture {
                                        if showPhotoView{
                                            withAnimation{
                                                showPhotoView = false
                                            }
                                        } else {
                                            if !isMapClicked{
                                                showPhotoView = true
                                            }
                                            withAnimation{
                                                isMapClicked = false
                                            }
                                        }
                                        
                                    }
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: isMapClicked ? 2 : downloaded ? 4 : 0)
                                    )
                                    .frame(maxWidth: isMapClicked ? UIScreen.main.bounds.width - 220 : nil, maxHeight: downloaded ? UIScreen.main.bounds.height/3 : nil)
                                
                            }
                            .offset(y: isMapClicked ? 0 : 80)
                        }
                        
                        
                        Spacer()
                        
                        if photo != nil{
                            ZStack(alignment: .top){
                                MapView(didGuess: $didGuess, mapState: mapState)
                                    .frame(height: isMapClicked ? UIScreen.main.bounds.height/2 : UIScreen.main.bounds.height/4)
                                    .cornerRadius(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 3)
                                    )
                                
                                Image(systemName: "arrow.up.and.down.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.black, Color(hex: "#ffcda6"))
                                    .offset(y: -13)
                                    .frame(width: 25)
                                    .onTapGesture {
                                        withAnimation{
                                            isMapClicked.toggle()
                                        }
                                    }
                            }
                        }
                        
                        Slider(offset: $offset)
                            .padding(EdgeInsets(top: 17, leading: 40, bottom: 0, trailing: 40))
                        
                        Text("\(String(getSliderYear(offset)))")
                            .foregroundStyle(.black)
                            .font(.custom("AmericanTypewriter", size: 30))
                        if photo != nil{
                            NavigationLink(destination: ResultView(guessedLocation: mapState.guess, isGameSummary: false, round: gameManager.round, photo: photo!, guessedYear: getSliderYear(offset))
                            ){
                                Text(didGuess ? "GUESS" : "Place marker on the map")
                                    .font(.custom("AmericanTypewriter", size: 20))
                                
                            }
                            .isDetailLink(false)
                            .buttonStyle(CustomButtonStyle(width: didGuess ? 180: 250))
                            .opacity(didGuess ? 1 : 0.5)
                            .disabled(!didGuess)
                        }
                        
                    }
                    .background(Color(hex: "#FFF9A6"))
                    .blur(radius: showPhotoView ? 5 : 0)
                    .onTapGesture {
                        withAnimation{
                            showPhotoView = false
                        }
                    }
                    if showPhotoView{
                        PhotoView(photo: photo!)
                        
                    }
                } else {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .background(Color(hex: "#FFF9A6"))
                }
            }
            .onAppear{
                if gameManager.playAgain{
                    router.path.removeLast()
                    gameManager.playAgain = false
                }
                
                if gameManager.round == 5{
                    gameManager.reset()
                }
                
                didGuess = false
                offset = (UIScreen.main.bounds.width - 90)/2
                
                mapState.reset()
                if gameManager.round == 0{
                    Task{ await preloadImages()}
                }
                updateRound()
                
                
            }
            .onDisappear{
                print("disap")
                isMapClicked = false
            }
            
            
            .navigationBarBackButtonHidden(true)
            
    }
    
    func updateRound(){
        gameManager.round += 1
    }
    
    private func preloadImages() async {
        // Preload images in the background using the ImageLoadingService
        for index in (0...4) {
            print(index)
            if gameManager.photos[index] == nil {
                var photo: Photo?
                do {
                    photo = try await fetchPhotos()
                    gameManager.photos[index] = photo
                } catch let error as NSError {
                    print("Error: \(error)")
                }
                
                // Load image and update the aspect ratio
                if let photo = photo, let imageUrl = URL(string: photo.url) {
                    ImageLoadingService.shared.loadImage(url: imageUrl) { aspectRatio in
                        if let updatedPhoto = gameManager.photos[index] {
                            var photoWithAspectRatio = updatedPhoto
                            photoWithAspectRatio.aspectRatio = aspectRatio
                            gameManager.photos[index] = photoWithAspectRatio
                            downloaded = true
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getSliderYear(_ offset: Double) -> Int{
        let max = UIScreen.main.bounds.width - 90
        let min = offset + 7.5
        let year = (1880 + 140 * min / max).rounded()
        return Int(year)
    }
    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
        }.environmentObject(previewGameManager)
            .environmentObject(previewMapState)
        
        
    }
}



