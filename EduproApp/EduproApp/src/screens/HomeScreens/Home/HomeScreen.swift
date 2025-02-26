import SwiftUI

struct HomeScreen: View {
    @State private var searchText = ""
    @State private var selectedCategory: String = "All"
    
    
    @State private var courses: [Course]? = []
    @State private var mentor: [Mentor] = []
    
    func GetData() async {
        do {
            async let coursesResult = GetHomeCourse()
            async let mentorsResult = GetHomeMentors()
            
            let res = try await coursesResult
            let mentorRes = try await mentorsResult
            
            if res.status == "success" {
                courses = res.data
            }
            if mentorRes.status == "success" {
                mentor = mentorRes.data
            }
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    private var filteredCourses: [Course]? {
        if selectedCategory == "All" {
            return courses
        } else {
            return courses?.filter { $0.category == selectedCategory }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                headerSection
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        searchSection
                        discountBanner
                        
                        SectionHeader(
                            title: "Popular Courses",
                            destination: AnyView(
                                PopularCourses(courses: Binding<[Course]>(
                                    get: { courses ?? [] },
                                    set: { courses = $0 }
                                ))
                            )
                        )
                        categoryFilter
                        popularCourses
                        
                        SectionHeader(title: "Top Mentor", destination: AnyView(TopMentors(mentor: mentor)))
                        topMentors
                    }
                }
            }
            .padding(.horizontal)
            .task {
                await GetData()
            }
        }
    }
}

extension HomeScreen {
    
    private var headerSection: some View {
        HStack {
            Text("Hi, ALEX")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            NavigationLink(destination: NotificationsScreen()) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom, -3)
    }
    
    private var searchSection: some View {
        VStack(alignment: .leading) {
            Text("What Would you like to learn Today?")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Search Below.")
                .font(.subheadline)
                .foregroundColor(.gray)
            SearchFocusedInput(text: $searchText)
        }
    }
    
    private var discountBanner: some View {
        VStack(alignment: .leading) {
            Text("25% OFF*")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Today's Special")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text("Get a Discount for Every\nCourse Order only Valid for\nToday!")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Color.blue
                .cornerRadius(15)
        )
    }
    
    private var categoryFilter: some View {
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
        }
        .padding(.vertical, -10)
    }
    
    private var popularCourses: some View {
        VStack {
            if filteredCourses?.isEmpty ?? true {
                Text("No courses available for \(selectedCategory)")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        if let data = filteredCourses{
                            ForEach(data) { course in
                                NavigationLink(destination: CourseDetailScreen(id: course.id)) {
                                    HomeCourseCard(
                                        image: course.image,
                                        title: course.title,
                                        category: course.category,
                                        price: course.price,
                                        rating: "4.3",
                                        students: "200"
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
    }
    
    private var topMentors: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(mentor) { mentorItem in
                    MentorView(image:mentorItem.image,name: mentorItem.name, field: mentorItem.email, flag: "home")
                }
            }
        }
        .padding(.bottom, 10)
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
