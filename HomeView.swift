import SwiftUI

struct ChatView: View {
    let dogName: String
    let requesterName: String
    
    @State private var messageText = ""
    @State private var messages: [Message] = [] // メッセージの配列
    
    private let chatKey: String
    
    init(dogName: String, requesterName: String) {
        self.dogName = dogName
        self.requesterName = requesterName
        self.chatKey = "\(dogName)_\(requesterName)_chat"
    }
    
    struct Message: Identifiable, Codable {
        let id = UUID()
        let text: String
        let isUser: Bool // 自分のメッセージかどうか
    }
    
    var body: some View {
        VStack {
            // チャット画面のタイトル
            Text("\(requesterName) さんと \(dogName) のチャット")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
            
            // メッセージリスト
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.blue.opacity(0.8))
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(15)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
                .onChange(of: messages) { _ in
                    withAnimation {
                        scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            Spacer()
            
            // メッセージ入力フィールドと送信ボタン
            HStack {
                TextField("メッセージを入力...", text: $messageText, onCommit: sendMessage)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
        .navigationTitle("チャット")
        .background(Color.gray.opacity(0.05))
        .onAppear {
            loadMessages()
        }
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        let newMessage = Message(text: messageText, isUser: true)
        messages.append(newMessage)
        messageText = ""
        saveMessages()
    }
    
    func loadMessages() {
        if let savedData = UserDefaults.standard.data(forKey: chatKey),
           let savedMessages = try? JSONDecoder().decode([Message].self, from: savedData) {
            messages = savedMessages
        }
    }
    
    func saveMessages() {
        if let encoded = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encoded, forKey: chatKey)
        }
    }
}

#Preview {
    ChatView(dogName: "モカ", requesterName: "Alice")
}
