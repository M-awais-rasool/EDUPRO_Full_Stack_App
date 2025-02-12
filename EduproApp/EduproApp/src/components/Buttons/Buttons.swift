//
//  Buttons.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 12/02/2025.
//

import SwiftUI

struct Buttons: View {
    @State var label = ""
    var onPress: () -> Void
    
    var body: some View {
        Button(action: {
            onPress()
        }) {
            HStack {
                Spacer()
                Text(label)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.leading, 50)
                Spacer()
                Circle()
                    .fill(Color.white)
                    .frame(width: 35, height: 35)
                    .overlay(
                        Image(systemName: "arrow.right")
                            .foregroundColor(.blue)
                            .font(.system(size: 18, weight: .bold))
                    )
                    .padding(.trailing, 10)
            }
            .frame(height: 50)
            .background(Color.blue)
            .cornerRadius(30)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }
}

