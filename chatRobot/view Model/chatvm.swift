//
//  chatvm.swift
//  Hello SwiftUI
//
//  Created by hannibal lecter on 2020/6/26.
//  Copyright © 2020 com.cuit.ygl. All rights reserved.
//

import Foundation
import SwiftUI
import CoreData

let weatherUrl:String = "https://yiketianqi.com/api?version=v61&appid=18861685&appsecret=C9CF619l&version=v61&city="
let newsUrl:String = "http://api.avatardata.cn/ActNews/Query?key=36c8e92a969841cd8bb5dfa488dbf0cf&keyword="

class chatvm : ObservableObject{
    @Published var source: [Message]
    //获得当前程序的应用代理
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //通过应用代理对象，获得管理对象上下文
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    init() {
        source = [Message(content: "我是多功能机器人，你可以问我\n1. 天气+地区  获得天气\n2. 新闻+关键词  获取新闻\n3. 古诗  随机一句古诗\n4. 菜谱+关键词 获取相关菜谱\n5. 跟我聊天", isCurrentUser:false)
        ]
        
        let fetch: NSFetchRequest<MyrobotMessage> = MyrobotMessage.fetchRequest()
        do{
            let Messages = try  managedObjectContext.fetch(fetch)
            for msg:MyrobotMessage in Messages{
                print(msg.content ?? "error")
                source.append(Message(content: msg.content ?? "error", avatar: "furobot", isCurrentUser: msg.isMe))
            }
        }catch let error as NSError {
          print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func addMessage(info:Message) {
        source.append(info)
    }
    
     func saveInfo(content: String, isMe:Bool) {
            //通过管理对象上下文，插入一条实体数据
            let Message = NSEntityDescription.insertNewObject(forEntityName: "MyrobotMessage",
                                    into: managedObjectContext) as! MyrobotMessage
            //设置实体的聊天内容
            Message.content = content
            Message.isMe = isMe
            Message.time = Date()
            appDelegate.saveContext()
            //在控制台打印输出日志
            print("Success to save data.")
    }
    
    func getResopnse(Myinfo: String) {
        //天气指令
        if (Myinfo.prefix(2) == "天气") {
            let indexN = Myinfo.index(Myinfo.startIndex, offsetBy: 3)
            let indexM = Myinfo.index(Myinfo.startIndex, offsetBy: Myinfo.count)
            let substr = Myinfo[indexN..<indexM]
            getWeather(city: String(substr))
        }
        //新闻指令
        else if(Myinfo.prefix(2) == "新闻") {
            let indexN = Myinfo.index(Myinfo.startIndex, offsetBy: 3)
            let indexM = Myinfo.index(Myinfo.startIndex, offsetBy: Myinfo.count)
            let substr = Myinfo[indexN..<indexM]
            getNews(key: String(substr))
        }
        //古诗指令
        else if(Myinfo.prefix(2) == "古诗") {
            getpoem()
        }
        else if(Myinfo.prefix(2) == "菜谱") {
            let indexN = Myinfo.index(Myinfo.startIndex, offsetBy: 3)
            let indexM = Myinfo.index(Myinfo.startIndex, offsetBy: Myinfo.count)
            let substr = Myinfo[indexN..<indexM]
            getmeum(key: String(substr))
        }else {
            //聊天指令
            let newstr = Myinfo.replacingOccurrences(of: "？", with: ".").replacingOccurrences(of: "吗", with: "呀").replacingOccurrences(of: "你", with: "我")
            self.addMessage(info: Message(content: newstr, avatar: "furobot", isCurrentUser: false))
            self.saveInfo(content: newstr, isMe: false)
        }
    }
    
    func getWeather(city:String) {
        let newUrl = (weatherUrl + city).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: newUrl)
        //创建任务并执行
        
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            if error == nil{
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                 DispatchQueue.main.async {
                     //得到回调信息
                    let city:String = json["city"] as! String
                    let wea = json["wea"] as! String
                    let win = json["win"] as! String
                    let air_tips = json["air_tips"] as! String
                    let res = city + "  " + wea + "  " + win + "\n" + air_tips
                    self.addMessage(info: Message(content: res, avatar: "furobot", isCurrentUser: false))
                    self.saveInfo(content: res, isMe: false)
                 }
            }
            else{
                print("ERROR!")
            }
        }.resume()
    }
    
    func getNews(key:String) {
        let newUrl = (newsUrl + key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: newUrl)
        //创建任务并执行
        
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            if error == nil{
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                 DispatchQueue.main.async {
//                     //得到回调信息
//                    let strJson = String.init(data: data!, encoding: .utf8)
//                        print(strJson!)
                    
                    let NewInfoJson:NSArray = json["result"] as! NSArray
                    var res = ""
                    for item in NewInfoJson {
                        let mp = item as! NSDictionary
                        res += mp["title"] as! String + "\n"
                        res += mp["content"] as! String + "\n\n"
                        break
                    }
                    self.addMessage(info: Message(content: res, avatar: "furobot", isCurrentUser: false))
                    self.saveInfo(content: res, isMe: false)
                 }
            }
            else{
                print("ERROR!")
            }
        }.resume()
    }
    
    func getpoem() {
        let newUrl = ("https://v1.jinrishici.com/rensheng.json").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: newUrl)
        //创建任务并执行
        
        URLSession.shared.dataTask(with: url!) { (data, _, error) in
            if error == nil{
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                 DispatchQueue.main.async {
//                     //得到回调信息
//                    let strJson = String.init(data: data!, encoding: .utf8)
//                        print(strJson!)
                    let content = json["content"] as! String
                    let origin = json["origin"] as! String
                    let author = json["author"] as! String
                    let res = content + "\n标题：" + origin + "\n作者" + author
                    self.addMessage(info: Message(content: res, avatar: "furobot", isCurrentUser: false))
                    self.saveInfo(content: res, isMe: false)
                 }
            }
            else{
                print("ERROR!")
            }
        }.resume()
    }
    
    func getmeum(key:String) {
            let newUrl = ("http://api.tianapi.com/txapi/caipu/index?key=3ee6a0a5ec46c4e9c3ffbcd69943066b&word="+key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: newUrl)
            //创建任务并执行
            
            URLSession.shared.dataTask(with: url!) { (data, _, error) in
                if error == nil{
                    let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                     DispatchQueue.main.async {
    //                     //得到回调信息
    //                    let strJson = String.init(data: data!, encoding: .utf8)
    //                        print(strJson!)
                        let newslist = json["newslist"] as! NSArray
                        
                        let mp = newslist[0] as! NSDictionary
                        let cp_name = mp["cp_name"] as! String
                        let zuofa = mp["zuofa"] as! String
                        let tiaoliao = mp["tiaoliao"] as! String
                        let yuanliao = mp["yuanliao"] as! String
                        let res = cp_name + "\n" + zuofa + "\n调料：" + tiaoliao + "\n原料：" + yuanliao
                        self.addMessage(info: Message(content: res, avatar: "furobot", isCurrentUser: false))
                        self.saveInfo(content: res, isMe: false)
                     }
                }
                else{
                    print("ERROR!")
                }
            }.resume()
        }
    
    
}
