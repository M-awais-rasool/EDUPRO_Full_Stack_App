//
//  HomeCourseCard.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI

struct HomeCourseCard: View {
    let image: String
    let title: String
    let category: String
    let price: Double
    let rating: String
    let students: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .frame(width: 260,height: 120)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                        .frame(width: 260,height: 120)
                        .foregroundColor(.black)
                }
            }
            
            Text(category)
                .font(.subheadline)
                .foregroundColor(.orange)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            HStack {
                Text("\(price, specifier: "%.2f")")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                Text("|")
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(rating)
                Text("|")
                Text(students)
                    .foregroundColor(.gray)
            }
            .font(.subheadline)
        }
        .frame(width: 260,height: 205)
        .padding()
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 2)
    }
}

