import SwiftUI

struct ChatView: View {
    let dogName: String
    let requesterName: String
    
    @State private var messageText = ""
    @State private var messages: [String] = [] // メッセージの配列

    private let chatKey: String

    init(dogName: String, requesterName: String) {
        self.dogName = dogName
        self.requesterName = requesterName
        self.chatKey = "\(dogName)_\(requesterName)_chat"
    }

    var body: some View {
        VStack {
            // チャット画面のタイトル
            Text("\(requesterName) さんと \(dogName) のチャット")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()

            // メッセージリスト
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.self) { message in
                        HStack {
                            Text(message)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(15)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // メッセージ入力フィールドと送信ボタン
            HStack {
                TextField("メッセージを入力...", text: $messageText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)

                Button(action: sendMessage) {
                    Text("送信")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .navigationTitle("チャット")
        .background(Color.gray.opacity(0.05)) // 背景に薄い灰色を追加
        .onAppear {
            loadMessages()
        }
    }

    func sendMessage() {
        guard !messageText.isEmpty else { return }
        messages.append(messageText)
        messageText = "" // メッセージ送信後に入力フィールドをリセット
        saveMessages() // メッセージを保存
    }

    func loadMessages() {
        // UserDefaults からメッセージをロード
        if let savedMessages = UserDefaults.standard.array(forKey: chatKey) as? [String] {
            messages = savedMessages
        }
    }

    func saveMessages() {
        // UserDefaults にメッセージを保存
        UserDefaults.standard.set(messages, forKey: chatKey)
    }
}

#Preview {
    ChatView(dogName: "モカ", requesterName: "Alice")
}
