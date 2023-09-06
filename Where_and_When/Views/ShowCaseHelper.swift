//
//  ShowCaseHelper.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 15/08/2023.
//

import SwiftUI

extension View{
    @ViewBuilder
    func showCase(order: Int, titles: [String], cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous, scale: CGFloat=1, addHeight: CGFloat, addWidth: CGFloat=60) -> some View {
        self
            .anchorPreference(key: HighlightAnchorKey.self, value: .bounds, transform: { anchor in
                let highlight = Highlight(anchor: anchor, titles: titles, cornerRadius: cornerRadius, style: style, scale: scale, addHeight: addHeight, addWidth: addWidth)
                return [order: highlight]
                
            })
    }
}

struct ShowCaseRootContentView: ViewModifier{
    @Binding var enablePhotoClick: Bool
    @Binding var enablePhotoViewQuit: Bool
    @Binding var currentHighlight: Int
    @Binding var currentTitle: Int
    @Binding var showTitle: Bool
    @Binding var showNextButton: Bool


    var onFinished: () -> ()
    
    @State private var highlightOrder: [Int] = []
    
    private var isSlider: Bool{
        return currentHighlight == 3
    }
    
    @Namespace private var animation
    
    func body(content: Content) -> some View{
        content
            .onPreferenceChange(HighlightAnchorKey.self) { value in
                highlightOrder = Array(value.keys).sorted()
            }
            .overlayPreferenceValue(HighlightAnchorKey.self) { preferences in
                if highlightOrder.indices.contains(currentHighlight){
                    if let highlight = preferences[highlightOrder[currentHighlight]]{
                        HighlightView(highlight)
                    }
                }
            }
    }
    
    @ViewBuilder
    func HighlightView(_ highlight: Highlight) -> some View{
        
        let direction = TextPositionContentView(currentHighlight: currentHighlight, currentTitle: currentTitle).direction()
        
        GeometryReader { geo in
            let highlightRect = geo[highlight.anchor]
            let safeArea = geo.safeAreaInsets
            
            Rectangle()
                .fill(.black.opacity(0.5))
                .reverseMask{
                    Rectangle()
                        .matchedGeometryEffect(id: "HighlightShape", in: animation)
                        .frame(width: highlightRect.width + highlight.addWidth, height: highlightRect.height + highlight.addHeight)
                        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                        .offset(x: highlightRect.minX - highlight.addWidth/2, y: isSlider ? highlightRect.minY + safeArea.top : highlightRect.minY + safeArea.top - highlight.addHeight/2)
                        
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)

            
            Color.clear
                .contentShape(Rectangle())
                .frame(width: highlightRect.width, height: highlightRect.height)
                .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                .overlay(
                    // Custom overlay view to show title
                    showTitle ? TextBubble(direction: direction){
                        Text(highlight.titles[currentTitle])
                            .font(.custom("AmericanTypewriter", size: 20))
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: direction == .middle ? 20 : 10, trailing: 15))
                            .background(Color(hex: "fffbc0"))
                    }
                        .frame(width: 350, height: 100)
                    : nil
                    
                )
                .position(x: highlightRect.midX + TextPositionContentView(currentHighlight: currentHighlight, currentTitle: currentTitle).width(), y: highlightRect.minY - safeArea.top + TextPositionContentView(currentHighlight: currentHighlight, currentTitle: currentTitle).height())
                .allowsHitTesting(false)

            
            
            if showNextButton{
                Button{
                    if currentHighlight == 0 {
                        currentTitle += 1
                        enablePhotoClick = true
                    } else if currentHighlight == 1 {
                        currentTitle += 1
                        enablePhotoViewQuit = true
                    } else if currentHighlight == 2 {
                        currentHighlight = 3
                        currentTitle = 0
                        showTitle = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                            currentTitle += 1
                        }
                    }
                    showNextButton = false
                } label: {
                    Text("Next")
                        .font(.custom("AmericanTypewriter", size: 20))
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(CustomButtonStyle(width: 100, color: Color(hex: "fffbc0")))
                .offset(x: highlightRect.midX - 65, y: highlightRect.maxY + 50)

            }
        }
    }
}

struct ShowCaseRootResultView: ViewModifier{
    @EnvironmentObject var router: Router

    @Binding var currentHighlight: Int
    @Binding var currentTitle: Int
    @Binding var showTitle: Bool
    @Binding var showNextButton: Bool
    @Binding var showHighlights: Bool
    @State private var showEndButton: Bool = false
    @State private var finished: Bool = false
    
    var onFinished: () -> ()
    
    @State private var highlightOrder: [Int] = []
    
    
    @Namespace private var animation
    
    func body(content: Content) -> some View{
        content
            .onPreferenceChange(HighlightAnchorKey.self) { value in
                highlightOrder = Array(value.keys).sorted()
            }
            .overlayPreferenceValue(HighlightAnchorKey.self) { preferences in
                if highlightOrder.indices.contains(currentHighlight), showHighlights {
                    if let highlight = preferences[highlightOrder[currentHighlight]]{
                        HighlightView(highlight)
                    }
                }
            }
    }
    
