import SwiftUI

struct TopMentors: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical,showsIndicators: false) {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 20)
                    
                    ForEach(["Jiya", "Aman", "Rahul.J", "Manav", "Manav", "Manav", "Manav", "Manav", "Manav", "Manav"], id: \.self) { mentor in
                        MentorView(name: mentor, field: "3D Design", flag: "Mentor")
                    }
                    .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            })
            .navigationTitle("Top Mentors")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TopMentors()
}
