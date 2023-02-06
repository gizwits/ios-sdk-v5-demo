//
//  TabNav.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI

struct NavRouter: View {
    var body: some View {
        TabView(selection: .constant(1)) {
            DeviceListView()
                .tabItem {
                    Image(systemName: "magnifyingglass").imageScale(.large)
                    Text("搜索")
            }.tag(1)
            MainView()
                .tabItem {
                    Image(systemName: "list.bullet").imageScale(.large)
                    Text("绑定")
            }.tag(2)
            
            MyView()
                .tabItem {
                    Image(systemName: "person").imageScale(.large)
                    Text("我的")
            }.tag(3)
        }
        .accentColor(/*@START_MENU_TOKEN@*/Color("tintColor")/*@END_MENU_TOKEN@*/)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        NavRouter()
    }
}
