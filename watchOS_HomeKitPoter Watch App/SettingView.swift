import SwiftUI
import HomeKit
struct SettingView: View {
    @ObservedObject var homeKitManager = HomeKitManager() // ObservedObject로 선언
    @Binding var selectedHome: HMHome?
    @Binding var selectedRoom: HMRoom?
    @Binding var selectedAccessory: HMAccessory?
    @State private var isShakeToToggleEnabled = false
    @State private var navigateToScrollView = false
    
    private let lightController = LightController()
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(selectedHome?.name ?? "Set Home")")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(Color("PoterWhite50"))
                    .padding(.top)
                
                Text("\(selectedRoom?.name ?? "Set Room")")
                    .fontWeight(.regular)
                    .foregroundColor(Color("PoterGray"))
                Text("\(selectedAccessory?.name ?? "Set Accessory")")
                    .font(.caption2)
                    .fontWeight(.regular)
                    .foregroundColor(Color("PoterGray"))
                
                HStack{
                    // 버튼을 누르면 ScrollView로 이동
                    NavigationLink(destination: ScrollView(homeKitManager: homeKitManager,
                                                          selectedHome: $selectedHome,
                                                          selectedRoom: $selectedRoom,
                                                           selectedAccessory: $selectedAccessory, isShakeToToggleEnabled: $isShakeToToggleEnabled))
                    {
                        if (!isShakeToToggleEnabled) {
                            CustomRoundedRectangle(tl: 22, tr: 5, bl: 22, br: 5) // 모든 모서리에 같은 radius 설정
                                .frame(width: 80, height: 44)
                                .foregroundColor(Color("PoterRed"))
                                .overlay(
                                    Text("Set")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.callout)
                                )
                        }
                        else {
                            CustomRoundedRectangle(tl: 22, tr: 5, bl: 22, br: 5) // 모든 모서리에 같은 radius 설정
                                .frame(width: 80, height: 44)
                                .foregroundColor(Color("PoterWhite30"))
                                .overlay(
                                    Text("Set")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.callout)
                                )
                        }
                        
                    }
                    if (!isShakeToToggleEnabled) {
                        CustomRoundedRectangle(tl: 5, tr: 22, bl: 5, br: 22) // 모든 모서리에 같은 radius 설정
                            .frame(width: 80, height: 44)
                            .foregroundColor(Color("PoterWhite30"))
                            .overlay(
                                Text("Lumos")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.callout)
                            )
                    }
                    else {
                        CustomRoundedRectangle(tl: 5, tr: 22, bl: 5, br: 22) // 모든 모서리에 같은 radius 설정
                            .frame(width: 80, height: 44)
                            .foregroundColor(Color("PoterWhite30"))
                            .overlay(
                                Text("Lumos!")
                                    .foregroundColor(.green)
                                    .bold()
                                    .font(.callout)
                            )
                    }
                    
                }.padding(.top, 20)
            }
            .navigationBarTitle("Poter")
            .onChange(of: motionManager.isShaken) { _, newValue in
                handleShake(newValue)
            }
        }
    }
    
    // 흔들림 제어 함수
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

struct CustomRoundedRectangle: Shape {
    var tl: CGFloat // Top-Left corner radius
    var tr: CGFloat // Top-Right corner radius
    var bl: CGFloat // Bottom-Left corner radius
    var br: CGFloat // Bottom-Right corner radius
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        // Ensure the corner radius values do not exceed half of the rectangle's sides
        let topLeft = min(tl, width/2, height/2)
        let topRight = min(tr, width/2, height/2)
        let bottomLeft = min(bl, width/2, height/2)
        let bottomRight = min(br, width/2, height/2)
        
        path.move(to: CGPoint(x: width/2, y: 0))
        path.addLine(to: CGPoint(x: width - topRight, y: 0))
        path.addArc(center: CGPoint(x: width - topRight, y: topRight), radius: topRight,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: width, y: height - bottomRight))
        path.addArc(center: CGPoint(x: width - bottomRight, y: height - bottomRight), radius: bottomRight,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bottomLeft, y: height))
        path.addArc(center: CGPoint(x: bottomLeft, y: height - bottomLeft), radius: bottomLeft,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: topLeft))
        path.addArc(center: CGPoint(x: topLeft, y: topLeft), radius: topLeft,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        return path
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        let homeKitManager = HomeKitManager()
        return SettingView(homeKitManager: homeKitManager,
                           selectedHome: .constant(nil),
                           selectedRoom: .constant(nil),
                           selectedAccessory: .constant(nil))
    }
}
