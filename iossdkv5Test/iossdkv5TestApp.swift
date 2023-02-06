//
//  iossdkv5TestApp.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2022/8/4.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct iossdkv5TestApp: App {
    init() {
        SDKModel.sharedInstance.initSDK();
    }
    var body: some Scene {
        WindowGroup {
            NavRouter()
        }
    }
}
