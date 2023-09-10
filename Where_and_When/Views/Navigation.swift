//
//  Navigation.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 02/08/2023.
//

import Foundation
import SwiftUI

enum Views: Hashable {
    
    //case HomeView
    case ContentView
    case ShowCaseContentView
    
}


class Router: ObservableObject {
    
    @Published var path = NavigationPath()
   
    func clear() {
        path = .init()
    }
    
    func gotoContentView() {
        path.append(Views.ContentView)
    }
    
    func gotoShowCaseContentView() {
        path.append(Views.ShowCaseContentView)
    }
    
}

enum ViewFactory {
    
    @ViewBuilder
    static func viewForDestination(_ destination: Views) -> some View {
        
        switch destination {
            
//        case .HomeView:
//           EmptyView() 
            
        case .ContentView:
            ContentView()
            
        case .ShowCaseContentView:
            ShowCaseContentView()
            
        }
    }
}
