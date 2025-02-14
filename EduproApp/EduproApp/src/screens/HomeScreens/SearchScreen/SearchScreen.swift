import SwiftUI

struct SearchScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    let categories = [
        "3D Design",
        "Graphic Design",
        "Programming",
        "SEO & Marketing",
        "Web Development",
        "Office Productivity",
        "Personal Development",
        "Finance & Accounting",
        "HR Management"
    ]
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    Spacer()
                        .frame(height: 10)
                    VStack(alignment: .leading,spacing: 20) {
                        SearchInput(Text: $searchText,iconFlag: false)
                        Text("Recents Search")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        ForEach(categories, id: \.self) { category in
                            HStack {
                                Text(category)
                                    .font(.body)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.black)
            })
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
