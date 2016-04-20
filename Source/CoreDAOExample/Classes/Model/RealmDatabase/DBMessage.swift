//
//  DBMessage.swift
//  CoreDAO
//
//  Created by Igor Bulyga on 09.02.16.
//  Copyright © 2016 RedMadRobot LLC. All rights reserved.
//

import CoreDAO

class DBMessage: DBEntity {
    
    dynamic var text: String?
    
    class func messageWithId(entityId: String, text: String?) -> DBMessage {
        let message = DBMessage()
        message.entryId = entityId
        message.text = text
        return message
    }
}