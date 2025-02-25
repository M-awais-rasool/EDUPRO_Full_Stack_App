
import SwiftUI

struct BookmarkScreen: View {
    @Environment(\.dismiss) private var dismiss
    let categories = ["All", "Graphic Design", "3D Design", "Arts & H"]
    @State private var selectedCategory: String = "All"
    let courses = [
        (category: "Graphic Design", title: "Graphic Design Advanced", price: "799", rating: 4.2, students: 7830, isFeatured: true),
        (category: "Graphic Design", title: "Advertisement Design", price: "499", rating: 3.9, students: 12680, isFeatured: false),
        (category: "Programming", title: "Graphic Design", price: "199", rating: 4.2, students: 990, isFeatured: true),
        (category: "Web Development", title: "Web Developer Specialization", price: "899", rating: 4.9, students: 14580, isFeatured: false),
        (category: "SEO & Marketing", title: "Digital Marketing Career Track", price: "299", rating: 4.2, students: 10252, isFeatured: true),
        (category: "SEO & Marketing", title: "Digital Marketing Track", price: "299", rating: 4.2, students: 10252, isFeatured: true)
    ]
    
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
                        ForEach(courses, id: \.title) { course in
                            BookmarkCard(
                                image:"",
                                category: course.category,
                                title: course.title,
                                price: course.price,
                                rating: course.rating,
                                students: course.students,
                                isFeatured: course.isFeatured
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                
            }
            .navigationTitle("My Bookmark")
            .navigationBarTitleDisplayMode(.inline)
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
