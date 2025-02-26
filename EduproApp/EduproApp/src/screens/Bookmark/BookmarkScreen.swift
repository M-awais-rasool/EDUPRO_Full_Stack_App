
import SwiftUI

struct BookmarkScreen: View {
    @Environment(\.dismiss) private var dismiss
    let categories = ["All", "Graphic Design", "3D Design", "Arts & H"]
    @State private var selectedCategory: String = "All"
    @State private var courses: [Course]? = []
    @State private var showToast = false
    @State private var toastMessage = ""
    
    func getData()async{
        do{
            let res = try await GetBookMarkCourse()
            if res.status == "success"{
                courses = res.data
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func removeBook(id: String) async {
        do {
            print("id",id)
            let res = try await removeBookMark(id: id)
            if res.status == "success" {
                print(res.message)
                if let index = courses?.firstIndex(where: { $0.id == id }) {
                    DispatchQueue.main.async {
                        if var data = courses {
                            data[index].isBookMark = false
                            courses = data
                        }
                    }
                    await getData()
                    toastMessage = res.message
                    showToast = true
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView(.vertical,showsIndicators: false) {
                    LazyVStack(spacing: 12) {
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
                        }.padding(.vertical,10)
                        if let data = courses{
                            ForEach(data, id: \.id) { course in
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
                                                await removeBook(id: course.id)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                
            }
            .onAppear(){
                Task{
                    await getData()
                }
            }
            .navigationTitle("My Bookmark")
            .navigationBarTitleDisplayMode(.inline)
            .toast(isShowing: $showToast, message: toastMessage)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct BookmarkScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkScreen()
            .preferredColorScheme(.light)
    }
}
