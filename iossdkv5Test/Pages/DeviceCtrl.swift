//
//  DeviceListView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI
import GizwitsiOSSDK

struct DeviceCtrl: View {
    
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    @ObservedObject public var device:GizDevice;
    var type:CapabilityType;
    
    
    @State var isExp = Array(repeating: false, count: 10)
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    DeviceApiWriteItem(device: device, isShowing: $isExp[0], title: "设备控制", type: type)
                    
//                    RegisterItem(device: device, isShowing: $isExp[1], title: "注册", type: type)
                    
                    GetDeviceInfoItem(device: device, isShowing: $isExp[2], title: "获取设备信息", type: type)
                    
                    
                    CheckOTAItem(device: device, isShowing: $isExp[3], title: "检查更新", type: type)
                    StartOTAItem(device: device, isShowing: $isExp[4], title: "开始更新", type: type)
                }
            }.frame(maxHeight: .infinity)
        }.navigationTitle(Text("设备详情"))
        
    }
}
