import SwiftUI

struct ProfileScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var isScrolled = false
    
    let userName = "Alex"
    let userEmail = "hernandex.redial@gmail.ac.in"
    
    var body: some View {
        ZStack {
            Color(UIColor(named: "BackgroundColor") ?? .systemGray6).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ProfileHeaderView(userName: userName, userEmail: userEmail)
                        .padding(.top, 10)
                    
                    VStack(spacing: 24) {
                        SettingsGroupView(
                            title: "Account",
                            items: [
                                SettingsItem(icon: "person.fill", title: "Edit Profile"),
                                SettingsItem(icon: "creditcard.fill", title: "Payment Options"),
                                SettingsItem(icon: "bell.fill", title: "Notifications", badge: "2"),
                                SettingsItem(icon: "globe", title: "Language", value: "English (US)"),
                            ]
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct ProfileHeaderView: View {
    let userName: String
    let userEmail: String
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .bottomTrailing) {
                Button(action: { isImagePickerPresented.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .stroke(Color.blue.opacity(0.9), lineWidth: 3)
                            .frame(width: 120, height: 120)
                        
                        Text(userName.prefix(1))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color.blue.opacity(0.9))
                    }
                }
                
                Image(systemName: "camera.fill")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(radius: 4)
                    .offset(x: 2, y: 5)
            }
            
            VStack(spacing: 0) {
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom, 16)
    }
}

struct SettingsGroupView: View {
    let title: String
    let items: [SettingsItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            VStack(spacing: 0) {
                ForEach(items) { item in
                    EnhancedSettingsRow(item: item)
                }
            }
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
}

struct EnhancedSettingsRow: View {
    let item: SettingsItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(item.specialAction ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: item.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(item.specialAction ? .blue : .gray)
            }
            
            Text(item.title)
                .font(.body)
            
            Spacer()
            HStack(spacing: 8) {
                if let value = item.value {
                    Text(value)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let badge = item.badge {
                    Text(badge)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    var value: String? = nil
    var badge: String? = nil
    var specialAction: Bool = false
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
        ProfileScreen()
            .preferredColorScheme(.dark)
    }
}
