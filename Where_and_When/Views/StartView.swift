//
//  StartView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 22/07/2023.
//

import SwiftUI
import NavigationTransitions

struct StartView: View {
    @EnvironmentObject var router: Router
    @StateObject private var gameManager = GameManager()
    @StateObject private var mapState = MapState()
    
    var body: some View {
        NavigationStack(path: $router.path){
            VStack(spacing: 80){
                Image("Logo")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.top, 50)
                                
                VStack(spacing:140){
                    Button {
                        gameManager.reset()
                        router.gotoContentView()
                    } label: {
                        Text("START")
                            .foregroundStyle(.black)
                            .font(.custom("AmericanTypewriter", size: 27))
                        
                    }.buttonStyle(CustomButtonStyle(width: 230))
                    
                    Button {
                        gameManager.reset()
                        router.gotoShowCaseContentView()
                    } label: {
                        Text("How to play?")
                            .foregroundStyle(.black)
                            .font(.custom("AmericanTypewriter", size: 20))
                        
                    }.buttonStyle(CustomButtonStyle(width: 150))
                }
                
                Spacer()
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "#FFF9A6"))
            .ignoresSafeArea()
            .navigationDestination(for: Views.self){ destination in
                ViewFactory.viewForDestination(destination)
                
            }
        }
        .navigationTransition(.fade(.in).animation(.easeInOut(duration: 0.2)))
        .environmentObject(gameManager)
        .environmentObject(mapState)
    }
    
    func startGame(){
        gameManager.round += 1
    }
    

}


struct StartView_Previews: PreviewProvider {
    static var router = Router()
    static var previews: some View {
        StartView()
            .environmentObject(router)
    }
}
