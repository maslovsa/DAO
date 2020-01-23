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
    private(set) var syncArray = SynchronizedArray<FSModel>()


    // MARK: - Public
    
    /// Creates an instance with specified `translator` and `configuration`.
    ///
    /// - Parameters:
    ///   - translator: translator for current `Model` and `FSModel` types.
    public init(translator: FileStorageTranslator<Model, FSModel>) {
        self.translator = translator
        super.init()
        loadData()
    }

    //MARK: - DAO
    
    override open func persist(_ entity: Model) throws {
        let entry = translator.fill(fromEntity: entity)
        if let index = syncArray.firstIndex(where: { $0.id == entity.entityId } ) {
            syncArray[index] = entry
        } else {
            syncArray.append(entry)
        }
        saveData()
    }
    
    
    open override func persist(_ entities: [Model]) throws {
        entities.forEach { entity in
            let entry = translator.fill(fromEntity: entity)
            if let index = syncArray.firstIndex(where: { $0.id == entity.entityId } ) {
                syncArray[index] = entry
            } else {
                syncArray.append(entry)
            }
        }
        saveData()
    }

    override open func read(_ entityId: String) -> Model? {
        return syncArray.first(where: {$0.id == entityId } )
            .flatMap { translator.fill(fromEntry: $0) }
    }
    
    
    open override func read() -> [Model] {
        return syncArray.map(translator.fill(fromEntry:))
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
            return syncArray.map(translator.fill(fromEntry:))
        }

        let array = (syncArray.getAll() as NSArray).filtered(using: predicate)
        return (array as? [FSModel] ?? [])
            .map { translator.fill(fromEntry: $0) }
    }

    override open func erase() throws {
        syncArray.removeAll()
        saveData()
    }

    override open func erase(_ entityId: String) throws {
        if let index = syncArray.firstIndex(where: { $0.id == entityId } ) {
            syncArray.remove(at: index)
            saveData()
        }
    }

}

// MARK: - Private
private extension FileStorageDAO {

    var fileNameRaw: String {
        return String(describing: type(of: self))
    }

    var fileName: String {
        return (fileNameRaw.components(separatedBy: NSCharacterSet.alphanumerics.inverted) as NSArray).componentsJoined(by: "") + ".fs"
    }

    func pathForFileName(_ fileName: String) -> URL? {
        let manager = FileManager.default
        let paths = manager.urls(for: .cachesDirectory, in:.userDomainMask)
        return paths.first?.appendingPathComponent(fileName, isDirectory: false)
    }
}

// MARK: - Private
private extension FileStorageDAO {

    func loadData() {
        guard let url = pathForFileName(fileName),
            let data = try? Data(contentsOf: url),
            let models = try? JSONDecoder().decode(FSModel.self, from: data) as? [FSModel] else {
//            let models = NSKeyedUnarchiver.unarchivedObject(ofClasses: [Array<FSModel>.self], from: data) as? [FSModel] else {
                self.syncArray.removeAll()
                return
        }

        self.syncArray.replace(with: models)
    }

    private func saveData() {
        guard let file = pathForFileName(fileName),
            let encodedData = try? JSONEncoder().encode(syncArray.getAll()) else {
                return
        }

        try? encodedData.write(to: file)
    }


    func write(_ entry: FSModel) throws {
        if let index = syncArray.firstIndex(where: { $0.id == entry.id } ) {
            syncArray[index] = entry
        } else {
            syncArray.append(entry)
        }
        saveData()
    }

    func write(_ entries: [FSModel]) throws {
        let newEntries = entries.filter { entry in syncArray.contains(where: { $0.id == entry.id }) }
        syncArray.append(newEntries)
        saveData()
    }

    func readFromFilemodels(_ entryId: String) throws -> FSModel? {
        return syncArray.first(where: { $0.id == entryId} )
    }


    func readFromFilemodels(_ predicate: NSPredicate? = nil) throws -> [FSModel] {
        guard let predicate = predicate else {
            return syncArray.getAll()
        }

        let array = (syncArray.getAll() as NSArray).filtered(using: predicate)
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