    @ViewBuilder
    func HighlightView(_ highlight: Highlight) -> some View{
        
        let direction = TextPositionResultView(currentHighlight: currentHighlight, currentTitle: currentTitle).direction()
        
        GeometryReader { geo in
            let highlightRect = geo[highlight.anchor]
            let safeArea = geo.safeAreaInsets
            
            Rectangle()
                .fill(.black.opacity(0.5))
                .reverseMask{
                    !finished ?
                    Rectangle()
                        .matchedGeometryEffect(id: "HighlightShape", in: animation)
                        .frame(width: highlightRect.width + highlight.addWidth, height: highlightRect.height + highlight.addHeight)
                        .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                        .offset(x: highlightRect.minX - highlight.addWidth/2, y: highlightRect.minY + safeArea.top - highlight.addHeight/2)
                    : nil
                        
                }
                .ignoresSafeArea()
                .onAppear{
                   showTitle = true
                }
                .allowsHitTesting(false)

            
            Color.clear
                .contentShape(Rectangle())
                .frame(width: highlightRect.width, height: highlightRect.height)
                .clipShape(RoundedRectangle(cornerRadius: highlight.cornerRadius, style: highlight.style))
                .overlay(
                    // Custom overlay view to show title
                    showTitle ? TextBubble(direction: direction){
                        Text(highlight.titles[currentTitle])
                            .foregroundStyle(.black)
                            .font(.custom("AmericanTypewriter", size: 20))
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: direction == .middle ? 20 : 10, trailing: 15))
                            .background(Color(hex: "fffbc0"))
                    }
                        .frame(width: 350, height: 100)
                    : nil
                    
                )
                .position(x: highlightRect.midX + TextPositionResultView(currentHighlight: currentHighlight, currentTitle: currentTitle).width(), y: highlightRect.minY - safeArea.top + TextPositionResultView(currentHighlight: currentHighlight, currentTitle: currentTitle).height())
                .allowsHitTesting(false)

            
            
            if showNextButton{
                Button{
                    if currentHighlight == 0 {
                        withAnimation{
                            currentHighlight = 1
                        }
                    } else if currentHighlight == 1 {
                        if currentTitle == 0{
                            currentTitle += 1
                        } else {
                            withAnimation{
                                currentHighlight = 2
                            }
                            currentTitle = 0
                            showTitle = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                                withAnimation{
                                    finished = true
                                    showEndButton = true
                                }
                                showTitle = false
                            }
                        }
                        withAnimation{
                            showNextButton = false
                        }

                    }
                } label: {
                    Text("Next")
                        .foregroundStyle(.black)
                        .font(.custom("AmericanTypewriter", size: 20))
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(CustomButtonStyle(width: 100, color: Color(hex: "fffbc0")))
                .offset(x: highlightRect.midX - 65, y: highlightRect.maxY + 50)

            }
            
            if showEndButton{
                Button{
                    router.clear()
                } label: {
                    Text("Go back home")
                        .font(.custom("AmericanTypewriter", size: 25))
                        .frame(width: 200, height: 200)
                        //.padding(.top, 20)
                }
                .buttonStyle(CustomButtonStyle(width: 200))
                .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - safeArea.top)

            }
        }
    }
}


extension View {
    @ViewBuilder
    func reverseMask<Content: View>(alignment: Alignment = .topLeading, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading){
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}

fileprivate struct HighlightAnchorKey: PreferenceKey {
    static var defaultValue: [Int: Highlight] = [:]
    
    static func reduce(value: inout [Int : Highlight], nextValue: () -> [Int : Highlight]) {
        value.merge(nextValue()) {$1}
    }
}

struct TextPositionContentView {
    var currentHighlight: Int
    var currentTitle: Int
    
    func height() -> CGFloat{
        switch (currentHighlight, currentTitle){
        case (1,1):
            return -20
        case (2,0):
            return 40
        case (2,1):
            return 15
        case (2,2) :
            return 25
        case (3,0):
            return 40
        case (3,1):
            return 30
        default:
            return 20
        }
    }
    
    func width() -> CGFloat{
        switch (currentHighlight, currentTitle){
        case (1,1):
            return -35
        case (2,0):
            return -35
        default:
            return 0
        }
    }
    
    func direction() -> TextBubbleShape.Direction{
        switch (currentHighlight, currentTitle){
        case (1,1),(2,0):
            return .right
        default:
            return .middle
        }
    }
    
}

struct TextPositionResultView {
    var currentHighlight: Int
    var currentTitle: Int
    
    func height() -> CGFloat{
        switch (currentHighlight, currentTitle){
//        case (1,1):
//            return -20
//        case (2,0):
//            return 40
        case (0,2):
            return 73
//        case (2,2) :
//            return 25
//        case (3,0):
//            return 40
//        case (3,1):
//            return 30
        default:
            return 20
        }
    }
    
    func width() -> CGFloat{
        switch (currentHighlight, currentTitle){
//        case (1,1):
//            return -35
//        case (2,0):
//            return -35
        default:
            return 0
        }
    }
    
    func direction() -> TextBubbleShape.Direction{
        switch (currentHighlight, currentTitle){
        case (0,2):
            return .left
        default:
            return .middle
        }
    }
    
}
//extension View {
//    @ViewBuilder func presentShowCase(showPhotoView: Binding<Bool>, showHighlights: Bool, onFinished: @escaping () -> ())-> some View {
//        if #available(iOS 16.4, *) {
//            self.modifier(ShowCaseRoot(showHighlights: showHighlights, showPhotoView: showPhotoView, onFinished: onFinished))
//        }
//    }
//}

struct ShowCaseHelper: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ShowCaseHelper_Previews: PreviewProvider {
    static var previews: some View{
        //NavigationView{
            ShowCaseResultView(guessedLocation: previewMapState.guess!, isGameSummary: false, round: 1, guessedYear: 1950)
                 .environmentObject(previewGameManager)
        //}
        .environmentObject(previewGameManager)
        .environmentObject(previewMapState)
    }
}
