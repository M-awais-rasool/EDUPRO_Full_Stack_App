//
//  NotificationCard.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 21/02/2025.
//

import SwiftUI

struct NotificationCard: View {
    var icon: String
    var iconBackgroundColor: Color = .blue
    var iconForegroundColor: Color = .blue
    var title: String
    var message: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 46, height: 46)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconBackgroundColor == .white ? iconForegroundColor : .white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(UIColor.darkText))
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(12)
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
