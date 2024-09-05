import UIKit
import CoreData

enum TodoStoreError: Error {
    case decodingErrorInvalidTodos
}

struct TodoStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TodoStoreDelegate: AnyObject {
    func store(
        _ store: TodoStore,
        didUpdate update: TodoStoreUpdate
    )
}

final class TodoStore: NSObject {
    private let context: NSManagedObjectContext
    private let fetchedResultsController: NSFetchedResultsController<TodoModel>

    weak var delegate: TodoStoreDelegate?
    private var insertedIndexes: IndexSet = []
    private var deletedIndexes: IndexSet = []
    private var updatedIndexes: IndexSet = []
    private var movedIndexes: Set<TodoStoreUpdate.Move> = []

    var emojiMixes: [TodoListTableViewCellModel] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let todos = try? objects.map({ try self.todos(from: $0) })
        else { return [] }
        return todos
    }

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        let fetchRequest = TodoModel.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoModel.todoName, ascending: true)
        ]

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoModel.description, ascending: true)
        ]

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoModel.todoTime, ascending: true)
        ]

        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TodoModel.todoTime, ascending: true)
        ]

        fetchedResultsController = NSFetchedResultsController<TodoModel>(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }

    // сохраняем контекст
    func addNewEmojiMix(_ todo: TodoListTableViewCellModel) throws {
        let todoModelCoreData = TodoModel(context: context)
        todoModelCoreData.todoName = todo.name
        todoModelCoreData.todoDescription = todo.description
        todoModelCoreData.todoStatus = todo.status
        todoModelCoreData.todoTime = todo.date
        try context.save()
    }

    // берём микс из БД
    private func todos(from todoCoreData: TodoModel) throws -> TodoListTableViewCellModel {
        guard let todos = emojiMixCoreData.emojis else {
           throw EmojiMixStoreError.decodingErrorInvalidEmojies
        }

        guard let colorHex = emojiMixCoreData.colorHex else {
            throw EmojiMixStoreError.decodingErrorInvalidColorHex
        }

        return EmojiMix(
            emojis: emojies,
            backgroundColor: uiColorMarshalling.color(from: colorHex)
        )
    }
}

extension TodoStore: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TodoStoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: deletedIndexes,
                updatedIndexes: updatedIndexes,
                movedIndexes: movedIndexes
            )
        )
        insertedIndexes.removeAll()
        deletedIndexes.removeAll()
        updatedIndexes.removeAll()
        movedIndexes.removeAll()
    }
}

