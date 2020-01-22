//
//  FileStorageTranslator.swift
//  DAO
//
//  Created by Sergey Maslov on 22.01.2020
//  Copyright © 2020 Scal.io. All rights reserved.
//

import Foundation

open class FileStorageTranslator<Model: Entity, FSModel: FileStorageEntry> {
    
    public required init() {}
    
    
    open func fill(fromEntity: Model) -> FSModel {
        fatalError("Abstract method")
    }


    open func fill(fromEntry: FSModel) -> Model {
        fatalError("Abstract method")
    }

}
