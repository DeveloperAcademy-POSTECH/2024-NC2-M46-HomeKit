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
    
    // 조명의 색상을 변경하는 함수
    func changeLightColor(to color: UIColor, for accessory: HMAccessory) {
        for service in accessory.services {
            if service.serviceType == HMServiceTypeLightbulb {
                for characteristic in service.characteristics {
                    if characteristic.characteristicType == HMCharacteristicTypeHue {
                        let hue = color.hueComponent * 360
                        characteristic.writeValue(hue) { error in
                            if let error = error {
                                print("Error setting hue: \(error)")
                            } else {
                                print("Successfully set hue to \(hue)")
                            }
                        }
                    } else if characteristic.characteristicType == HMCharacteristicTypeSaturation {
                        let saturation = color.saturationComponent * 100
                        characteristic.writeValue(saturation) { error in
                            if let error = error {
                                print("Error setting saturation: \(error)")
                            } else {
                                print("Successfully set saturation to \(saturation)")
                            }
                        }
                    }
                }
            }
        }
    }
}

// UIColor 확장을 통해 색상 구성 요소를 추출하는 기능을 제공
extension UIColor {
    var hueComponent: CGFloat {
        var hue: CGFloat = 0
        getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }
    
    var saturationComponent: CGFloat {
        var saturation: CGFloat = 0
        getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return saturation
    }
}
