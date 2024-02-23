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
        NavigationStack {
            VStack() {
                TabBar();
                ScrollView{
                    ForEach(sdkModel.deviceList.indices, id: \.self) { index in
                        DeviceCard(device: sdkModel.deviceList[index], supportLink: true)
                    }
                    .padding(.top, 14.0)
                }.frame(maxHeight: .infinity)
            }
        }
        
    }
}

struct DeviceCard: View {
    @ObservedObject var sdkModel = SDKModel.sharedInstance
    @ObservedObject public var device:GizDevice;
    @State var isGoToDeviceDetail = false
    var supportLink = false
    
    var body: some View {
        
        NavigationLink(destination: DeviceDetail(device: device), isActive: $isGoToDeviceDetail) { EmptyView() }
        
        Button {
            if (supportLink) {
                isGoToDeviceDetail = true
            }
        } label: {
            BaseCard {
                HStack {
                    Image(systemName: "cpu").imageScale(.large).foregroundColor(.primary)
                    Text(device.name == "" ? device.mac : device.name).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 15.0, weight: .bold))
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("PK: ").foregroundColor(.primary)
                    Text(device.productKey).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
                }
                .padding(.vertical, 1.0)
                HStack {
                    Text("MAC: ").foregroundColor(.primary)
                    Text(device.mac).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
                }
                .padding(.vertical, 1.0)
                
                if (device.lanCapability.deviceProfile != nil) {
                    let lanDevice: GizLanProfile = device.lanCapability.deviceProfile as! GizLanProfile;
                    HStack {
                        Text("Lan IP: ").foregroundColor(.primary)
                        Text(lanDevice.ip).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
                    }
                    .padding(.vertical, 1.0)
                }
                
                
                HStack {
                    // 能力列表
                    IconImage(name: "router", isActive: $device.lanCapability.isOnline, size: 18)
                    IconImage(name: "bluetoothon", isActive: $device.bleCapability.isOnline, size: 18)
                    IconImage(name: "wifi", isActive: $device.mqttCapability.isOnline, size: 18)
                }
                
                .frame(maxWidth: .infinity, alignment: .trailing)
//                ForEach(sdkModel.deviceList, id: \.mac) { device in
//                    if (device.isSame(device: device)) {
//                        
//                    }
//                }
            }
        }.accentColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
            .padding(.vertical, 4.0)

    }
}


struct SimpleDeviceCard: View {
    @State public var device:GizDevice;
    @State var isActive = false;
    
    var body: some View {
        BaseCard {
            HStack {
                Image(systemName: "cpu").imageScale(.large).foregroundColor(.primary)
                Text(device.name ?? device.mac).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 15.0, weight: .bold)).foregroundColor(.primary)
            }
            HStack {
                Text("PK: ").foregroundColor(.primary)
                Text(device.productKey).foregroundColor(Color.gray).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
            }
            .padding(.vertical, 1.0)
            HStack {
                Text("MAC: ").foregroundColor(.primary)
                Text(device.mac).foregroundColor(Color.gray).frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 12.0))
            }
            .padding(.vertical, 1.0)
        }
    }
}

struct TabBar: View {
    @State var bluetoothonActive = true
    @State var wifiActive = true
    var body: some View {
        HStack() {
            Text("搜索设备").frame(maxWidth: .infinity, alignment: .leading).font(Font.system(size: 20.0))
            Button {
            } label: {
                IconImage(name: "bluetoothon", isActive: $bluetoothonActive)
            }
            Button {
                
            } label: {
                IconImage(name: "wifi", isActive: $wifiActive)
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
