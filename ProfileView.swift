import SwiftUICore
import SwiftUI
struct ContentView: View {
    // グローバルスコープの MatchRequest を使用
    @State private var requests: [MatchRequest] = []

    var body: some View {
        TabView {
            HomeView(requests: $requests) // マップ画面
                .tabItem {
                    Label("マップ", systemImage: "map")
                }

            MatchingRequestView(requests: $requests) // マッチングリクエスト画面
                .tabItem {
                    Label("リクエスト", systemImage: "bell")
                }

            ProfileView() // プロフィール画面
                .tabItem {
                    Label("プロフィール", systemImage: "person")
                }
        }
    }
}


#Preview {
    ContentView()
}
