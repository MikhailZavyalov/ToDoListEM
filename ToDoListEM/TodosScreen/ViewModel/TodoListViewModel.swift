
import Foundation

final class TodoListViewModel {
    @Observable
    var todosModels: [TodoListTableViewCellModel] = []
    private var todoDTOs: [TodoDTO] = [] {
        didSet {
            todosModels = todoDTOs.map(TodoListTableViewCellModel.init(todoDTO:))
        }
    }

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
                    self.todoDTOs = models

                case let .failure(error):
                    print(error)
                }
            }
        }
    }

    func addTodo(name: String, description: String) {
        let todoDTO = TodoDTO(
            id: Int.random(in: 0...1_000_000),
            todo: name,
            completed: <#T##Bool#>,
            userID: 0
        )
        todoDTOs.insert(todoDTO, at: 0)
        model.add(todo: todoDTO)
    }

    func deleteTodo(at indexPath: IndexPath) {
        let todo = todoDTOs[indexPath.row]
        todoDTOs.remove(at: indexPath.row)
        model.delete(todo: todo)
    }

    func editTodo(at indexPath: IndexPath, name: String, description: String) {
        var todo = todoDTOs[indexPath.row]
        // todo.cdd = descr
        // todo.dv = scsdc.....
        todoDTOs[indexPath.row] = todo
        model.edit(todo: todo)
    }
}

private extension TodoListTableViewCellModel {
    init(todoDTO: TodoDTO) {
        name = todoDTO.todo
        status = todoDTO.completed
    }
}
