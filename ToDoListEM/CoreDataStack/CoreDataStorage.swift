import Foundation
import UIKit
import CoreData

/// @mockable
protocol CoreDataStorageProtocol: NSObject {
    func getTodos() -> [TodoCoreDataModel]
    func add(todo: TodoCoreDataModel)
    func delete(todo: TodoCoreDataModel)
    func overwrite(todo: TodoCoreDataModel)
}

final class CoreDataStorage: NSObject, CoreDataStorageProtocol {
    static let shared = CoreDataStorage()

    private let viewContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    private let backgroundQueue = DispatchQueue(label: "todoListEM.CoreDataStorage")

    private convenience override init() {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        try! self.init(viewContext: viewContext, backgroundContext: backgroundContext)
    }

    private init(viewContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) throws {
        self.viewContext = viewContext
        self.backgroundContext = backgroundContext
        super.init()
    }

    func getTodos() -> [TodoCoreDataModel] {
        (try? fetchTodos(context: viewContext).map(TodoCoreDataModel.init(managedObject:))) ?? []
    }

    func add(todo: TodoCoreDataModel) {
        backgroundQueue.async { [weak self] in
            guard let self else { return }
            let todoMO = TodoManagedObject(context: backgroundContext)
            todoMO.id = Int64(todo.id)
            todoMO.todo = todo.todo
            todoMO.completed = todo.completed
            todoMO.userID = Int64(todo.userID)
            todoMO.todoDescription = todo.todoDescription
            todoMO.startDate = todo.startDate
            todoMO.endDate = todo.endDate

            try? backgroundContext.save()
        }
    }

    func delete(todo: TodoCoreDataModel) {
        backgroundQueue.async { [weak self] in
            guard let self else { return }
            let todos = try? fetchTodos(context: backgroundContext)
            guard let todoMO = todos?.first(where: {
                $0.id == todo.id
            }) else {
                return
            }
            backgroundContext.delete(todoMO)
            try? backgroundContext.save()
        }
    }

    func overwrite(todo: TodoCoreDataModel) {
        backgroundQueue.async { [weak self] in
            guard let self else { return }
            let todos = try? fetchTodos(context: backgroundContext)
            guard let todoMO = todos?.first(where: {
                $0.id == todo.id
            }) else {
                return
            }
            todoMO.id = Int64(todo.id)
            todoMO.todo = todo.todo
            todoMO.completed = todo.completed
            todoMO.userID = Int64(todo.userID)
            todoMO.todoDescription = todo.todoDescription
            todoMO.startDate = todo.startDate
            todoMO.endDate = todo.endDate

            try? backgroundContext.save()
        }
    }

    private func fetchTodos(context: NSManagedObjectContext) throws -> [TodoManagedObject] {
        let fetchRequest = TodoManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoManagedObject.completed, ascending: true)
        ]
        return try context.fetch(fetchRequest)
    }
}
