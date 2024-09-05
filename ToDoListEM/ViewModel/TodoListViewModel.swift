
import Foundation
import CoreData

final class TodoListViewModel {
    @Observable
    var todosModels: [TodoListTableViewCellModel] = []
    var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }() 

    private let model: TodoListModel

    init(model: TodoListModel) {
        self.model = model
    }

    func loadData() {
        model.loadTodos { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }

                switch result {
                case let .success(models):
                    self.todosModels = models.map(TodoListTableViewCellModel.init(todoDTO:))

                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}

private extension TodoListTableViewCellModel {
    init(todoDTO: TodoDTO) {
        name = todoDTO.todo
        status = todoDTO.completed

    }
}
