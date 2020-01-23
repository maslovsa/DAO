//
//  FileStorageEntry.swift
//  DAO
//
//  Created by Sergey Maslov on 22.01.2020
//  Copyright © 2020 Scal.io. All rights reserved.
//


import Foundation

/// Parent protocol for `FileStorage` entries.
public protocol FileStorageEntry: Codable, Hashable {
    
    /// Entry identifier. Must be unique.
    var id: String { get }

}

public extension FileStorageEntry {

    /// Hash value for compare entities.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

