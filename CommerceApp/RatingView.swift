//
//  RatingView.swift
//  CommerceApp
//
//  Created by Pradheep Narendran P on 03/08/23.
//

import SwiftUI

struct RatingView: View {
    var rating: CGFloat
    var maxRating: Int

    init(rating: CGFloat, maxRating: Int) {
        self.rating = rating
        self.maxRating = maxRating
    }
    
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 14)
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
