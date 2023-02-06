//
//  ContentView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2022/8/4.
//

import SwiftUI
import GizwitsiOSSDK

struct MainView: View {
    var bleHandle = BleHandler.sharedInstance
    var lanHandle = LanHandler.sharedInstance
    var bleWiFiActivator = BleWiFiActivator.sharedInstance
    
    var body: some View {
        VStack() {
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
