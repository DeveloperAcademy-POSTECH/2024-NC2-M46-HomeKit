import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager
    private var queue: OperationQueue

    @Published var isShaken = false

    init() {
        self.motionManager = CMMotionManager()
        self.queue = OperationQueue()

        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 0.1
            self.motionManager.startAccelerometerUpdates(to: self.queue) { [weak self] data, error in
                guard let data = data else { return }

                if abs(data.acceleration.x) > 2.5 || abs(data.acceleration.y) > 2.5 || abs(data.acceleration.z) > 2.5 {
                    DispatchQueue.main.async {
                        self?.isShaken = true
                    }
                }
            }
        }
    }

    deinit {
        self.motionManager.stopAccelerometerUpdates()
    }
}
