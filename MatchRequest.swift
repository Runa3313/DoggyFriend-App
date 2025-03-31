
import Foundation

struct MatchRequest: Identifiable {
    let id: UUID
    let dogName: String
    let requesterName: String
    var isApproved: Bool
}
