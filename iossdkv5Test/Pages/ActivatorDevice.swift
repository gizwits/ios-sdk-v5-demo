//
//  DeviceListView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI
import GizwitsiOSSDK

struct ActivatorDevice: View {
    
    var body: some View {
        NavigationStack {
            VStack() {
                NavigationLink(destination: InputWifi(type: GizCapability.GizBleCapability)) {
                    HStack() {
                        Text("蓝牙配网")
                            .padding()
                            .foregroundColor(.white)
                    }
                    .frame(width: 200.0)
                    .background(Color("tintColor"))
                    .cornerRadius(10)

                }
                
                
                
                NavigationLink(destination: InputWifi(type: GizCapability.GizLanCapability)) {
                    HStack() {
                        Text("AP配网")
                            .padding()
                            .foregroundColor(.white)
                    }
                    .frame(width: 200.0)
                    .background(Color("tintColor"))
                    .cornerRadius(10)
                                        
                                        
                }
                .frame(width: 200.0)
                .background(Color("tintColor"))
                    .cornerRadius(10)
            }
            
        }
    }
}

struct ActivatorDevice_Previews: PreviewProvider {
    static var previews: some View {
        ActivatorDevice()
    }
}
