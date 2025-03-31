import SwiftUI
import MapKit

struct HomeView: View {
    @Binding var requests: [MatchRequest] // @Binding を使って親ビューから渡す
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedDog: Dog?
    @State private var showRequestButton = false

    struct Dog: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }

    let dogs = [
        Dog(name: "モカ", coordinate: CLLocationCoordinate2D(latitude: 37.775, longitude: -122.418)),
        Dog(name: "レオ", coordinate: CLLocationCoordinate2D(latitude: 37.773, longitude: -122.420))
    ]

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: dogs) { dog in
                MapAnnotation(coordinate: dog.coordinate) {
                    Button(action: {
                        selectedDog = dog
                        showRequestButton = true
                    }) {
                        VStack {
                            Image(systemName: "pawprint.fill")
                                .foregroundColor(.brown)
                                .font(.title)
                                .padding(5)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                            
                            Text(dog.name)
                                .font(.caption)
                                .bold()
                                .padding(4)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            if let dog = selectedDog, showRequestButton {
                VStack {
                    Spacer()
                    VStack {
                        Text(dog.name)
                            .font(.title)
                            .bold()
                        Button("会いたい") {
                            sendRequest(for: dog)
                            selectedDog = nil
                            showRequestButton = false
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }

    func sendRequest(for dog: Dog) {
        let request = MatchRequest(id: UUID(), dogName: dog.name, requesterName: "あなた", isApproved: false)
        requests.append(request)
    }

}

#Preview {
    HomeView(requests: .constant([]))  // プレビューのために空の requests を渡す
}
