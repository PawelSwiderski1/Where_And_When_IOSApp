//
//  PhotoView.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 27/07/2023.
//

import SwiftUI
import Kingfisher

struct PhotoView: View {
    var photo: Photo
    @State var size: CGSize = .zero
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var offset = CGSize.zero
    @State private var maxWidthOffset = 0.0
    @State private var maxHeightOffset = 0.0
    @GestureState private var draggingOffset = CGSize.zero
    
    let width = UIScreen.main.bounds.width - 30
    var height: Double {
        return width * photo.aspectRatio
    }
    var body: some View {
            VStack(alignment: .center){
                Spacer()
                
                
                let magnifyGesture = MagnificationGesture()
                    .onChanged { value in
                        currentZoom = value - 1
                    }
                    .onEnded { value in
                        totalZoom += currentZoom
                        if totalZoom < 1{
                            totalZoom = 1
                        }
                        currentZoom = 0
                        
                        maxWidthOffset = width * (totalZoom + currentZoom - 1) / 2
                        maxHeightOffset = height * (totalZoom + currentZoom - 1) / 2
                        
                    }
                let dragGesture = DragGesture()

                    .updating($draggingOffset) { value, state, _ in
                        state = value.translation

                    }
                    .onEnded { value in
                        if abs(offset.width + value.translation.width) <= maxWidthOffset {
                            offset.width += value.translation.width
                        } else {
                            offset.width =  offset.width > 0 ? maxWidthOffset : -maxWidthOffset
                        }
                        
                        if abs(offset.height + value.translation.height) <= maxHeightOffset {
                            offset.height += value.translation.height
                        } else {
                            offset.height =  offset.height > 0 ? maxHeightOffset : -maxHeightOffset
                        }
                    }
                
                
                
                KFImage(URL(string: photo.url))
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(currentZoom + totalZoom > 1 ? currentZoom + totalZoom : 1)
                    .gesture(dragGesture.sequenced(before: magnifyGesture ))
                    .animation(.spring()) // Apply spring animation when dragging
                    .gesture(
                        magnifyGesture
                    )

                    .offset(x: abs(offset.width + draggingOffset.width) > maxWidthOffset ? (offset.width + draggingOffset.width > 0 ? maxWidthOffset : -maxWidthOffset) : offset.width + draggingOffset.width , y: abs(offset.height + draggingOffset.height) > maxHeightOffset ? (offset.height + draggingOffset.height > 0 ? maxHeightOffset : -maxHeightOffset) : offset.height + draggingOffset.height)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 5)
                    )
                    .contentShape(Rectangle())
                    .showCase(order: 1, titles: ["You can zoom the photo to specific places", "Click anywhere outside of the photo to go back to game view"], cornerRadius: 10, style: .continuous, addHeight: 20)
                    .padding(.all, 15)
                
                Spacer()
                
            }
        
            .ignoresSafeArea()
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: previewPhotos[0])
    }
}
