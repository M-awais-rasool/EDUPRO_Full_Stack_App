//
//  ContentView.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 12/02/2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLogin") private var isLogin = false
    
    var body: some View {
        Group{
            if isLogin{
                BottomNavigation()
            }
            else{
                NavigationStack{
                    LoginScreen()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
