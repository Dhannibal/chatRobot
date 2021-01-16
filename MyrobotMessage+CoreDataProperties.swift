//
//  MyrobotMessage+CoreDataProperties.swift
//  chatRobot
//
//  Created by hannibal lecter on 2020/6/27.
//  Copyright © 2020 com.cuit.robot. All rights reserved.
//
//

import Foundation
import CoreData


extension MyrobotMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyrobotMessage> {
        return NSFetchRequest<MyrobotMessage>(entityName: "MyrobotMessage")
    }

    @NSManaged public var content: String?
    @NSManaged public var isMe: Bool
    @NSManaged public var time: Date?
    @NSManaged public var id: UUID?

}
