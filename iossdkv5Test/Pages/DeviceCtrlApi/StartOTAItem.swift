//
//  SwiftUIView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/6/25.
//

import SwiftUI
import GizwitsiOSSDK
import NotificationToast

struct StartOTAItem: View {
    
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    @ObservedObject public var device:GizDevice;
    @Binding var isShowing: Bool
    
    @State private var showingActionSheet = false
    @State private var option: String = "MCU"
    
    let options = ["MCU", "模组"]
    
    @State var progress = 0
    @State var event:GizOTAEvent = .GizOTAEventCheckingDeviceVersion
    
    var title: String
    var type:CapabilityType;
    
    func startUpgrade() async {
        progress = 0
        var otaType = GizOTAFirmwareType.GizOTAFirmareModule
        if (option == options[0]) {
            otaType = GizOTAFirmwareType.GizOTAFirmareMcu
        }
        let resData: GizResult<Int?, GizOTAException?>
        switch(type) {
        case .BLE:
            resData = await device.bleCapability.startUpgrade(firmwareType: otaType) { res in
                print("OTA 回调:")
                print(res)
                progress = res.percentage
                event = res.event
            }
            break
        case .LAN:
            resData = await device.lanCapability.startUpgrade(firmwareType: otaType) { res in
                progress = res.percentage
            }
            break
        case .MQTT:
            resData = await device.mqttCapability.startUpgrade(firmwareType: otaType) { res in
                progress = res.percentage
            }
            break
        }
        
        print("OTA 结果:")
        if(resData.success) {
            print("OTA 成功")
        } else {
            print("OTA 失败")
            print(resData.error)
        }
    }
    
    @ViewBuilder
    func contents() -> some View {
        Button(action: {
            showingActionSheet = true
        }, label: {
            Text(option ?? "")
            SystemIconImage(systemName: "chevron.down", isActive: false)
        })
        .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(
                        title: Text("选择"),
                        message: Text("选择类型"),
                        buttons: getActionSheetButtons()
                    )
                }
    }
    
    
    func getActionSheetButtons() -> [ActionSheet.Button] {
      
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
    var body: some View {
        BaseCard {
            DisclosureGroup(isExpanded: $isShowing) {
                HStack{
                    Text("类型" + ":")
                        .foregroundColor(.gray)
                    Spacer()
                    contents().foregroundColor(.gray).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                InfoItem(label: "当前事件", value: "\(event)")
                InfoItem(label: "当前进展", value: "\(progress)%")
            } label: {
                HStack() {
                    Text(title)
                    Spacer()
                    Button {
                        Task {
                            await startUpgrade()
                        }
                    } label: {
                        SystemIconImage(systemName: "play", isActive: true, size: 36).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                    }

                }
            }.foregroundColor(Color.primary)
        }
    }
}
