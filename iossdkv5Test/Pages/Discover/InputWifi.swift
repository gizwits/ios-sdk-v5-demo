//
//  InputWifi.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/6/25.
//

import SwiftUI
import GizwitsiOSSDK

struct InputWifi: View {
    @State private var ssid: String = "QA-24G"
    @State private var password: String = "12345678"
    
    var type: GizCapability
    @State var isGoToSelectDevice: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack() {
                TextField("请输入SSID", text: $ssid)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                TextField("请输入密码", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                NavigationLink(destination: SelectWifiDevice(type: type, ssid: ssid, password: password), isActive: $isGoToSelectDevice) { EmptyView() }
                
                Button {
                    self.isGoToSelectDevice = true
                } label: {
                    Text("下一步")
                    .padding()
                    .foregroundColor(.white)
                }
                .frame(width: 200.0)
                .background(Color("tintColor"))
                .cornerRadius(10)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 50, trailing: 0))

                
            }
        }.navigationBarTitle("输入Wi-Fi信息")
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
        
        
    }
}

