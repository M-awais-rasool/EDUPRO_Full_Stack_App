import SwiftUI

struct CurriculcumScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ForEach(sections) { section in
                            SectionView(section: section)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 15)
            }
            
            Spacer()
            Buttons(label: "Enroll Course - $55", onPress: {})
                .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Curriculcum", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.black)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurriculcumScreen()
    }
}
