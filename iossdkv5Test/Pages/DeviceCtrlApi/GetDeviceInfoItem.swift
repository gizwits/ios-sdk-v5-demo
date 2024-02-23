//
//  SwiftUIView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/6/25.
//

import SwiftUI
import GizwitsiOSSDK
import NotificationToast

struct InfoItem: View {
    var label: String
    var value: String
    var body: some View {
        HStack{
            Text(label + ":")
                .foregroundColor(.gray)
            Spacer()
            Text(value).foregroundColor(.gray).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
    }
}

struct GetDeviceInfoItem: View {
    
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    @State var content = "点击查询设备信息"
    
    @ObservedObject public var device:GizDevice;
    @State var data: DeviceInfoProfile?
    @Binding var isShowing: Bool
    var title: String
    var type:CapabilityType;
    
    
    @ViewBuilder
    func contents() -> some View {
        InfoItem(label: "moduleHardVersion", value: data?.moduleHardVersion ?? "-")
        InfoItem(label: "moduleSoftVersion", value: data?.moduleSoftVersion ?? "-")
        InfoItem(label: "mcuHardVersion", value: data?.mcuHardVersion ?? "-")
        InfoItem(label: "mcuSoftVersion", value: data?.mcuSoftVersion ?? "-")
        InfoItem(label: "protocolVersion", value: data?.protocolVersion ?? "-")
        InfoItem(label: "serialVersion", value: data?.serialPortprotocolVersion ?? "-")
        InfoItem(label: "productKey", value: data?.productKey ?? "-")
        InfoItem(label: "hardwareInfo", value: data?.hardwareInfo ?? "-")
    }
    
    func getDeviceInfo() async -> GizResult<DeviceInfoProfile?, GizCtrlException?> {
        switch(type) {
            case .BLE:
                return await device.bleCapability.getDeviceInfo()
            case .LAN:
                return await device.lanCapability.getDeviceInfo()
            case .MQTT:
                return await device.mqttCapability.getDeviceInfo()
        }
    }
    
    var body: some View {
        BaseCard {
            DisclosureGroup(isExpanded: $isShowing) {
                VStack{
                    contents()
                }.padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
            } label: {
                HStack() {
                    Text(title)
                    Spacer()
                    Button {
                        Task {
                            let res = await getDeviceInfo()
                            if (res.success) {
                                data = (res.data as! DeviceInfoProfile)
                            } else {
                                let toast = ToastView(title: "查询信息失败: \(res.error)")
                                toast.show()
                            }
                        }
                    } label: {
                        SystemIconImage(systemName: "play", isActive: true, size: 36).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                    }

                }
            }.foregroundColor(Color.primary)
        }
    }
}
