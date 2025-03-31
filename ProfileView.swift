import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("プロフィール画面")
                .font(.largeTitle)
                .padding()

            Text("ユーザー情報が表示されます")
                .padding()

            Spacer()
        }
        .navigationTitle("プロフィール")
    }
}

#Preview {
    ProfileView()
}
