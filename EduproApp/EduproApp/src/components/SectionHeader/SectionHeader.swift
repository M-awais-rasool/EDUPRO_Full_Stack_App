//
//  SectionHeader.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    var destination: AnyView
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            
            NavigationLink(destination: destination) {
                HStack(spacing: 4) {
                    Text("See All")
                        .foregroundColor(.blue)
                        .font(.system(size: 15, weight: .medium))
                    
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
