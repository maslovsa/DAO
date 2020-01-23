//
//  FSEntity.swift
//  DAO
//
//  Created by Sergey Maslov on 22.01.2020
//  Copyright © 2020 Scal.io. All rights reserved.
//

import DAO

struct FSEntity: FileStorageEntry {
    let id: String

    static func entityWithId(_ entityId: String) -> FSEntity {
        return FSEntity(id: entityId)
    }
    
}
