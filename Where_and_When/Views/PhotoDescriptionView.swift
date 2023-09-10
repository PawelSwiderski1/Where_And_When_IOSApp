//
//  PhotoDescriptionView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 25/07/2023.
//

import SwiftUI
import Kingfisher

struct PhotoDescriptionView: View {
    var photo: Photo
    
    var body: some View {
        VStack(){
            KFImage(URL(string: photo.url ))
                .resizable()
                .scaledToFit()
            //.cornerRadius(20)
            Spacer()
            VStack(spacing: 20){
                Text(photo.description)
                    .foregroundStyle(.black)
                    .font(.custom("AmericanTypewriter", size: 16))
                    .multilineTextAlignment(.leading)
                Text(photo.caption)
                    .foregroundStyle(.black)
                    .font(.custom("AmericanTypewriter", size: 12))
                    .multilineTextAlignment(.leading)
                
                
            }
            .padding()
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 3/4)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color(hex: "#FFF9A6"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 5)
        )
    }
}

struct PhotoDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDescriptionView(photo: previewPhotos[0])
    }
}
