//
//  FileStorageEntry.swift
//  DAO
//
//  Created by Sergey Maslov on 22.01.2020
//  Copyright © 2020 Scal.io. All rights reserved.
//


import Foundation

/// Parent protocol for `FileStorage` entries.
public protocol FileStorageEntry: Codable {
    
    /// Entry identifier. Must be unique.
    var id: String { get }

}
