
import Foundation

struct TodoCoreDataModel {
    let id: Int
    let todo: String
    let todoDescription: String?
    let startDate: Date?
    let endDate: Date?
    let completed: Bool
    let userID: Int
}

extension TodoCoreDataModel {
    init(managedObject: TodoManagedObject) {
        self.init(
            id: Int(managedObject.id),
            todo: managedObject.todo ?? "",
            todoDescription: managedObject.todoDescription,
            startDate: managedObject.startDate,
            endDate: managedObject.endDate,
            completed: managedObject.completed,
            userID: Int(managedObject.userID)
        )
    }

    init(dto: TodoDTO) {
        self.init(
            id: dto.id,
            todo: dto.todo,
            todoDescription: dto.todoDescription,
            startDate: dto.startDate,
            endDate: dto.endDate,
            completed: dto.completed,
            userID: dto.userID
        )
    }
}
