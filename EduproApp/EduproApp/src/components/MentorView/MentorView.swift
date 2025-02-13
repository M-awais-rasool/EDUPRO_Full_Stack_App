//
//  MentorView.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI
struct MentorView: View {
    let name: String
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
            Text(name)
                .font(.subheadline)
        }
    }
}
