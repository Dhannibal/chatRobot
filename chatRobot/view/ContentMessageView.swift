//
//  ContentMessageView.swift
//  Hello SwiftUI
//
//  Created by hannibal lecter on 2020/6/26.
//  Copyright © 2020 com.cuit.ygl. All rights reserved.
//

import SwiftUI

struct ContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    //聊天气泡
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
    }
}

struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMessageView(contentMessage: "Hi, I am your friend", isCurrentUser: false)
    }
}
