import SwiftUI

struct MatchingRequestView: View {
    @Binding var requests: [MatchRequest]
    
    @State private var selectedRequest: MatchRequest?
    @State private var navigateToChat = false

    var body: some View {
        NavigationStack {
            VStack {
                // カスタムナビゲーションヘッダー
                HStack {
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding(10)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(Circle())
                        .shadow(radius: 5)

                    Text("マッチングリクエスト")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading, 10)
                        
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10) // ヘッダーが少し下に来るように調整
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.top, 5) // ヘッダーが画面上部にかからないように調整

                List {
                    ForEach($requests) { $request in
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(request.requesterName) さんが \(request.dogName) に会いたがっています！")
                                        .font(.headline)
                                        .padding(.bottom, 5)

                                    if request.isApproved {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                            Text("✅ 承認済み")
                                                .foregroundColor(.green)
                                                .font(.subheadline)
                                        }
                                        .padding(.bottom, 5)
                                    } else {
                                        Text("💭 承認待ち")
                                            .foregroundColor(.orange)
                                            .font(.subheadline)
                                            .padding(.bottom, 5)
                                    }
                                }

                                Spacer()

                                // 承認ボタン
                                if !request.isApproved {
                                    Button(action: {
                                        request.isApproved = true
                                        selectedRequest = request
                                        navigateToChat = true
                                    }) {
                                        Text("承認")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Capsule().fill(Color.blue))
                                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                            .padding(.vertical, 5)

                            // チャットボタン
                            if request.isApproved {
                                NavigationLink(destination: ChatView(dogName: request.dogName, requesterName: request.requesterName)) {
                                    Text("チャットを見る")
                                        .font(.body)
                                        .foregroundColor(.blue)
                                        .padding(8)
                                        .background(Capsule().fill(Color.blue.opacity(0.1)))
                                        .cornerRadius(8)
                                        .padding(.top, 10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .background(Color(UIColor.systemGroupedBackground)) // リストの背景色
            }
        }
    }
}

