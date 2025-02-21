import SwiftUI

struct NotificationsScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(notificationSections) { section in
                    Text(section.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, section.title == "Today" ? 16 : 5)
                    
                    ForEach(section.items) { item in
                        NotificationCard(
                            icon: item.icon,
                            iconBackgroundColor: item.iconBackgroundColor,
                            iconForegroundColor: item.iconForegroundColor,
                            title: item.title,
                            message: item.message
                        )
                    }
                }
                
                Spacer(minLength: 20)
            }
        }
        .background(.white)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        })
        .navigationTitle("Notifications")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsScreen()
    }
}
