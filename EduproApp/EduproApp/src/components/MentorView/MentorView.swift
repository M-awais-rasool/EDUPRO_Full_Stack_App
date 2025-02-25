//
//  MentorView.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 13/02/2025.
//

import SwiftUI
struct MentorView: View {
    let image: String
    let name: String
    let field:String
    let flag:String
    
    var body: some View {
        if flag == "home"{
            VStack {
                if let url = URL(string: image) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(50)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.black)
                    }
                }
                Text(name)
                    .font(.subheadline)
            }
        }else{
            HStack {
                if let url = URL(string: image) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .cornerRadius(50)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.black)
                    }
                }
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
