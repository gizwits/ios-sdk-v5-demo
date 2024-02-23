//
//  DeviceListView.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI
import GizwitsiOSSDK

struct MyView: View {
    @ObservedObject var user = GizUserManager.sharedInstance
    
    var body: some View {
        VStack() {
            if (user.token != nil) {
                Button {
                    Task {
                        let data = await GizSDKManager.sharedInstance.feedback(uploadLog: true, contact: "1", content: "1")
                    }
                } label: {
                    Text("用户反馈")
                        .padding()
                        .foregroundColor(.white)
                }
                .frame(width: 200.0)
                .background(.red)
                .cornerRadius(10)
                Button {
                    Task {
                        let data = await GizUserManager.sharedInstance.logout()
                    }
                } label: {
                    Text("退出登录")
                        .padding()
                        .foregroundColor(.white)
                }
                .frame(width: 200.0)
                .background(.red)
                .cornerRadius(10)
            } else {
                Button {
                    Task {
                        let _ = await GizUserManager.sharedInstance.loginByAnonymous()
                    }
                } label: {
                    Text("匿名登录")
                        .padding()
                        .foregroundColor(.white)
                }
                .frame(width: 200.0)
                .background(Color("tintColor"))
                .cornerRadius(10)
            }
            
            
            Button {
                Task {
                    let data = await GizSDKManager.sharedInstance.cleanCache()
                }
            } label: {
                Text("清除缓存")
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(width: 200.0)
            .background(.red)
            .cornerRadius(10)

        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
