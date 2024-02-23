//
//  BleWifiDiscover.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/6/26.
//

import SwiftUI
import GizwitsiOSSDK

struct SelectWifiDevice: View {
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    @State var type: GizCapability
    var ssid = ""
    var password = ""
    var body: some View {
        NavigationStack {
            VStack() {
                ScrollView{
                    ForEach(sdkModel.deviceList.filter({ device in
                        var isMatch = false
                        switch(type) {
                            case .GizBleCapability:
                                let profile = device.bleCapability.deviceProfile as? GizBleProfile
                                if((profile != nil) && profile?.configured == false) {
                                    isMatch = true
                                }
                                break
                            case .GizLanCapability:
                                // ap 只要能发现设备就能配网
                                let profile = device.lanCapability.deviceProfile as? GizLanProfile
                                if(profile != nil) {
                                    isMatch = true
                                }
                                break
                            case .GizMQTTCapability:
                                break
                        }
                        return isMatch
                    }), id: \.mac) { device in
                        NavigationLink {
                            ConfigBleWifi(device: device, type: type, ssid: ssid, password: password)
                        } label: {
                            SimpleDeviceCard(device: device, isActive: false)
                        }
                        .accentColor(.black)

                    }
                    .padding(.top, 14.0)
                }.frame(maxHeight: .infinity)
            }
        }.navigationTitle(Text("请选择设备"))
        
    }
}

