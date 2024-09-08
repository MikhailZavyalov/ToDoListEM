
import Foundation

struct TodoDTO {
    var id: Int
    var todo: String
    var todoDescription: String
    var time: String
    var completed: Bool
    var userID: Int
}

extension TodoDTO {
    init(_ model: TodoServerModel) {
        id = model.id
        todo = model.todo
        todoDescription = ""
        time = ""
        completed = model.completed
        userID = model.userID
    }

    init(_ model: TodoCoreDataModel) {
        id = model.id
        todo = model.todo
        todoDescription = model.todoDescription
        time = model.time
        completed = model.completed
        userID = model.userID
    }
}
