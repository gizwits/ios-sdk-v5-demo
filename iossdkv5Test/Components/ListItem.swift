//
//  TabNav.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI

struct ListItem: View {
    public var title:String;
    public var icon:String;
    @Binding public var isActived:Bool;
    public var onTapGesture: (() -> Void);
    var body: some View {
        Button {
            onTapGesture();
        } label: {
            BaseCard {
                HStack{
                    Text(title).frame(maxWidth: .infinity, alignment: .leading).foregroundColor(Color.primary)
                    Image("link")
                    IconImage(name: icon, isActive: $isActived, size: 18)
                }
            }
        }
        
    }
}

struct ListTitle_Previews: PreviewProvider {
    @State var isActive = true
    static var previews: some View {
        let isActive = Binding<Bool>(
            get: { true },
            set: { _ in }
        )
        VStack{
            ListItem(title: "局域网", icon: "scope", isActived:isActive) {
                
            }
        }
    }
}
