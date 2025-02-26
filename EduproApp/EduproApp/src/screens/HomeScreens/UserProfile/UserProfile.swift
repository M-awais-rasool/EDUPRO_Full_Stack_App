import SwiftUI

struct UserProfile: View {
    @State private var isFollowing = false
    @State private var selectedTab: Tab = .courses
    enum Tab {
        case courses
        case ratings
    }
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack() {
            ScrollView (.vertical,showsIndicators: false){
                Spacer()
                    .frame(height: 100)
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Circle()
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                        
                        Text("Mary Jones")
                            .font(.system(size: 22, weight: .bold))
                        
                        Text("Graphic Designer At Google")
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
                            ForEach(courses, id: \.title) { course in
                                BookmarkCard(
                                    image:"",
                                    category: course.category,
                                    title: course.title,
                                    price: course.price,
                                    rating: course.rating,
                                    students: course.students,
                                    isFeatured: course.isFeatured,
                                    OnPress: {}
                                )
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
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
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
