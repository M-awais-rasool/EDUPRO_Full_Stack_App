//
//  MentorView.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI
struct MentorView: View {
    let name: String
    let field:String
    let flag:String
    
    var body: some View {
        if flag == "home"{
            VStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                Text(name)
                    .font(.subheadline)
            }
        }else{
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading){
                    Text(name)
                        .font(.title3)
                        .fontWeight(.medium)
                    Text(field)
                        .font(.subheadline)
                }
            }
        }
    }
}


#Preview {
    TopMentors()
}
