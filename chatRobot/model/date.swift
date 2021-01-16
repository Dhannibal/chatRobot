//
//  date.swift
//  Hello SwiftUI
//
//  Created by hannibal lecter on 2020/6/26.
//  Copyright © 2020 com.cuit.ygl. All rights reserved.
//

import Foundation
struct Message : Hashable, Identifiable{
    var id = UUID()
    var content: String
    var avatar: String = "robot"
    var isCurrentUser: Bool = true
}
