import HomeKit

// LightController는 HomeKit 액세서리를 제어하는 기능을 담당
class LightController: NSObject {
    
    // 조명을 켜거나 끄는 함수
    func toggleLight(on: Bool, for accessory: HMAccessory) {
        for service in accessory.services {
            if service.serviceType == HMServiceTypeLightbulb {
                for characteristic in service.characteristics {
                    if characteristic.characteristicType == HMCharacteristicTypePowerState {
                        characteristic.writeValue(on) { error in
                            if let error = error {
                                print("Error setting power state: \(error)")
                            } else {
                                print("Successfully set power state to \(on)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 조명의 밝기를 조절하는 함수
    func changeBrightness(by value: Int, for accessory: HMAccessory, completion: @escaping (Int) -> Void) {
        for service in accessory.services {
            if service.serviceType == HMServiceTypeLightbulb {
                for characteristic in service.characteristics {
                    if characteristic.characteristicType == HMCharacteristicTypeBrightness {
                        characteristic.readValue { error in
                            if let error = error {
                                print("Error reading brightness: \(error)")
                                return
                            }
                            if let currentBrightness = characteristic.value as? Int {
                                var newBrightness = currentBrightness + value
                                newBrightness = min(max(newBrightness, 0), 100) // 0% ~ 100% 범위로 제한
                                characteristic.writeValue(newBrightness) { error in
                                    if let error = error {
                                        print("Error setting brightness: \(error)")
                                    } else {
                                        print("Successfully set brightness to \(newBrightness)")
                                        completion(newBrightness)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
