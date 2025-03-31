import SwiftUI

struct ContentView: View {
    @State private var requests: [MatchRequest] = []

    var body: some View {
        TabView {
            HomeView(requests: $requests) // マップ画面
                .tabItem {
                    Label("マップ", systemImage: "map")
                }

            MatchingRequestView(requests: $requests) // リクエスト画面
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
