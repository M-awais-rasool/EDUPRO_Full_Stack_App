//
//  SearchInput.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI

struct SearchInput: View {
    @Binding var Text : String
    @State var iconFlag = true
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for..", text: $Text)
            if iconFlag {
                NavigationLink(destination: SearchScreen()){
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical,10)
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        
    }
}

#Preview {
    HomeScreen()
}
