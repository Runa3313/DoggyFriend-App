import SwiftUI
import MapKit

struct HomeView: View {
    @Binding var requests: [MatchRequest]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var selectedDog: Dog? // 選択された犬を保持

    struct Dog: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }

    let dogs = [
        Dog(name: "モカ", coordinate: CLLocationCoordinate2D(latitude: 37.785, longitude: -122.418)),
        Dog(name: "レオ", coordinate: CLLocationCoordinate2D(latitude: 37.773, longitude: -122.420))
    ]

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, annotationItems: dogs) { dog in
                MapAnnotation(coordinate: dog.coordinate) {
                    Button(action: {
                        selectedDog = dog // 犬を選択
                    }) {
                        VStack {
                            Image(systemName: "pawprint.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding(10)
                                .background(Circle().fill(Color.blue))
                                .shadow(radius: 5)
                            
                            Text(dog.name)
                                .font(.caption)
                                .bold()
                                .padding(6)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }
                    }
                }
            }
            
            if let dog = selectedDog {
                // "会いたい！" ボタンのデザイン
                VStack {
                    Text("\(dog.name) に会いたい！")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)

                    Text("この犬と会いたい場合は、リクエストを送ってください。")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        sendRequest(for: dog)
                    }) {
                        Text("リクエストを送る")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                    
                    // キャンセルボタン
                    Button(action: {
                        selectedDog = nil // 選択をキャンセル
                    }) {
                        Text("キャンセル")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(radius: 10)
                .transition(.slide)
                .animation(.easeInOut(duration: 0.3))
            }
        }
    }

    func sendRequest(for dog: Dog) {
        let request = MatchRequest(dogName: dog.name, requesterName: "あなた", isApproved: false)
        requests.append(request)
        
        // リクエスト送信後、選択された犬をリセット
        selectedDog = nil
    }
}
