//
//  SearchInput.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI

struct SearchInput: View {
    @Binding var text: String
    @State private var showSearchText = false
    var OnPress: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for..", text: $text)
                    .onChange(of: text) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSearchText = !text.isEmpty
                        }
                    }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            if showSearchText {
                Button(action: {
                    OnPress()
                }) {
                    Text("Search")
                        .foregroundColor(.gray)
                        .fontWeight(.bold)
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
    }
}




struct SearchFocusedInput: View {
    @Binding var text: String
    @FocusState private var isTextFieldFocused: Bool
    @State private var navigateToSearch = false
    
    var body: some View {
        NavigationStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search for..", text: $text)
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused) {
                        if isTextFieldFocused {
                            navigateToSearch = true
                        }
                    }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .navigationDestination(isPresented: $navigateToSearch) {
                SearchScreen()
            }
        }
    }
}

