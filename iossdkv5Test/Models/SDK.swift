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

class SDKModel: ObservableObject, EventHandlerDelegate {
    
    // @Published 装饰需要进行绑定的数据
    public static let sharedInstance = SDKModel()
    @Published private(set) var deviceList: [GizDevice]
    @Published private(set) var filterModes: [FilterType]
    
    init() {
        self.deviceList = [];
        self.filterModes = [FilterType.BLE, FilterType.WIFI]
    }

    func initSDK() {
        GizSDKManager.sharedInstance.initSDK();
        GizSDKManager.sharedInstance.setDelegate(delegate: self);
    }
    
    func switchMode(type: FilterType) {
        
    }
    
    func onDeviceListUpdate(devices: Array<GizDevice>) {
        self.deviceList = devices;
    }
    
    func onDeviceData(device: GizwitsiOSSDK.GizBaseDevice, result: GizwitsiOSSDK.GizJSON) {
        
    }
    
    func onDeviceState(device: GizwitsiOSSDK.GizBaseDevice, state: GizwitsiOSSDK.GizWifiDeviceNetStatus) {
        
    }
    
}
