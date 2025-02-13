//
//  SectionHeader.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var onPress: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            Button(action: {}) {
                HStack{
                    Text("SEE ALL")
                        .foregroundColor(.blue)
                    Image(systemName: "arrow.forward")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
