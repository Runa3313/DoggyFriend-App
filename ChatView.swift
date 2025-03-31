import SwiftUI

struct ChatView: View {
    let dogName: String
    let requesterName: String

    var body: some View {
        VStack {
            Text("\(requesterName) さんと \(dogName) のチャット")
                .font(.title)
                .padding()

            // 実際のチャット内容は後で追加
            Text("ここにメッセージが表示されます")
                .padding()

            Spacer()
        }
        .navigationTitle("チャット")
    }
}

#Preview {
    ChatView(dogName: "モカ", requesterName: "Alice")
}
