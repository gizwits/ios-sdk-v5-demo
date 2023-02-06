//
//  TabNav.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI

struct IconImage: View {
    @State public var name:String;
    @State public var isActive:Bool;
    @State public var size:CGFloat = 22.0;
    var body: some View {
        HStack() {
            Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
            .colorMultiply(isActive ? Color("tintColor"): Color.gray)
            .padding(.leading, 10.0)
        }
    }
}

struct IconImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            IconImage(name: "wifi", isActive: false)
            IconImage(name: "wifi", isActive: true,size: 30)
        }
    }
}
