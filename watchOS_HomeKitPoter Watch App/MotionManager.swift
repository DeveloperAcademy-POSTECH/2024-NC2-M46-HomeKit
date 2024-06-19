import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager // Core Motion 관리자 객체
    private var queue: OperationQueue // 작업 큐

    @Published var isShaken = false // 흔들림 상태를 관찰할 변수

    init() {
        self.motionManager = CMMotionManager() // Core Motion 관리자 초기화
        self.queue = OperationQueue() // 작업 큐 초기화

        // 가속도계 사용 가능 여부 확인
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 0.1 // 가속도계 업데이트 간격 설정 (초단위)
            
            // 가속도계 업데이트 시작
            self.motionManager.startAccelerometerUpdates(to: self.queue) { [weak self] data, error in
                guard let data = data else { return }

                // 각 축의 가속도 절대값이 2.5보다 크면 흔들림으로 판단
                if abs(data.acceleration.x) > 2.5 || abs(data.acceleration.y) > 2.5 || abs(data.acceleration.z) > 2.5 {
                    DispatchQueue.main.async {
                        self?.isShaken = true //흔들림 상태 업데이트
                    }
                }
            }
        }
    }

    deinit {
        self.motionManager.stopAccelerometerUpdates() // 앱이 종료되거나 클래스 인스턴스가 해제될 때 가속도계 업데이트 중지
    }
}
