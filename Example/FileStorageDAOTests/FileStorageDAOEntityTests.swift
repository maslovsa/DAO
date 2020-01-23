//
//  FileStorageDAOEntityTests.swift
//  FileStorageDAOTests
//
//  Created by Sergey Maslov on 22.01.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import DAO
@testable import DAO_Example

final class FileStorageDAOEntityTests: XCTestCase {

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
        let entityA = Entity(entityId: "42")
        let entityB = Entity(entityId: "54")

        XCTAssertNoThrow(try dao.persist(entityA), "Persist is failed")
        XCTAssertNoThrow(try dao.persist(entityB), "Persist is failed")
        XCTAssertEqual(entityA, dao.read("42"), "Read is failed")
        XCTAssertEqual(entityB, dao.read("54"), "Read is failed")
    }


    func testAsyncReadById() {
        let entity = Entity(entityId: "2_back")
        let exp = expectation(description: "")

        DispatchQueue.global().async {
            XCTAssertNotNil(try? self.dao.persist(entity), "Async read by id is failed")

            DispatchQueue.global().async {
                XCTAssertEqual(self.dao.read("2_back")?.entityId, entity.entityId, "Async read by id is failed")
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 5)
    }

    func testPersist() {
        let entity = Entity(entityId: "1")

        XCTAssertNoThrow(try dao.persist(entity), "Saving entity is failed")
        XCTAssert(true)
    }

    func testPersistAll() {
        let firstEntity = Entity(entityId: "2")
        let secondEntity = Entity(entityId: "3")

        XCTAssertNoThrow(try dao.persist([firstEntity, secondEntity]), "Saving entities is failed")
    }

    func testAsyncPersist() {
        let entity = Entity(entityId: "1_back")
        let exp = expectation(description: "")

        DispatchQueue.global().async {
            XCTAssertNotNil(try? self.dao.persist(entity), "Saving entity in background is failed")
            exp.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

    func testEraseById() {
        let entity = Entity(entityId: "3")

        XCTAssertNoThrow(try dao.persist(entity), "Erase is failed")
        XCTAssertNoThrow(try dao.erase("3"), "Erase is failed")
        XCTAssertNil(dao.read("3"))
    }

    func testAsyncEraseById() {
        let entity = Entity(entityId: "2_back")

        XCTAssertNoThrow(try dao.persist(entity), "Async erase by id is failed")

        let exp = expectation(description: "")

        DispatchQueue.global().async {
            XCTAssertNotNil(try? self.dao.erase("2_back"), "Async erase by id is failed")
            exp.fulfill()
        }

        waitForExpectations(timeout: 5)
    }

}
