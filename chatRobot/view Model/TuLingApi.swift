//
//  TuLingApi.swift
//  Hello SwiftUI
//
//  Created by hannibal lecter on 2020/6/26.
//  Copyright © 2020 com.cuit.ygl. All rights reserved.
//
import Foundation
import SwiftUI
import CoreData

let api = "5374df2081c64b228533739117d60ad9"
let userId = "639782"


class TuLingApi : ObservableObject{
    @Published var source: [Message]
    
    //获得当前程序的应用代理
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //通过应用代理对象，获得管理对象上下文
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        source = [Message(content: "hello 我是图灵机器人,来和我聊天吧！", isCurrentUser:false)
        ]
        
        let fetch: NSFetchRequest<TuLingMessage> = TuLingMessage.fetchRequest()
        do{
            let Messages = try  managedObjectContext.fetch(fetch)
            for msg:TuLingMessage in Messages{
                print(msg.content ?? "error")
                source.append(Message(content: msg.content ?? "error", avatar: "robot", isCurrentUser: msg.isMe))
            }
        }catch let error as NSError {
          print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func saveInfo(content: String, isMe:Bool) {
            //通过管理对象上下文，插入一条实体数据
            let Message = NSEntityDescription.insertNewObject(forEntityName: "TuLingMessage",
                                    into: managedObjectContext) as! TuLingMessage
            //设置实体的聊天内容
            Message.content = content
            Message.isMe = isMe
            Message.time = Date()
            appDelegate.saveContext()
            //在控制台打印输出日志
            print("Success to save data.")
    }
    
    func addMessage(info:Message) {
        source.append(info)
    }
    
    func chatFunc(Myinfo: String) {
        //得到URL对象
                   let url = URL(string: "http://openapi.tuling123.com/openapi/api/v2")
                   // 创建请求
                   var request = URLRequest(url: url!)
                   request.httpMethod = "POST"
                   // POST数据
                let params:NSMutableDictionary = NSMutableDictionary()

                params["perception"] = ["inputText":["text":Myinfo]]
                params["userInfo"] = ["apiKey": api, "userId": userId]
                // ? 数据体
                var jsonData:NSData? = nil
                do {
                    jsonData  = try? JSONSerialization.data(withJSONObject: params, options:JSONSerialization.WritingOptions.prettyPrinted) as NSData?

                }
                // 将字符串转换成数据

                request.httpBody = jsonData as Data?
                
                //创建任务并执行
                    URLSession.shared.dataTask(with: request) { (data, _, error) in
                       if error == nil{
                           let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                            DispatchQueue.main.async {
                                //得到回调信息
                                let info = json["results"] as! NSArray
                                let mp:NSDictionary = info[0] as! NSDictionary
                                let res:NSDictionary = mp["values"] as! NSDictionary
                                self.addMessage(info: Message(content: res["text"] as! String, isCurrentUser: false))
                                self.saveInfo(content: res["text"] as! String, isMe: false)
                            }
                       }
                       else{
                           print("ERROR!")
                       }
                   }.resume()
    }
    
    func ListNews(Myinfo: String) {
            //得到URL对象
               let url = URL(string: "http://openapi.tuling123.com/openapi/api/v2")
               // 创建请求
               var request = URLRequest(url: url!)
               request.httpMethod = "POST"
               // POST数据
            let params:NSMutableDictionary = NSMutableDictionary()

            params["perception"] = ["inputText":["text":Myinfo]]
            params["userInfo"] = ["apiKey": api, "userId": userId]
            // ? 数据体
            var jsonData:NSData? = nil
            do {
                jsonData  = try? JSONSerialization.data(withJSONObject: params, options:JSONSerialization.WritingOptions.prettyPrinted) as NSData?

            }
            // 将字符串转换成数据

            request.httpBody = jsonData as Data?
            
            //创建任务并执行
                URLSession.shared.dataTask(with: request) { (data, _, error) in
                   if error == nil{
                       let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        DispatchQueue.main.async {
                            //得到回调信息
                    let strJson = String.init(data: data!, encoding: .utf8)
                        print(strJson!)
                        let info = json["results"] as! NSArray
                       let mp:NSDictionary = info[1] as! NSDictionary
                       let res:NSDictionary = mp["values"] as! NSDictionary
                       self.addMessage(info: Message(content: res["text"] as! String, isCurrentUser: false))
                       self.saveInfo(content: res["text"] as! String, isMe: false)
                        }
                   }
                   else{
                       print("ERROR!")
                   }
               }.resume()
        }
    
    
    func getResopnse(Myinfo: String) {
        if(Myinfo.replacingOccurrences(of: "菜谱", with: "").count != Myinfo.count || Myinfo.replacingOccurrences(of: "新闻", with: "").count != Myinfo.count || Myinfo.replacingOccurrences(of: "娱乐", with: "").count != Myinfo.count) {
            ListNews(Myinfo: Myinfo)
        }
        else {
            chatFunc(Myinfo: Myinfo)
        }
        
        
    }
    
}
