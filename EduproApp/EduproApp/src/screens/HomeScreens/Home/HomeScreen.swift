//
//  HomeScreen.swift
//  EduproApp
//
//  Created by Ch  A 𝔀 𝓪 𝓲 𝓼 on 12/02/2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var searchText = ""
    @State private var selectedCategory: String = "All"
    
    let categories = ["All", "Graphic Design", "3D Design", "Arts & H"]
    let courses: [HomeCourseModel] = [
        HomeCourseModel(title: "Graphic Design Advanced", category: "Graphic Design", price: "850", rating: "4.2", students: "7830 Std"),
        HomeCourseModel(title: "Advertisement", category: "Graphic Design", price: "400", rating: "4.2", students: "7830 Std")
    ]
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hi, ALEX")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("What Would you like to learn Today?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Search Below.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        SearchInput(Text: $searchText)
                        
                        VStack(alignment: .leading) {
                            Text("25% OFF*")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Today's Special")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Get a Discount for Every\nCourse Order only Valid for\nToday.!")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            Color.blue
                                .cornerRadius(15)
                        )
                        
                        SectionHeader(title: "Popular Courses", destination: AnyView(PopularCourses()))
                        
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
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(courses) { course in
                                    NavigationLink(destination: CourseDetailScreen(course: course)) {
                                        HomeCourseCard(
                                            title: course.title,
                                            category: course.category,
                                            price: course.price,
                                            rating: course.rating,
                                            students: course.students
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(10)
                        }
                        
                        SectionHeader(title: "Top Mentor", destination: AnyView(TopMentors()))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(["Jiya", "Aman", "Rahul.J", "Manav"], id: \.self) { mentor in
                                    MentorView(name: mentor,field: "",flag: "home")
                                }
                            }
                        }.padding(.bottom,10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(15)
        }
    }
}

#Preview {
    HomeScreen()
}
