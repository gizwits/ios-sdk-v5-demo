//
//  ContentView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2022/8/4.
//

import SwiftUI
import GizwitsiOSSDK

struct BindView: View {
    
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    
    var body: some View {
        NavigationStack {
            VStack() {
                ScrollView{
                    ForEach(sdkModel.deviceList.filter({ device in
                        device.isBind == true
                    }), id: \.mac) { device in
                        DeviceCard(device: device, supportLink: true)
                    }
                    .padding(.top, 14.0)
                }.frame(maxHeight: .infinity)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BindView()
    }
}
