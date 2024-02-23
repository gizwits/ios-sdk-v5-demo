//
//  TabNav.swift
//  iossdkv5Test
//
//  Created by Kylewang on 2023/2/6.
//

import Foundation
import SwiftUI

struct BaseCard<Content : View>: View {
    @Environment(\.colorScheme) var colorScheme
    let content: Content
    init(@ViewBuilder contentBuilder: () -> Content){
        self.content = contentBuilder()
    }
    
    var body: some View {
        HStack {
            VStack() {
                content
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color("BackgroundColor"))
            .cornerRadius(10.0)
            .shadow(color: Color("ShadowColor"), radius: 8)
            
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 2.0)
        
    }
}

struct BaseCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            BaseCard {
                
            }
        }
    }
}
