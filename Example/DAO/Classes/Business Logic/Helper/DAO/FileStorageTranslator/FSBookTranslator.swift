//
//  FSBookTranslator.swift
//  DAO_Example
//
//  Created by Sergey Maslov on 23.01.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import DAO

final class FSBookTranslator: FileStorageTranslator<Book, FSBook> {

    required init() {}

    override func fill(fromEntity: Book) -> FSBook {
        return FSBook(id: fromEntity.entityId,
                      name: fromEntity.name,
                      authors: fromEntity.authors,
                      dates: fromEntity.dates,
                      pages: fromEntity.pages,
                      attachments: fromEntity.attachments)
    }

    override func fill(fromEntry: FSBook) -> Book {
        return Book(entityId: fromEntry.id,
                    name: fromEntry.name,
                    authors: fromEntry.authors,
                    dates: fromEntry.dates,
                    pages: fromEntry.pages,
                    attachments: fromEntry.attachments)
    }

}

