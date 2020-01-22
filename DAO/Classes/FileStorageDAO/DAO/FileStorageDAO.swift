//
//  FileStorageDAO.swift
//  DAO
//
//  Created by Sergey Maslov on 22.01.2020
//  Copyright © 2020 Scal.io. All rights reserved.
//

import Foundation

/// `DAO` pattern implementation for `FileStorage`.
open class FileStorageDAO<Model: Entity, FSModel: FileStorageEntry>: DAO<Model> {
    
    // MARK: - Private
    
    /// Translator for current `RLMEntry` and `FSModel` types.
    private let translator: FileStorageTranslator<Model, FSModel>
    private(set) var storage = [FSModel]()


    // MARK: - Public
    
    /// Creates an instance with specified `translator` and `configuration`.
    ///
    /// - Parameters:
    ///   - translator: translator for current `Model` and `FSModel` types.
    public init(translator: FileStorageTranslator<Model, FSModel>) {
        self.translator = translator

        super.init()
    }

    //MARK: - DAO
    
    override open func persist(_ entity: Model) throws {
        let entry = translator.fill(fromEntity: entity)
        if let index = storage.firstIndex(where: { $0.id == entity.entityId } ) {
            storage[index] = entry
        } else {
            storage.append(entry)
        }
        saveData()
    }
    
    
    open override func persist(_ entities: [Model]) throws {
        entities.forEach { entity in
            let entry = translator.fill(fromEntity: entity)
            if let index = storage.firstIndex(where: { $0.id == entity.entityId } ) {
                storage[index] = entry
            } else {
                storage.append(entry)
            }
        }
        saveData()
    }
    
    
    override open func read(_ entityId: String) -> Model? {
        return storage.first(where: {$0.id == entityId } )
            .flatMap { translator.fill(fromEntry: $0) }
    }
    
    
    open override func read() -> [Model] {
        return storage.map(translator.fill(fromEntry:))
    }
    
    
    open override func read(predicatedBy predicate: NSPredicate?) -> [Model] {
        return read(predicatedBy: predicate, orderedBy: nil)
    }
    
    
    open override func read(
        orderedBy field: String?,
        ascending: Bool) -> [Model] {
        
        return read(predicatedBy: nil, orderedBy: field, ascending: ascending)
    }
    
    
    open override func read(
        predicatedBy predicate: NSPredicate?,
        orderedBy field: String?,
        ascending: Bool = true) -> [Model] { // TODO: add predicate and ascending

        guard let predicate = predicate else {
            return storage.map(translator.fill(fromEntry:))
        }

        let array = (storage as NSArray).filtered(using: predicate)
        return (array as? [FSModel] ?? [])
            .map { translator.fill(fromEntry: $0) }
    }
    
    
    override open func erase() throws {
        storage.removeAll()
        saveData()
    }
    
    
    override open func erase(_ entityId: String) throws {
        if let index = storage.firstIndex(where: { $0.id == entityId } ) {
            storage.remove(at: index)
            saveData()
        }
    }
    
}

// MARK: - Private
private extension FileStorageDAO {

    func pathForFileName(_ fileName: String) -> URL? {
        let manager = FileManager.default
        let paths = manager.urls(for: .cachesDirectory, in:.userDomainMask)
        return paths.first?.appendingPathComponent(fileName, isDirectory: false)
    }

    var fileName: String {
        return String(describing: type(of: self))
    }

    func loadData() {
        guard let file = pathForFileName(fileName)?.path,
            let storage = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? [FSModel] else {
                self.storage = []
                return
        }

        self.storage = storage
    }

    private func saveData() {
        guard let file = pathForFileName(fileName) else { return }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: storage)
        try? encodedData.write(to: file)
    }


    func write(_ entry: FSModel) throws {
        if let index = storage.firstIndex(where: { $0.id == entry.id } ) {
            storage[index] = entry
        } else {
            storage.append(entry)
        }
        saveData()
    }

    func write(_ entries: [FSModel]) throws {
        let newEntries = entries.filter { entry in storage.contains(where: { $0.id == entry.id }) }
        storage.append(contentsOf: newEntries)
        saveData()
    }

    func readFromFileStorage(_ entryId: String) throws -> FSModel? {
        return storage.first(where: { $0.id == entryId} )
    }


    func readFromFileStorage(_ predicate: NSPredicate? = nil) throws -> [FSModel] {
        guard let predicate = predicate else {
            return storage
        }

        let array = (storage as NSArray).filtered(using: predicate)
        return (array as? [FSModel] ?? [])
    }


    func delete(_ entry: FSModel) throws {
        try erase(entry.id)
    }


    func delete(_ entries: [FSModel]) throws {
        try entries.forEach {
            try erase($0.id)
        }
    }
}
