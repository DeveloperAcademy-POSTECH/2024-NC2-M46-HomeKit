import SwiftUI
import HomeKit


struct ContentView: View {
    @StateObject private var homeKitManager = HomeKitManager()
    private let lightController = LightController()
    @StateObject private var motionManager = MotionManager()
    @State private var isShakeToToggleEnabled = false // 휘둘러서 조명 켜기/끄기 기능의 활성화 상태
    
    var body: some View {

        NavigationView {
            VStack {
                // 사용자가 홈, 방, 액세서리를 선택할 수 있는 리스트
                List {
                    // 홈 선택 섹션
                    Section(header: Text("Select Home")) {
                        Picker("Home", selection: $homeKitManager.selectedHome) {
                            ForEach(homeKitManager.homes, id: \.self) { home in
                                Text(home.name).tag(home as HMHome?)
                            }
                        }
                    }
                    
                    // 사용자가 홈을 선택한 경우 방 선택 섹션을 표시
                    if let selectedHome = homeKitManager.selectedHome {
                        Section(header: Text("Select Room")) {
                            Picker("Room", selection: $homeKitManager.selectedRoom) {
                                ForEach(selectedHome.rooms, id: \.self) { room in
                                    Text(room.name).tag(room as HMRoom?)
                                }
                            }
                        }
                    }
                    
                    // 사용자가 방을 선택한 경우 액세서리 선택 섹션을 표시
                    if let selectedRoom = homeKitManager.selectedRoom {
                        Section(header: Text("Select Accessory")) {
                            Picker("Accessory", selection: $homeKitManager.selectedAccessory) {
                                ForEach(selectedRoom.accessories, id: \.self) { accessory in
                                    Text(accessory.name).tag(accessory as HMAccessory?)
                                }
                            }
                        }
                    }
                    
                    // 휘둘러서 조명 켜기/끄기 기능 활성화/비활성화 토글
                    Section(header: Text("Shake to Toggle Light")) {
                        Toggle("Enable Shake to Toggle", isOn: $isShakeToToggleEnabled)
                    }
                }
                
                // 아이폰 휘두름 상태를 표시하는 인디케이터
                Text(motionManager.isShaken ? "Shaken!" : "Not Shaken")
                    .font(.headline)
                    .foregroundColor(motionManager.isShaken ? .green : .red)
                    .padding()
                    .background(motionManager.isShaken ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .cornerRadius(10)
            }
            .navigationBarTitle("HomeKitPotter")
            .onChange(of: motionManager.isShaken) { _, newValue in
                handleShake(newValue)
            }
        }
    }
    
    private func handleShake(_ isShaken: Bool) {
        if isShakeToToggleEnabled && isShaken {
            if let selectedAccessory = homeKitManager.selectedAccessory {
                lightController.toggleLight(on: homeKitManager.brightness == 0, for: selectedAccessory)
                homeKitManager.brightness = homeKitManager.brightness == 0 ? 100 : 0
                
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            motionManager.isShaken = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("Apple Watch Series 7 - 41mm")
    }
}
