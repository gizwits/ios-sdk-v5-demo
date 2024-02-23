//
//  SwiftUIView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/6/25.
//

import SwiftUI
import GizwitsiOSSDK
import NotificationToast

struct CheckOTAItem: View {
    
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    @ObservedObject public var device:GizDevice;
    
    @Binding var isShowing: Bool
    @State var data: GizCheckUpdateResultInfo?
    @State private var showingActionSheet = false
    @State private var option: String = "MCU"
    
    var title: String
    var type:CapabilityType;
    let options = ["MCU", "模组"]
    
    func getActionSheetButtons() -> [ActionSheet.Button] {
      
        var buttons: [ActionSheet.Button] = []
        
        for option in options {
            buttons.append(.default(Text(option)) {
                // Button action
                print("\(option) selected")
                self.option = option
                self.data = nil
            })
        }
        
        buttons.append(.cancel())
        
        return buttons
    }
    
    func checkUpdate() async {
        var otaType = GizOTAFirmwareType.GizOTAFirmareModule
        if (option == options[0]) {
            otaType = GizOTAFirmwareType.GizOTAFirmareMcu
        }
        var data: GizResult<GizCheckUpdateResultInfo, GizOTAException?>?
        switch(type) {
            case .BLE:
                data = await device.bleCapability.checkUpdate(firmwareType: otaType)
                break
            case .LAN:
                data = await device.lanCapability.checkUpdate(firmwareType: otaType)
                break
            case .MQTT:
                data = await device.mqttCapability.checkUpdate(firmwareType: otaType)
                break
        }
        if (data!.success) {
            let toast = ToastView(title: "检查更新成功")
            toast.show()
            self.data = data?.data
        } else {
            let toast = ToastView(title: "\(data?.error)")
            toast.show()
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
    var body: some View {
        BaseCard {
            DisclosureGroup(isExpanded: $isShowing) {
                VStack{
                    HStack{
                        Text("类型" + ":")
                            .foregroundColor(.gray)
                        Spacer()
                        contents().foregroundColor(.gray).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    }
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    InfoItem(label: "当前版本", value: data?.currentSoftVersion ?? "-")
                    InfoItem(label: "最新版本", value: data?.softVersion ?? "-")
                }.padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
            } label: {
                HStack() {
                    Text(title)
                    Spacer()
                    Button {
                        Task {
                            await checkUpdate()
                        }
                    } label: {
                        SystemIconImage(systemName: "play", isActive: true, size: 36).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 4))
                    }

                }
            }.foregroundColor(Color.primary)
        }
    }
}
