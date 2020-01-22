//
//  FileStorageDAOTests.swift
//  FileStorageDAOTests
//
//  Created by Sergey Maslov on 22.01.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import DAO
@testable import DAO_Example

final class FileStorageDAOTests: XCTestCase {

    private var dao: FileStorageDAO<Entity, FSEntity>!

    override func setUp() {
        super.setUp()

        dao = FileStorageDAO(translator: FSEntityTranslator())
    }

    override func tearDown() {
        super.tearDown()

        try! dao.erase()
        dao = nil
    }


    func testReadById() {
        let entity = Entity(entityId: "2")

        XCTAssertNoThrow(try dao.persist(entity), "Persist is failed")
        XCTAssertEqual(entity, dao.read("2"), "Read is failed")
    }

}
