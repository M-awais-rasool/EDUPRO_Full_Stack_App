import SwiftUI

struct CourseDetailScreen: View {
    public let id:String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @Namespace private var tabAnimation
    @State private var courseData: CourseDetailData? = nil
    
    func GetData()async{
        do {
            let res = try await GetCourseDetail(id:id)
            if res.status == "success"{
                courseData = res.data
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    let benefits = [
        "25 Lessons",
        "Access Mobile, Desktop & TV",
        "Beginner Level",
        "Audio Book",
        "Lifetime Access",
        "100 Quizzes",
        "Certificate of Completion"
    ]
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    CourseHeaderView(imageName: courseData?.image ?? "")
                    
                    CourseInfoView(course: courseData, selectedTab: $selectedTab, namespace: tabAnimation)
                    
                    InstructorView(instructorName: courseData?.user.name, category: courseData?.user.email,benefits: benefits,imageName: courseData?.user.image,id:courseData?.user.id)
                    Spacer()
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                .padding(.top, 50)
                Spacer()
            }
           
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
        .onAppear() {
            Task{
                await GetData()
            }
        }
    }
}

struct CourseHeaderView: View {
    var imageName: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if let url = URL(string: imageName) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
//                        .scaledToFill()
                        .frame(height: 280)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.black.opacity(0.3)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea()
                } placeholder: {
                    ProgressView()
                        .frame(width: 260,height: 120)
                        .foregroundColor(.black)
                }
            }
        }
        .frame(height: 280)
    }
}

struct CourseInfoView: View {
    let course: CourseDetailData?
    @Binding var selectedTab: Int
    var namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(course?.category ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "E38B29"))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "FFCC00"))
                        Text("40.6")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                
                Text(course?.title ?? "")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                
                HStack(spacing: 20) {
                    InfoLabel(icon: "person.2.fill", text: "21 Classes")
                    InfoLabel(icon: "clock.fill", text: "42 Hours")
                    
                    Spacer()
                    Text("\(course?.price ?? 00, specifier: "%.2f")/-")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(hex: "3978E8"))
                }
            }
            .padding()
            .background(Color.white)
            
            CourseTabView(selectedTab: $selectedTab, namespace: namespace,text:course?.description ?? "")
        }
    }
}

struct CourseTabView: View {
    @Binding var selectedTab: Int
    var namespace: Namespace.ID
    @State var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                TabButton(text: "About", isSelected: selectedTab == 0, namespace: namespace) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = 0
                    }
                }
                
                TabButton(text: "Curriculum", isSelected: selectedTab == 1, namespace: namespace) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = 1
                    }
                }
            }
            .background(Color.white)
            
            if selectedTab == 0 {
                AboutCourseView(text:text)
                    .padding(.horizontal)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
                    .id("about")
            } else {
                CurriculumView()
                    .padding(.horizontal)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id("curriculum")
            }
        }
        .background(Color.white)
        .animation(.easeInOut, value: selectedTab)
    }
}

struct TabButton: View {
    let text: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(text)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .blue : .black.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color.blue)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "TabIndicator", in: namespace)
                    } else {
                        Capsule()
                            .fill(Color.clear)
                            .frame(height: 3)
                    }
                }
            }
        }
    }
}

struct AboutCourseView: View {
    @State private var appear = false
    @State var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? 0 : 10)
            
            Button(action: {}) {
                Text("Read More")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
            }
            .opacity(appear ? 1 : 0)
            .offset(y: appear ? 0 : 10)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                appear = true
            }
        }
        .onDisappear {
            appear = false
        }
    }
}

struct CurriculumView: View {
    @State private var appear = false
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(detailSections.enumerated()), id: \.element.id) { index, section in
                SectionView(section: section)
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.3).delay(Double(index) * 0.1),
                        value: appear
                    )
            }
            
            NavigationLink(destination: CurriculcumScreen()) {
                Text("See All")
                    .foregroundColor(.blue)
                    .padding(.top)
                    .padding(.bottom, -5)
            }
            .opacity(appear ? 1 : 0)
            .animation(.easeOut(duration: 0.3).delay(0.3), value: appear)
        }
        .onAppear {
            withAnimation {
                appear = true
            }
        }
        .onDisappear {
            appear = false
        }
    }
}

struct InstructorView: View {
    var instructorName: String?
    var category: String?
    var benefits:[String]
    var imageName: String?
    var id: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Instructor")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            NavigationLink (destination: UserProfile(id:id)){
                HStack(spacing: 16) {
                    if let url = URL(string: imageName ?? "") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(instructorName ?? "")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                        
                        Text(category ?? "")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Divider()
                .padding(.leading, 75)
            Text("What You’ll Get")
                .font(.headline)
                .bold()
                .padding(.bottom, 4)
            
            ForEach(benefits, id: \.self) { benefit in
                Text(benefit)
                    .font(.body)
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct InfoLabel: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}

//struct CourseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseDetailScreen(course: HomeCourseModel(title: "Graphic Design Advanced", category: "Graphic Design", price: "850", rating: "4.2", students: "20"))
//    }
//}
