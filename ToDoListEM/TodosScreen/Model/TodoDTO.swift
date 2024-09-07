
import Foundation

struct TodoDTO {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int
}

extension TodoDTO {
    init(_ model: TodoServerModel) {
        id = model.id
        todo = model.todo
        completed = model.completed
        userID = model.userID
    }

    init(_ model: TodoCoreDataModel) {
        id = model.id
        todo = model.todo
        completed = model.completed
        userID = model.userID
    }
}
