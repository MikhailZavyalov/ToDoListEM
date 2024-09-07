
import Foundation

struct TodoCoreDataModel {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int
}

extension TodoCoreDataModel {
    init(managedObject: TodoManagedObject) {
        self.init(
            id: Int(managedObject.id),
            todo: managedObject.todo ?? "",
            completed: managedObject.completed,
            userID: Int(managedObject.userID)
        )
    }

    init(dto: TodoDTO) {
        self.init(
            id: dto.id,
            todo: dto.todo,
            completed: dto.completed,
            userID: dto.userID
        )
    }
}
