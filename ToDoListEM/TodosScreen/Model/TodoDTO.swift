
import Foundation

struct TodoDTO {
    let id: Int
    let todo: String
    let todoDescription: String?
    let startDate: Date?
    let endDate: Date?
    let completed: Bool
    let userID: Int
}

extension TodoDTO {
    init(_ model: TodoServerModel) {
        id = model.id
        todo = model.todo
        todoDescription = nil
        startDate = nil
        endDate = nil
        completed = model.completed
        userID = model.userID
    }

    init(_ model: TodoCoreDataModel) {
        id = model.id
        todo = model.todo
        todoDescription = model.todoDescription
        startDate = model.startDate
        endDate = model.endDate
        completed = model.completed
        userID = model.userID
    }
}
