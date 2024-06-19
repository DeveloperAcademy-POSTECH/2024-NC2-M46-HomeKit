import HomeKit
import Combine

// HomeKitManager는 HomeKit의 홈과 액세서리 관리를 담당하는 클래스
class HomeKitManager: NSObject, ObservableObject, HMHomeManagerDelegate {
    // @Published 프로퍼티는 SwiftUI 뷰가 해당 프로퍼티의 변경 사항을 감지할 수 있게 함
    @Published var homes: [HMHome] = []
    @Published var selectedHome: HMHome?
    @Published var selectedRoom: HMRoom?
    @Published var selectedAccessory: HMAccessory?
    @Published var brightness: Int = 0
    
    private let homeManager = HMHomeManager()
    
    override init() {
        super.init()
        homeManager.delegate = self
    }
    
    // 홈 목록이 업데이트될 때 호출됨
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        self.homes = homeManager.homes
    }
    
    // 새로운 홈이 추가될 때 호출됨
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        self.homes = homeManager.homes
    }
    
    // 기존 홈이 제거될 때 호출됨
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        self.homes = homeManager.homes
    }
}
