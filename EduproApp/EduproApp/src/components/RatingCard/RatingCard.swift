import SwiftUI

struct RatingCard: View {
    let name: String
    let rating: Double
    let date: String
    let comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                    
                    HStack(spacing: 4) {
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: starImageName(for: index))
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 12))
                            }
                        }
                        Text("• \(date)")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            Text(comment)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func starImageName(for index: Int) -> String {
        if index <= Int(rating) {
            return "star.fill"
        } else if index == Int(rating) + 1 && rating.truncatingRemainder(dividingBy: 1) >= 0.5 {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
}
