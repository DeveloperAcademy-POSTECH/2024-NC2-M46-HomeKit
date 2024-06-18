import HealthKit
import Combine

class MyHealthManager: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var currentHeartRate: Double = 0.0
    private var heartRateQuery: HKAnchoredObjectQuery?

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Failed to create heart rate type")
            completion(false)
            return
        }
        
        let readTypes: Set<HKObjectType> = [heartRateType]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print("HealthKit authorization error: \(error)")
            } else {
                print("HealthKit authorization success")
            }
            completion(success)
        }
    }
    
    func startHeartRateQuery() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Failed to create sample type")
            return
        }
        
        let query = HKAnchoredObjectQuery(type: sampleType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, newAnchor, error) in
            self.processHeartRateSamples(samples: samples)
        }
        
        query.updateHandler = { (query, samples, deletedObjects, newAnchor, error) in
            self.processHeartRateSamples(samples: samples)
        }
        
        healthStore.execute(query)
        heartRateQuery = query
        print("Heart rate query started")
    }
    
    func stopHeartRateQuery() {
        if let query = heartRateQuery {
            healthStore.stop(query)
            print("Heart rate query stopped")
        }
    }
    
    func processHeartRateSamples(samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {
            print("No heart rate samples available")
            return
        }
        
        for sample in heartRateSamples {
            let heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            print("Heart rate sample: \(heartRate)")
            DispatchQueue.main.async {
                self.currentHeartRate = heartRate
            }
        }
    }
}
