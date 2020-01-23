//
//  FSMessageTranslator.swift
//  DAO_Example
//
//  Created by Sergey Maslov on 23.01.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import DAO

final class FSMessageTranslator: FileStorageTranslator<Message, FSMessage> {
    
    required init() {}

    override func fill(fromEntity: Message) -> FSMessage {
        return FSMessage(id: fromEntity.entityId,
                         text: fromEntity.text)
    }

    override func fill(fromEntry: FSMessage) -> Message {
        return Message(entityId: fromEntry.id,
                       text: fromEntry.text)
    }

}
