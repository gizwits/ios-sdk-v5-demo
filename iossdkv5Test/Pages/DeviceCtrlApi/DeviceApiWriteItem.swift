//
//  SwiftUIView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/6/25.
//

import SwiftUI
import GizwitsiOSSDK
import NotificationToast

struct WriteItemUI: View {
    var data: DataPointUIElement
    
    @Binding var deviceData: GizJSON

    @State private var isOn = true
    @State private var value = 0.0
    @State private var showingActionSheet = false
    @State private var option: String?
    
    func getActionSheetButtons(options: [String]) -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        
        for option in options {
            buttons.append(.default(Text(option)) {
                // Button action
                print("\(option) selected")
                self.option = option
            })
        }
        
        buttons.append(.cancel())
        
        return buttons
    }
    
    @ViewBuilder
    func getContent(direction: String) -> some View {
        if (direction == "V") {
            HStack {
                Text(data.title + ":")
                    .foregroundColor(.gray)
                Spacer()
                Text(String(deviceData.stringValue))
            }
        } else {
            Text(data.title + ":")
                .foregroundColor(.gray)
            Spacer()
        }
        
        
        HStack{
            if data.type == "QBooleanElement" {
                Toggle("", isOn: $deviceData.boolValue)
                    .toggleStyle(SwitchToggleStyle(tint: Color("tintColor")))
            }
            if data.type == "QLabelElement" {
                Text(String(deviceData.stringValue))
            }
            if data.type == "QRadioElement" {
                Button(action: {
                    showingActionSheet = true
                }, label: {
                    Text(data.items![deviceData.intValue])
                    SystemIconImage(systemName: "chevron.down", isActive: false)
                })
                .actionSheet(isPresented: $showingActionSheet) {
                            ActionSheet(
                                title: Text("选择"),
                                message: Text("选择要下发的值"),
                                buttons: getActionSheetButtons(options: data.items ?? [])
                            )
                        }
            }
            if data.type == "QFloatElement" {
                let uintSpec = data.object.uint_spec
                Slider(value: $deviceData.doubleValue, in: Double(uintSpec!.min)...Double(uintSpec!.max), step: Double(uintSpec!.step ?? 1))
            }
        }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
    }

    var body: some View {
        if (data.type == "QFloatElement") {
            VStack{
                getContent(direction: "V")
            }
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
        } else {
            HStack{
                getContent(direction: "H")
            }
            .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
        }
        
    }
}


struct DeviceApiWriteItem: View {
    
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    
    @State var dataPointConfig: DataPointConfig?
    // 数据点内容
    @State var deviceData: GizJSON? = nil
    
    @ObservedObject public var device:GizDevice;
    @Binding var isShowing: Bool
    var title: String
    var type:CapabilityType;
    @State var ctrlKey: Set<String> = []
    
    
    @ViewBuilder
    func getContents() -> some View {
        if (dataPointConfig != nil) {
            
            ForEach((dataPointConfig?.ui.sections[0].elements)!, id: \.self) { item in
                
                let key = item.key.replacingOccurrences(of: "entity0.", with: "")
                WriteItemUI(data: item, deviceData: Binding<GizJSON>(
                    get: { deviceData?[key] ?? GizJSON() },
                    set: { 
                        deviceData?[key] = $0
                        ctrlKey.insert(key)
                    }
                ))
            }
        }
    }
    
    func onDataChange(data: GizJSON) {
//        print("数据点变化" + data.description)
        if (data["data"].type != Type.null) {
            var newData = GizJSON()
            do{
                try newData.merge(with: deviceData ?? GizJSON())
                try newData.merge(with: data["data"])
            }catch{
                
            }
            deviceData = newData
        }
        
    }
    
    func sendDp(data: GizJSON) async -> GizResult<GizJSON?, GizCtrlException?> {
        var newData = GizJSON()
        for item in ctrlKey{
            newData[item] = data[item]
        }
        ctrlKey.removeAll()
        switch(type) {
            case .BLE:
                return await device.bleCapability.sendDp(data: newData)
            case .LAN:
                return await device.lanCapability.sendDp(data: newData)
            case .MQTT:
                return await device.mqttCapability.sendDp(data: newData)
        }
    }
    
    func getDeviceStatus() async -> GizResult<GizJSON?, GizCtrlException?> {
        switch(type) {
            case .BLE:
                return await device.bleCapability.getDp(attrs: nil)
            case .LAN:
                return await device.lanCapability.getDp(attrs: nil)
            case .MQTT:
                return await device.mqttCapability.getDp(attrs: nil)
        }
    }
    
    func addDeviceDataListener() {
        switch(type) {
            case .BLE:
                device.bleCapability.addDeviceDataListener(closure: onDataChange)
                break
            case .LAN:
                device.lanCapability.addDeviceDataListener(closure: onDataChange)
                break
            case .MQTT:
                device.mqttCapability.addDeviceDataListener(closure: onDataChange)
                break
        }
    }
    func removeDeviceDataListener() {
        switch(type) {
            case .BLE:
                device.bleCapability.removeDeviceDataListener(closure: onDataChange)
                break
            case .LAN:
                device.lanCapability.removeDeviceDataListener(closure: onDataChange)
                break
            case .MQTT:
                device.mqttCapability.removeDeviceDataListener(closure: onDataChange)
                break
        }
    }
    
    var body: some View {
        BaseCard {
            DisclosureGroup(isExpanded: $isShowing) {
                VStack{
                    getContents()
                }.padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
            } label: {
                HStack() {
                    Text(title)
                    Spacer()
                    Button {
                        Task {
                            let resData = await self.getDeviceStatus()
                            if (resData.success) {
                                let toast = ToastView(title: "查询成功")
                                toast.show()
                            } else {
                                let toast = ToastView(title: "\(resData.error)")
                                toast.show()
                            }
                        }
                    } label: {
                        SystemIconImage(systemName: "arrow.triangle.2.circlepath", isActive: true, size: 36).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                    }
                    Button {
                        Task {
                            if deviceData != nil && ctrlKey.count > 0 {
                                let resData = await sendDp(data: deviceData!)
                                if (resData.success) {
                                    let toast = ToastView(title: "发送成功")
                                    toast.show()
                                } else {
                                    let toast = ToastView(title: "\(resData.error)")
                                    toast.show()
                                }
                            }
                            
                        }
                    } label: {
                        SystemIconImage(systemName: "play", isActive: true, size: 36).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                    }

                }
            }.foregroundColor(Color.primary)
        }.onAppear() {
            Task {
                addDeviceDataListener();
                self.dataPointConfig = await device.getDataPointConfig()
                await self.getDeviceStatus()
            }
        }.onDisappear() {
            removeDeviceDataListener()

        }
    }
}
