//
//  chatView.swift
//  Hello SwiftUI
//
//  Created by hannibal lecter on 2020/6/26.
//  Copyright © 2020 com.cuit.ygl. All rights reserved.
//

import SwiftUI

struct chatView: View {
    @ObservedObject var main = TuLingApi()
    @State var text:String = ""
    
    var body: some View {
            VStack {
                //聊天窗体
                VStack{
                    ScrollView{
                        ForEach(main.source) { msg in
                            MessageView(contentMessage: msg.content, isCurrentUser: msg.isCurrentUser, img: "robot")
                            .padding()
                        }
                    }
                }
                
                //发送+编辑框
                HStack{
                    TextField("输入信息", text:  $text) {
                    }.frame(height: 45)
                        .border(Color.gray, width: 1)
                        .padding()
                    Button(action: {
                        self.main.addMessage(info: Message(content: self.text, avatar: "robot"))
                        self.main.getResopnse(Myinfo: self.text)
                        self.main.saveInfo(content: self.text, isMe: true)
                        self.text = ""
                    }) {
                        Text("发送").frame(width: 50, height: 40)
                    }.background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(5)
                    .padding()
                    
                }.frame(height: 50)
                .padding()
                
            }.navigationBarTitle("图灵机器人", displayMode: .inline)
    }

}


struct chatView_Previews: PreviewProvider {
    static var previews: some View {
        chatView(main: TuLingApi())
    }
}

