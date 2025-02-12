//
//  TextInput.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 12/02/2025.
//

import SwiftUI

struct TextInput: View {
    @Binding var text:String
    @State var label = ""
    @State var icon = ""
    @State var placeHolder = ""
    @State var isPasswordVisible = true
    @State var fieldType = "email"
    @Binding var errorMessage:String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                    .frame(width: 24)
                
                if isPasswordVisible {
                    TextField(label, text: $text)
                        .autocapitalization(.none)
                } else {
                    SecureField(label, text: $text)
                        .autocapitalization(.none)
                    
                }
                if !isPasswordVisible || fieldType == "password"{
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .frame(height: 56)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            if let emailError = errorMessage {
                Text(emailError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading,10)
                    .padding(.top,-8)
            }
        }
    }
}

