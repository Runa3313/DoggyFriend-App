import SwiftUI

struct MatchingRequestView: View {
    @Binding var requests: [MatchRequest]  // @Binding を使って親ビューから渡す
    
    @State private var selectedRequest: MatchRequest?
    @State private var navigateToChat = false

    var body: some View {
        NavigationStack {
            List {
                ForEach($requests) { $request in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(request.requesterName) さんが \(request.dogName) に会いたいです！")
                                .font(.headline)

                            if request.isApproved {
                                Text("✅ 承認済み")
                                    .foregroundColor(.green)
                                    .font(.subheadline)
                            }
                        }
                        Spacer()
                        if !request.isApproved {
                            Button("承認") {
                                request.isApproved = true
                                selectedRequest = request
                                navigateToChat = true
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("マッチングリクエスト")
            .navigationDestination(isPresented: $navigateToChat) {
                if let request = selectedRequest {
                    ChatView(dogName: request.dogName, requesterName: request.requesterName)
                }
            }
        }
    }
}

#Preview {
    MatchingRequestView(requests: .constant([]))  // プレビューのために空の requests を渡す
}
