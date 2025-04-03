import SwiftUI
import MapKit


struct HomeView: View {
    @Binding var requests: [MatchRequest]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var selectedDogs: Set<Dog> = [] // 複数選択された犬を保持
    
    struct Dog: Identifiable, Hashable, Equatable { // EquatableとHashableを追加
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
        
        static func == (lhs: Dog, rhs: Dog) -> Bool {
            return lhs.id == rhs.id // ここで比較するプロパティを決める
        }
        
        // 必要に応じて、Hashableにも対応させます
        func hash(into hasher: inout Hasher) {
            hasher.combine(id) // idでハッシュ値を生成
        }
    }
    
    let dogs = [
        Dog(name: "モカ", coordinate: CLLocationCoordinate2D(latitude: 37.785, longitude: -122.418)),
        Dog(name: "レオ", coordinate: CLLocationCoordinate2D(latitude: 37.773, longitude: -122.420))
    ]
    
    var body: some View {
        VStack {
            Map(
                coordinateRegion: $region,
                interactionModes: .all, // ここを追加！ピンチやスクロールで自由に操作可能
                annotationItems: dogs
            ) { dog in
                MapAnnotation(coordinate: dog.coordinate) {
                    Button(action: {
                        if selectedDogs.contains(dog) {
                            selectedDogs.remove(dog) // 犬が選択済みなら選択を解除
                        } else {
                            selectedDogs.insert(dog) // 犬を選択
                        }
                    }) {
                        VStack {
                            Image(systemName: "pawprint.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding(10)
                                .background(Circle().fill(selectedDogs.contains(dog) ? Color.green : Color.pink)) // 選択された犬は緑色
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
            .edgesIgnoringSafeArea(.all) // 画面いっぱいに地図を広げる
            
            if !selectedDogs.isEmpty {
                // 複数の犬が選択されている場合の表示
                VStack {
                    Text("選択された犬に会いたい！")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.bottom, 10)
                    
                    Text("選択した犬にリクエストを送ってください。")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        sendRequests(for: selectedDogs)
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
                        selectedDogs.removeAll() // 選択された犬をすべてリセット
                    }) {
                        Text("キャンセル")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.1))
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
    
    func sendRequests(for dogs: Set<Dog>) {
        // 選択されたすべての犬に対してリクエストを送る
        for dog in dogs {
            let request = MatchRequest(dogName: dog.name, requesterName: "あなた", isApproved: false)
            
            // メインスレッドで requests を更新
            DispatchQueue.main.async {
                requests.append(request)
            }
        }
        
        // リクエスト送信後、選択された犬をリセット
        DispatchQueue.main.async {
            selectedDogs.removeAll()
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(requests: .constant([])) // プレビュー用に空のリクエストリストを渡す
    }
}
