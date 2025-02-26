import SwiftUI

struct PopularCourses: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var courses: [Course]
    @State private var selectedCategory: String = "All"
    @State private var showToast = false
    @State private var toastMessage = ""
    
    private var filteredCourses: [Course] {
        if selectedCategory == "All" {
            return courses
        } else {
            return courses.filter { $0.category == selectedCategory }
        }
    }
    
    func addBook(id: String) async {
        do {
            let res = try await addBookMark(id: id)
            if res.status == "success" {
                if let index = courses.firstIndex(where: { $0.id == id }) {
                    DispatchQueue.main.async {
                        courses[index].isBookMark = true
                    }
                    toastMessage = res.message
                    showToast = true
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeBook(id: String) async {
        do {
            print("id",id)
            let res = try await removeBookMark(id: id)
            if res.status == "success" {
                print(res.message)
                if let index = courses.firstIndex(where: { $0.id == id }) {
                    DispatchQueue.main.async {
                        courses[index].isBookMark = false
                    }
                    toastMessage = res.message
                    showToast = true
                }
            }
        } catch {
            print(error.localizedDescription)
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
        .toast(isShowing: $showToast, message: toastMessage)
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
                        NavigationLink(destination: CourseDetailScreen(id: course.id)) {
                            BookmarkCard(
                                image: course.image,
                                category: course.category,
                                title: course.title,
                                price: String(course.price),
                                rating: 4.3,
                                students: 200,
                                isFeatured: course.isBookMark,
                                OnPress: {
                                    Task {
                                        if course.isBookMark {
                                            await removeBook(id: course.id)
                                        } else {
                                            await addBook(id: course.id)
                                        }
                                    }
                                }
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
