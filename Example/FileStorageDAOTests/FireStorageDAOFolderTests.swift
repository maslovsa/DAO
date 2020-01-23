//
//  FireStorageDAOFolderTests.swift
//  FileStorageDAOTests
//
//  Created by Sergey Maslov on 23.01.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import DAO
@testable import DAO_Example

final class FireStorageDAOFolderTests: XCTestCase {

    private var dao: FileStorageDAO<Folder, FSFolder>!

    override func setUp() {
        super.setUp()

        let messageTranslator = FSMessageTranslator()
        dao = FileStorageDAO(translator: FSFolderTranslator(messageTranslator: messageTranslator))
    }

    override func tearDown() {
        super.tearDown()

        try! dao.erase()
        dao = nil
    }

    func testCascadeErase() {
        let message = Message(entityId: "V.message", text: "V.message.text")
        let folder = Folder(entityId: "V", name: "Delete", messages: [message])

        XCTAssertNoThrow(try dao.persist(folder), "Persist folder is failed")
        XCTAssertEqual(message,  dao.read("V")?.messages.first)
    }

}
