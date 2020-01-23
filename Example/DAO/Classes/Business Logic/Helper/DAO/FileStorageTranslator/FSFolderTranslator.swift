//
//  FSFolderTranslator.swift
//  DAO_Example
//
//  Created by Sergey Maslov on 23.01.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import DAO

final class FSFolderTranslator: FileStorageTranslator<Folder, FSFolder> {
    private let messageTranslator: FSMessageTranslator

    required init(messageTranslator: FSMessageTranslator) {
        self.messageTranslator = messageTranslator
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    override func fill(fromEntity: Folder) -> FSFolder {
        let messages = fromEntity.messages.map(messageTranslator.fill(fromEntity:))
        return FSFolder(id: fromEntity.entityId,
                        name: fromEntity.name,
                        messages: messages)
    }

    override func fill(fromEntry: FSFolder) -> Folder {
        let messages = fromEntry.messages.map(messageTranslator.fill(fromEntry:))
        return Folder(entityId: fromEntry.id,
                      name: fromEntry.name,
                      messages: messages)
    }

}
