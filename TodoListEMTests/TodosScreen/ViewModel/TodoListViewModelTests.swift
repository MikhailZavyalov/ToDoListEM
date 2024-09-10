//
//  TodoListViewModelTests.swift
//  ToDoListEMTests
//
//  Created by Мария Авдеева on 08.09.2024.
//

import Foundation
import XCTest
@testable import ToDoListEM

final class TodoListViewModelTests: XCTestCase {
    var sut: TodoListViewModel! //system under test
    var modelMock: TodoListModelProtocolMock!

    override func setUp() {
        modelMock = TodoListModelProtocolMock()
        sut = TodoListViewModel(model: modelMock)
    }

    override func tearDown() {
        modelMock = nil
        sut = nil
    }

    func testAddTodo() {
        // given

        let expectedName = "Name"
        let expectedCompleted = true
        let expectedDescription = "Description"
        let expectedStart = Date.now
        let expectedEnd = Date.now

        let newTodoModel = NewTodoModel(
            name: expectedName,
            completed: expectedCompleted,
            description: expectedDescription,
            start: expectedStart,
            end: expectedEnd
        )

        // when
        sut.addTodo(newTodo: newTodoModel)

        // then
        XCTAssertEqual(sut.todoDTOs.count, 1)
        XCTAssertEqual(sut.todosModels.count, 1)
        XCTAssertEqual(modelMock.addCallCount, 1)

        let todoDTO = sut.todoDTOs[0]
        XCTAssertEqual(todoDTO.todo, expectedName)
        XCTAssertEqual(todoDTO.completed, expectedCompleted)
        XCTAssertEqual(todoDTO.todoDescription, expectedDescription)
        XCTAssertEqual(todoDTO.startDate, expectedStart)
        XCTAssertEqual(todoDTO.endDate, expectedEnd)
    }
}
