//
//  RatingView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/14/24.
// Thanks to: https://stackoverflow.com/questions/64379079/how-to-present-accurate-star-rating-using-swiftui
//

import SwiftUI

struct RatingView: View {
    var rating: CGFloat
    var maxRating: Int
    
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        
        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
                .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

#Preview {
    HStack {
     Text("Hello")
        RatingView(rating: 4.3, maxRating: 5)
            .frame(height: 20)
    }
}
