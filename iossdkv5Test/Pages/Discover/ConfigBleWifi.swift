//
//  ConfigBleWifi.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/6/26.
//

import SwiftUI
import GizwitsiOSSDK

struct ConfigBleWifi: View {
    @State var device: GizDevice
    @State var type: GizCapability
    @State var ssid: String
    @State var password: String
    
    @State var content = ["配置中"]
    
    func onProgress(res: GizWiFiActivatorEvent) {
        var codeString = ""
        if(res == GizWiFiActivatorEvent.GIZ_CONNECT_SUCCESS) {
            codeString = "连接成功"
        }
        if(res == GizWiFiActivatorEvent.GIZ_CONFIG_SEND_SUCCESS) {
            codeString = "发送成功"
        }
        if(res == GizWiFiActivatorEvent.GIZ_CONFIG_RECV_SUCCESS) {
            codeString = "设备回复收到"
        }
        content.append(codeString)
    }
    
    func completeHandler(res: GizResult<GizBaseProfile?, GizActivatorCombinedException?>) {
        if (res.error == GizActivatorCombinedException.ActivatorExceptionError(.GIZ_SDK_DEVICE_CONFIG_TIMEOUT)) {
            content.append("配置超时")
        }
        if (res.success == true) {
            content.append("发现设备: \(res.data??.mac ?? "")")
        }
    }
    
    func startConfig () async {
        switch(type) {
            case .GizBleCapability:
                let res = await device.bleCapability.provideWiFiCredentials(ssid: ssid, password: password, timeout: 60, processHandler: { event in
                    onProgress(res: event)
                })
                completeHandler(res: res)
                break
            
            case .GizLanCapability:
                let res = await device.lanCapability.provideWiFiCredentials(ssid: ssid, password: password, timeout: 60, processHandler: { event in
                    onProgress(res: event)
                })
                completeHandler(res: res)
                break
            
            case .GizMQTTCapability:
                break
            }
        
    }
    var body: some View {
        
        NavigationStack {
            ForEach(content, id: \.self) { item in
                Text(item)
            }
        }.onAppear{
            Task {
                await startConfig()
            }
        }
    }
}
