import SwiftUI

struct PopularCourses: View {
    @Environment(\.dismiss) private var dismiss
    @State var courses: [Course] = []
    @State private var selectedCategory: String = "All"
    
    private var filteredCourses: [Course] {
        if selectedCategory == "All" {
            return courses
        } else {
            return courses.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Spacer().frame(height: 20)
                
                categoryFilterView
                
                courseListView
                    .padding(.top)
            }
        }
        .navigationBarItems(leading: backButton)
        .navigationTitle("Popular Courses")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    private var categoryFilterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(techCategories, id: \.self) { category in
                    FilterButton(
                        title: category,
                        isSelected: category == selectedCategory,
                        onSelect: {
                            withAnimation {
                                selectedCategory = category
                            }
                        }
                    )
                }
            }
        }.padding(.horizontal)
    }
    
    private var courseListView: some View {
        VStack {
            if filteredCourses.isEmpty {
                Text("No courses available for \(selectedCategory)")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                VStack(spacing: 12) {
                    ForEach(filteredCourses) { course in
                        NavigationLink(destination: CourseDetailScreen(id:course.id)) {
                            BookmarkCard(
                                image: course.image,
                                category: course.category,
                                title: course.title,
                                price: String(course.price),
                                rating: 4.3,
                                students: 200,
                                isFeatured: course.isBookMark
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        }
    }
}

#Preview {
    PopularCourses()
}
