import SwiftUI

struct SearchScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var searchData: [Course]? = []
    @State private var KeyWords: [KeyWordData] = []
    @State private var showResultsAnimation = false
    @State private var isTransitioning = false
    @State private var hasSearched = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    func getData() async {
        do {
            let res = try await GetKeyWords()
            if res.status == "success" {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    KeyWords = res.data
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func Search() async {
        withAnimation {
            isTransitioning = true
            showResultsAnimation = false
        }
        
        do {
            let res = try await GetSearchData(key: searchText)
            
            if res.status == "success" {
                searchData = []
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        searchData = res.data
                        hasSearched = true
                        showResultsAnimation = true
                        isTransitioning = false
                    }
                }
            } else {
                withAnimation {
                    searchData = []
                    hasSearched = true
                    isTransitioning = false
                }
            }
        } catch {
            print(error.localizedDescription)
            withAnimation {
                searchData = []
                hasSearched = true
                isTransitioning = false
            }
        }
    }
    
    func DeleteWord(id: String) async {
        do {
            let res = try await DeleteKeyWord(id: id)
            if res.status == "success" {
                withAnimation(.easeInOut) {
                    if let index = KeyWords.firstIndex(where: { $0.id == id }) {
                        KeyWords.remove(at: index)
                    }
                }
                await getData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addBook(id: String) async {
        do {
            let res = try await addBookMark(id: id)
            if res.status == "success" {
                if let index = searchData?.firstIndex(where: { $0.id == id }) {
                    DispatchQueue.main.async {
                        if var data = searchData {
                            data[index].isBookMark = true
                            searchData = data
                        }
                    }
                    toastMessage = res.message
                    showToast = true
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeBook(id: String) async {
        do {
            print("id",id)
            let res = try await removeBookMark(id: id)
            if res.status == "success" {
                print(res.message)
                if let index = searchData?.firstIndex(where: { $0.id == id }) {
                    DispatchQueue.main.async {
                        if var data = searchData {
                            data[index].isBookMark = false
                            searchData = data
                        }
                    }
                    toastMessage = res.message
                    showToast = true
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    Spacer()
                        .frame(height: 10)
                    VStack(alignment: .leading, spacing: 20) {
                        SearchInput(text: $searchText, OnPress: { Task { await Search() } })
                            .animation(.spring(response: 0.4), value: searchText)
                        
                        if !hasSearched || (searchData?.isEmpty ?? true && !hasSearched) {
                            VStack(alignment: .leading) {
                                Text("Recents Search")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .opacity(isTransitioning ? 0 : 1)
                                    .animation(.easeInOut(duration: 0.3), value: isTransitioning)
                                
                                if KeyWords.isEmpty {
                                    Text("No recent searches")
                                        .foregroundColor(.gray)
                                        .padding(.top, 8)
                                } else {
                                    ForEach(KeyWords) { category in
                                        HStack {
                                            Button(action: {
                                                withAnimation(.spring(response: 0.4)) {
                                                    searchText = category.word
                                                    Task { await Search() }
                                                }
                                            }) {
                                                Text(category.word)
                                                    .font(.body)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                Task {
                                                    await DeleteWord(id: category.id)
                                                }
                                            }) {
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(8)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                        .opacity(isTransitioning ? 0 : 1)
                                        .offset(x: isTransitioning ? -10 : 0)
                                        .animation(.easeInOut(duration: 0.3).delay(Double(KeyWords.firstIndex(where: { $0.id == category.id }) ?? 0) * 0.05), value: isTransitioning)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .opacity.combined(with: .slide)
                                        ))
                                    }
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        } else if let data = searchData, !data.isEmpty {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Result for")
                                    Text("\"\(searchText)\"")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Text("\(data.count) Founds")
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            searchData = []
                                            searchText = ""
                                            hasSearched = false
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                .opacity(showResultsAnimation ? 1 : 0)
                                .offset(y: showResultsAnimation ? 0 : -20)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showResultsAnimation)
                                
                                ForEach(Array(data.enumerated()), id: \.element.id) { index, course in
                                    NavigationLink(destination: CourseDetailScreen(id: course.id)) {
                                        BookmarkCard(
                                            image: course.image,
                                            category: course.category,
                                            title: course.title,
                                            price: String(course.price),
                                            rating: 4.3,
                                            students: 200,
                                            isFeatured: course.isBookMark,
                                            OnPress: {
                                                Task {
                                                    if course.isBookMark {
                                                        await removeBook(id: course.id)
                                                    } else {
                                                        await addBook(id: course.id)
                                                    }
                                                }
                                            }
                                        )
                                        .scaleEffect(showResultsAnimation ? 1 : 0.95)
                                        .opacity(showResultsAnimation ? 1 : 0)
                                        .offset(y: showResultsAnimation ? 0 : 20)
                                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1 + Double(index) * 0.05), value: showResultsAnimation)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                        } else {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Result for")
                                    Text("\"\(searchText)\"")
                                        .foregroundColor(.blue)
                                    Spacer()
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            searchData = []
                                            searchText = ""
                                            hasSearched = false
                                        }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                VStack(spacing: 16) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray.opacity(0.7))
                                        .padding()
                                        .background(Circle().fill(Color.gray.opacity(0.1)))
                                        .scaleEffect(showResultsAnimation ? 1 : 0.5)
                                        .opacity(showResultsAnimation ? 1 : 0)
                                    
                                    Text("No Results Found")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .opacity(showResultsAnimation ? 1 : 0)
                                        .offset(y: showResultsAnimation ? 0 : 20)
                                    
                                    Text("We couldn't find any courses matching \"\(searchText)\". Please try a different search term.")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                        .opacity(showResultsAnimation ? 1 : 0)
                                        .offset(y: showResultsAnimation ? 0 : 15)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showResultsAnimation)
                            }
                            .padding(.top, 20)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                        }
                    }
                }
                Spacer()
            }
            .onAppear() {
                Task {
                    await getData()
                }
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
            .toast(isShowing: $showToast, message: toastMessage)
        }
        .navigationBarHidden(true)
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
