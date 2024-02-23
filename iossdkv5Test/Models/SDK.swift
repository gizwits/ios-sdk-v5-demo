//
//  SDK.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import GizwitsiOSSDK

enum FilterType: Int {
    case BLE = 0
    case WIFI = 1
}

class SDKModel: ObservableObject, GizSdkEventHandlerDelegate {
    
    
    
    // @Published 装饰需要进行绑定的数据
    public static let sharedInstance = SDKModel()
    @Published private(set) var deviceList: [GizDevice] = GizSDKManager.sharedInstance.devices
    @Published private(set) var filterModes: [FilterType]
    
    var gizConfigStruct = GizConfigStruct(appID: "xxx", appSecret: "xxx", productInfos: [
        GizProductInfoStruct(productKey: "xxx", productSecret: "xxx")
    ], serverInfo: nil)
    
    init() {
//        self.deviceList = [];
        self.filterModes = [FilterType.BLE, FilterType.WIFI]
    }

    func initSDK() {
        GizSDKManager.sharedInstance.initSDK(config: gizConfigStruct);
        GizSDKManager.sharedInstance.setDelegate(delegate: self);
        GizSDKManager.sharedInstance.startBleScan()
    }
    
    
    func switchMode(type: FilterType) {
        
    }
    
    func onDeviceListUpdate(devices: Array<GizDevice>) {
        DispatchQueue.main.async { [self] in
            // 在主线程上更新数据
            self.deviceList = devices;
            
        }
    }
    
    func convertToDictionary<T: Encodable>(object: T) -> [String: Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(object) else {
            return nil
        }
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        
        return dictionary
    }
    
    func onDeviceData(device: GizDevice, result: GizwitsiOSSDK.GizJSON, type: GizwitsiOSSDK.GizCapability) {
        
    }
    func onDeviceBindState(did: String, isBind: Bool) {
        
    }
    
    func onDeviceState(device: GizwitsiOSSDK.GizDevice, state: GizwitsiOSSDK.GizWifiDeviceNetStatus, isLogin: Bool, type: GizwitsiOSSDK.GizCapability) {
        
    }
    
    
}
