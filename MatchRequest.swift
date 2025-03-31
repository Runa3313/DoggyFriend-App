
import SwiftUI

// HomeView とは別にグローバルスコープで定義
struct MatchRequest: Identifiable {
    let id = UUID()
    let dogName: String
    let requesterName: String
    var isApproved: Bool
}
