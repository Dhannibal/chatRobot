//
//  MessageView.swift
//  Hello SwiftUI
//
//  Created by hannibal lecter on 2020/6/26.
//  Copyright © 2020 com.cuit.ygl. All rights reserved.
//

import SwiftUI

struct MessageView: View {
    let contentMessage: String
    let isCurrentUser: Bool
    let img:String
    //头像+聊天气泡
    var body: some View {
         HStack{
            //如果是本人发的消息
            if(!isCurrentUser) {
                Image(img)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
                .padding()
                ContentMessageView(contentMessage: contentMessage,
                isCurrentUser: isCurrentUser)
                Spacer()
            }
            else {
                Spacer()
                ContentMessageView(contentMessage: contentMessage,
                isCurrentUser: isCurrentUser)
            }
         }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(contentMessage: "你好呀", isCurrentUser: false, img: "furobot")
    }
}
