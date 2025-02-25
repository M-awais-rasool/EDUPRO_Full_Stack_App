import SwiftUI

struct TopMentors: View {
    @Environment(\.dismiss) private var dismiss
    @State var mentor: [Mentor] = []
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 20)
                
                ForEach(mentor) { mentorItem in
                    MentorView(image:mentorItem.image,name: mentorItem.name, field: mentorItem.email, flag: "Mentor")
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TopMentors()
}
