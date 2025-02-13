//
//  HomeCourseCard.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI

struct HomeCourseCard: View {
    let title: String
    let category: String
    let price: String
    let rating: String
    let students: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 260,height: 120)
                .cornerRadius(10)
            
            Text(category)
                .font(.subheadline)
                .foregroundColor(.orange)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
            HStack {
                Text(price)
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

#Preview {
    HomeScreen()
}
