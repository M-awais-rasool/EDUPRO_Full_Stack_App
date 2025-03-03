import SwiftUI

struct CurriculcumScreen: View {
    @Environment(\.dismiss) private var dismiss
    let id:String
    let price:Double
    @State private var Data:[VideoData]? = nil
    
    func GetData()async{
        do{
            let res = try await GetVideos(id: id)
            if res.status == "success" {
                Data = res.data
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        if let sections = Data{
                            ForEach(Array(sections.enumerated()), id: \.element.id) { index, section in
                                SectionView(section: section, index: index)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 15)
            }
            
            Spacer()
            Buttons(label: "Enroll Course - $\(price)", onPress: {})
                .padding()
        }
        .onAppear(){
            Task{
                await GetData()
            }
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
        CurriculcumScreen(id:"",price: 0.0)
    }
}
