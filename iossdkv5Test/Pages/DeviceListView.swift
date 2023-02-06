//
//  DeviceListView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI
import GizwitsiOSSDK

struct DeviceListView: View {
    
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    
    var body: some View {
        VStack() {
            TabBar();
            ScrollView{
                
                ForEach(sdkModel.deviceList, id: \.mac) { device in
                    DeviceCard(device: device)
                }
                .padding(.top, 14.0)
            }.frame(maxHeight: .infinity)
        }
    }
}

struct DeviceCard: View {
    @State public var device:GizDevice;
    var body: some View {
        HStack {
            VStack() {
                
                HStack {
                    Image(systemName: "cpu").imageScale(.large)
                    Text(device.name ?? device.mac).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 15.0, weight: .bold))
                }
                HStack {
                    Text("PK: ")
                    Text(device.productKey).foregroundColor(Color.gray).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
                }
                .padding(.vertical, 1.0)
                HStack {
                    Text("MAC: ")
                    Text(device.mac).foregroundColor(Color.gray).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
                }
                .padding(.vertical, 1.0)
                
                HStack {
                    Text("DID: ")
                    Text(device.did ?? "-").foregroundColor(Color.gray).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
                }
                .padding(.vertical, 1.0)
                
                
                HStack {
                    // 能力列表
                    if (device.lanCapability.isActived) {
                        
                    }
                    IconImage(name: "router", isActive: device.lanCapability.isActived, size: 18)
                    IconImage(name: "bluetoothon", isActive: device.bleCapability.isActived, size: 18)
                    IconImage(name: "wifi", isActive: device.mqttCapability.isActived, size: 18)
                }
                .padding(.vertical, 1.0)
                .frame(maxWidth: .infinity, alignment: .trailing)

            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
            .cornerRadius(10.0)
            .shadow(radius: 8)
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 2.0)
    }
}


struct TabBar: View {
    var body: some View {
        HStack() {
            Text("搜索设备").frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 20.0))
            Button {
            } label: {
                IconImage(name: "bluetoothon", isActive: true)
            }
            Button {
                
            } label: {
                IconImage(name: "wifi", isActive: true)
            }
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 10.0)
    }
}

struct DeviceListView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceListView()
    }
}
