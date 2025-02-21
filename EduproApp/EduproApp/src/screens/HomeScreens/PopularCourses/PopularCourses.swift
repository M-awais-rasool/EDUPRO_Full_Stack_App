//
//  PopularCourses.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 14/02/2025.
//

import SwiftUI

struct PopularCourses: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCategory: String = "All"
    let categories = ["All", "Graphic Design", "3D Design", "Arts & H"]
    
    var body: some View {
        VStack{
            ScrollView{
                Spacer()
                    .frame(height: 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            FilterButton(
                                title: category,
                                isSelected: category == selectedCategory,
                                onSelect: {
                                    withAnimation{
                                        selectedCategory = category
                                    }
                                }
                            )
                        }
                    }
                }.padding(.vertical,-10)
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        })
        .navigationTitle("Popular Courses")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PopularCourses()
}
