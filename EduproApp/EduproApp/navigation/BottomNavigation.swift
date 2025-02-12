import SwiftUI

struct BottomNavigation: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen()
                .tag(0)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
            
            MyCoursesScreen()
                .tag(1)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    Text("My Courses")
                }
            
            ProfileScreen()
                .tag(2)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Profile")
                }
        }
        .accentColor(Color(hex: "167F71"))
        .overlay(
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 0.5)
                    .shadow(color: Color.black.opacity(1.5), radius: 3)
                    .offset(y: -49)
            }
        )
        .tint(Color(hex: "167F71"))
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    BottomNavigation()
}
