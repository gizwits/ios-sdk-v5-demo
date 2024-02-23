//
//  ContentView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2022/8/4.
//

import SwiftUI
import GizwitsiOSSDK
import NotificationToast

struct DeviceDetail: View {
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    @ObservedObject public var device:GizDevice;
    @State private var showingAlert = false
    
    @State private var isGoToDeviceDetail = false
    @State private var capacityType: CapabilityType = CapabilityType.BLE
    
    func goToBLE () {
        isGoToDeviceDetail = true
        capacityType = CapabilityType.BLE
    }
    
    func goToMqtt() {
        isGoToDeviceDetail = true
        capacityType = CapabilityType.MQTT
    }
    
    func goToLan() {
        isGoToDeviceDetail = true
        capacityType = CapabilityType.LAN
    }
    
    var body: some View {
        LoadingView(isShowing: .constant(showingAlert)) {
            NavigationStack {
                
                ScrollView{
                    VStack() {
                        
                        NavigationLink(destination: DeviceCtrl(device: device, type: capacityType), isActive: $isGoToDeviceDetail) { EmptyView() }
                        
                        DeviceCard(device: device)
                        
                        HStack() {
                            let isRegister = Binding<Bool>(
                                get: {
                                    false
                                },
                                set: { _ in }
                            )
                            ListItem(title: "注册设备", icon: "scope", isActived: isRegister) {
                                Task {
                                    let registerRes = await device.register()
                                    if (registerRes.success) {
                                        let toast = ToastView(title: "注册成功")
                                        toast.show()
                                    } else {
                                        let toast = ToastView(title: "注册失败")
                                        toast.show()
                                    }
                                }
                            }
                            
                            let isBind = Binding<Bool>(
                                get: {
                                    device.isBind
                                },
                                set: { _ in }
                            )
                            ListItem(title: device.isBind ? "解除绑定":"绑定设备", icon: "scope", isActived: isBind) {
                                Task {
                                    
                                    if (!device.isBind) {
                                        let res = await device.bind(alias: "", remark: "")
                                        if (res.success) {
                                            let toast = ToastView(title: "操作成功")
                                            toast.show()
                                        } else {
                                            let toast = ToastView(title: res.message ?? "UNKNOW")
                                            toast.show()
                                        }
                                    } else {
                                        let res = await device.unBind()
                                        if (res.success) {
                                            let toast = ToastView(title: "操作成功")
                                            toast.show()
                                        } else {
                                            let toast = ToastView(title: res.message ?? "UNKNOW")
                                            toast.show()
                                        }
                                    }
                                }
                            }
                        }
                        
                        let lanActive = Binding<Bool>(
                            get: {
                                device.lanCapability.isLogin
                            },
                            set: { _ in }
                        )
                        ListItem(title: "局域网通道", icon: "scope", isActived: lanActive) {
                            Task{
                                if (device.lanCapability.netStatus == GizWifiDeviceNetStatus.GizDeviceControlled) {
                                    // 直接跳转
                                    goToLan()
                                } else {
                                    self.showingAlert = true
                                    let res = await self.device.lanCapability.connect();
                                    
                                    if (res.success) {
                                        // 跳转到详情
                                        goToLan()
                                    } else {
                                        let toast = ToastView(title: res.message ?? "UNKNOW")
                                        toast.show()
                                    }
                                    self.showingAlert = false
                                }
                            }
                        }
                        
                        let bleActive = Binding<Bool>(
                            get: {
                                device.bleCapability.isLogin
                            },
                            set: { _ in }
                        )
                        ListItem(title: "蓝牙通道", icon: "scope", isActived: bleActive) {
                            Task() {
                                if (device.bleCapability.netStatus == GizWifiDeviceNetStatus.GizDeviceControlled) {
                                    // 直接跳转
                                    goToBLE()
                                } else {
                                    self.showingAlert = true
                                    let res = await self.device.bleCapability.connect();
                                    
                                    if (res.success) {
                                        // 跳转到详情
                                        goToBLE()
                                    } else {
                                        let toast = ToastView(title: res.message ?? "UNKNOW")
                                        toast.show()
                                    }
                                    self.showingAlert = false
                                }
                            }
                        }
                        let mqttActive = Binding<Bool>(
                            get: {
                                device.mqttCapability.isLogin
                            },
                            set: { _ in }
                        )
                        let mqttOnline = device.mqttCapability.deviceProfile?.isOnline ?? false
                        ListItem(title: "MQTT \(mqttOnline ? "(在线)": "(离线)")", icon: "scope", isActived: mqttActive) {
                            Task{
                                if (device.mqttCapability.netStatus == GizWifiDeviceNetStatus.GizDeviceControlled) {
                                    // 直接跳转
                                    goToMqtt()
                                } else {
                                    self.showingAlert = true
                                    let res = await self.device.mqttCapability.connect();
                                    if (res.success) {
                                        // 跳转到详情
                                        goToMqtt()
                                    } else {
                                        let toast = ToastView(title: res.message ?? "UNKNOW")
                                        toast.show()
                                    }
                                    self.showingAlert = false
                                }
                            }
                        }
                        
                    }
                }.frame(maxHeight: .infinity)
            }.navigationTitle(Text("详情"))
        }
    }
}

struct DeviceDetail_Previews: PreviewProvider {
    static var previews: some View {
        VStack(){}
    }
}
