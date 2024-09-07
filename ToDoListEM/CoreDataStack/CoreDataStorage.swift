import Foundation
import UIKit
import CoreData

protocol CoreDataStorageProtocol: NSObject {
    var todos: [TodoCoreDataModel] { get }
    func add(todo: TodoCoreDataModel) throws
    func delete(todo: TodoCoreDataModel) throws
    func overwrite(todo: TodoCoreDataModel) throws
}

private enum CoreDataStorageError: Error {
    case entityWithSpecifiedIdNotFound
}

final class CoreDataStorage: NSObject, CoreDataStorageProtocol {
    static let shared = CoreDataStorage()

    var todos: [TodoCoreDataModel] = []

    private let context: NSManagedObjectContext

    private convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }

    private init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        try updateData()
    }

    func add(todo: TodoCoreDataModel) throws {
        let todoMO = TodoManagedObject(context: context)
        todoMO.id = Int64(todo.id)
        todoMO.todo = todo.todo
        todoMO.completed = todo.completed
        todoMO.userID = Int64(todo.userID)

        try context.save()
        try updateData()
    }

    func delete(todo: TodoCoreDataModel) throws {
        let todos = try fetchTodos()
        guard let todoMO = todos.first(where: {
            $0.id == todo.id
        }) else {
            throw CoreDataStorageError.entityWithSpecifiedIdNotFound
        }
        context.delete(todoMO)
        try updateData()
    }

    func overwrite(todo: TodoCoreDataModel) throws {
        let todos = try fetchTodos()
        guard let todoMO = todos.first(where: {
            $0.id == todo.id
        }) else {
            throw CoreDataStorageError.entityWithSpecifiedIdNotFound
        }
        todoMO.id = Int64(todo.id)
        todoMO.todo = todo.todo
        todoMO.completed = todo.completed
        todoMO.userID = Int64(todo.userID)

        try context.save()
        try updateData()
    }

    private func updateData() throws {
        todos = try fetchTodos().map(TodoCoreDataModel.init(managedObject:))
    }

    private func fetchTodos() throws -> [TodoManagedObject] {
        let fetchRequest = TodoManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoManagedObject.completed, ascending: true)
        ]
        return try context.fetch(fetchRequest)
    }
}
