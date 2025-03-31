import SwiftUI

struct ContentView: View {
    @State private var isRegistered = false // 登録が完了したか
    @State private var userType: String = "" // ユーザータイプ（ownerまたはlover）
    @State private var requests: [MatchRequest] = [] // リクエストの配列

    var body: some View {
        NavigationStack {
            if !isRegistered {
                // UserSelectionViewを表示
                UserSelectionView(isRegistered: $isRegistered, userType: $userType)
            } else {
                // 登録完了後にタブバー付きのメイン画面を表示
                TabView {
                    // requestsをHomeViewに渡す
                    HomeView(requests: $requests)
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
    }
}
#Preview {
    ContentView()
}
