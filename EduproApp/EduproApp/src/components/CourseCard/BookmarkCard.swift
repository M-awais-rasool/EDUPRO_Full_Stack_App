//
//  BookmarkCard.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 20/02/2025.
//

import SwiftUI


struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


struct BookmarkCard: View {
    let category: String
    let title: String
    let price: String
    let rating: Double
    let students: Int
    let isFeatured: Bool
    
    var body: some View {
        HStack() {
            Image("images")
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 120)
                .clipShape(RoundedCornerShape(radius: 12, corners: [.topLeft, .bottomLeft]))
                .clipped()
            
            
            VStack(alignment: .leading) {
                HStack() {
                    Text(category)
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .fontWeight(.semibold)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(
                            Capsule()
                                .fill(Color.orange.opacity(0.15))
                        )
                    Spacer()
                    
                    Image(systemName: isFeatured ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18))
                        .foregroundColor(isFeatured ? .blue : .gray)
                        .padding(.trailing, 2)
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                Text("₹\(price)/-")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                
                HStack{
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 10))
                        Text(String(format: "%.1f", rating))
                            .fontWeight(.medium)
                            .font(.caption2)
                        Spacer()
                        Text("\(students.formatted()) Students")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
        )
        .frame(height: 120)
    }
}

#Preview {
    BookmarkScreen()
}
