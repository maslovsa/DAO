//
//  FSEntityTranslator.swift
//  DAO
//
//  Created by Sergey Maslov on 22.01.2020
//  Copyright © 2020 Scal.io. All rights reserved.
//

import DAO

final class FSEntityTranslator: FileStorageTranslator<Entity, FSEntity> {
    
    required init() {}

    override func fill(fromEntity: Entity) -> FSEntity {
        return FSEntity.entityWithId(fromEntity.entityId)
    }

    override func fill(fromEntry: FSEntity) -> Entity {
        return Entity(entityId: fromEntry.id)        
    }
    
}
