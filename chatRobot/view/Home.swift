//
//  Home.swift
//  Hello SwiftUI
//
//  Created by hannibal lecter on 2020/6/26.
//  Copyright © 2020 com.cuit.ygl. All rights reserved.
//

import SwiftUI

struct card: View {
    let robot:String
    let text:String
    var body: some View {
        VStack{
            Image(robot)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
            HStack{
                VStack(alignment: .leading) {
                    if(self.text == "图灵机器人") {
                        NavigationLink(destination: chatView(main: TuLingApi())) {
                            Text(text)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        }
                    }
                    else {
                        NavigationLink(destination: Mychatview(main: chatvm())){
                            Text(text)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        }
                    }
                }
                .layoutPriority(100)
                //将VStack 推到左侧
                Spacer()
            }
            .padding()
        }
        .background(Color.orange)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

struct Home: View {
    var body: some View {
        NavigationView{
            VStack{
                card(robot: "backrobot", text: "图灵机器人")
                card(robot: "bfurobot", text: "功能机器人")
            }.navigationBarTitle("机器人实例")
            

        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
