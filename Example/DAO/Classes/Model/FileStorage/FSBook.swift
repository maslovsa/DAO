//
//  FSBook.swift
//  DAO_Example
//
//  Created by Sergey Maslov on 23.01.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import DAO

struct FSBook: FileStorageEntry {
    var id: String
    let name: String
    let authors: [String]
    let dates: [Date]
    let pages: [Int]
    let attachments: [Data]
}
