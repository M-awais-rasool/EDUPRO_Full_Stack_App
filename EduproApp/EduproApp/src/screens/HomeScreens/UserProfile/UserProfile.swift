import SwiftUI

struct UserProfile: View {
    var id : String? = ""
    @State var mentorData: Mentor? = nil
    @State var courseData: [Course]? = nil
    @State private var isFollowing = false
    @State private var selectedTab: Tab = .courses
    @State private var showToast = false
    @State private var toastMessage = ""
    @Environment(\.presentationMode) var presentationMode
    enum Tab {
        case courses
        case ratings
    }
    
    func GetData()async{
        do{
            let newId = id ?? ""
            let res = try await GetMentorDetails(id: newId)
            if res.status == "success"{
                mentorData = res.data
            }
            let courseRes = try await GetMentorCourse(id: newId)
            if courseRes.status == "success"{
                courseData = courseRes.data
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func addBook(id: String) async {
        do {
            let res = try await addBookMark(id: id)
            if res.status == "success" {
                if let index = courseData?.firstIndex(where: { $0.id == id }) {
                    DispatchQueue.main.async {
                        if var data = courseData {
                            data[index].isBookMark = true
                            courseData = data
                        }
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
                if let index = courseData?.firstIndex(where: { $0.id == id }) {
                    DispatchQueue.main.async {
                        if var data = courseData {
                            data[index].isBookMark = false
                            courseData = data
                        }
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
        ZStack() {
            ScrollView (.vertical,showsIndicators: false){
                Spacer()
                    .frame(height: 100)
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        if let imageUrlString = mentorData?.image,
                           let url = URL(string: imageUrlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(50)
                                case .failure:
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(50)
                                        .foregroundColor(.gray)
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        Text(mentorData?.name ?? "")
                            .font(.system(size: 22, weight: .bold))
                        
                        Text(mentorData?.email ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 40) {
                            VStack(spacing: 4) {
                                Text("26")
                                    .font(.system(size: 22, weight: .bold))
                                Text("Courses")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 4) {
                                Text("15800")
                                    .font(.system(size: 22, weight: .bold))
                                Text("Students")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 4) {
                                Text("8750")
                                    .font(.system(size: 22, weight: .bold))
                                Text("Ratings")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    HStack {
                        TabButtons(title: "Courses", isSelected: selectedTab == .courses) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .courses
                            }
                        }
                        
                        TabButtons(title: "Ratings", isSelected: selectedTab == .ratings) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .ratings
                            }
                        }
                    }
                    
                    if selectedTab == .courses {
                        VStack(spacing: 16) {
                            if let data = courseData{
                                ForEach(data, id: \.title) { course in
                                    BookmarkCard(
                                        image:course.image,
                                        category: course.category,
                                        title: course.title,
                                        price: String(course.price),
                                        rating: 2.3,
                                        students: 100,
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
                                
                            }
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                    } else {
                        VStack(spacing: 16) {
                            ForEach(ratings, id: \.comment) { rating in
                                RatingCard(name: rating.name, rating: rating.rating, date: rating.date, comment: rating.comment)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.bottom, 40)
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
        .onAppear(){
            Task{
                await GetData()
            }
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
        .toast(isShowing: $showToast, message: toastMessage)
    }
}

struct TabButtons: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .foregroundColor(isSelected ? .primary : .secondary)
        }
        .background(
            VStack {
                if isSelected {
                    Spacer()
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.blue)
                }
            }
        )
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
