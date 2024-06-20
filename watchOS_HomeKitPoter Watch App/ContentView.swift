import SwiftUI
import HomeKit


struct ContentView: View {
    @StateObject private var homeKitManager = HomeKitManager()
     @State private var selectedHome: HMHome?
     @State private var selectedRoom: HMRoom?
     @State private var selectedAccessory: HMAccessory?
    
    private let lightController = LightController()
    @StateObject private var motionManager = MotionManager()
    @State private var isShakeToToggleEnabled = false // 휘둘러서 조명 켜기/끄기 기능의 활성화 상태
    
    var body: some View {
        NavigationView {
            SettingView(homeKitManager: homeKitManager, selectedHome: $selectedHome, selectedRoom: $selectedRoom, selectedAccessory: $selectedAccessory)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("Apple Watch Series 7 - 41mm")
    }
}
