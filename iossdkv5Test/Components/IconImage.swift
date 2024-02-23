//
//  TabNav.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI

struct IconImage: View {
    public var name:String;
    @Binding var isActive:Bool;
    public var size:CGFloat = 22.0;
    
    var body: some View {
        HStack() {
            Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
            .colorMultiply(isActive ? Color("tintColor"): .primary)
            .padding(.leading, 10.0)
        }
    }
}
struct SystemIconImage: View {
    public var systemName:String;
    public var isActive:Bool;
    public var size:CGFloat = 30.0;
    
    var body: some View {
        HStack() {
            Image(systemName: systemName)
            .frame(width: (size * 0.7), height: (size * 0.7))
            .foregroundColor(isActive ? Color("tintColor"): Color.gray)
        }
        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        .background(Color.gray.opacity(0.1))
        .cornerRadius(size)
        .frame(width: size, height: size)
        
    }
}

struct IconImage_Previews: PreviewProvider {
    @State var isActive = false
    static var previews: some View {
        VStack{
//            IconImage(name: "wifi", isActive: $isActive)
//            IconImage(name: "wifi", isActive: $isActive,size: 30)
            SystemIconImage(systemName: "play", isActive: true,size: 40)
        }
    }
}
