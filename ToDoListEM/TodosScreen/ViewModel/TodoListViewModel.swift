
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

    func addTodo(name: String, completed: Bool, description: String, time: String) {
        let todoDTO = TodoDTO(
            id: Int.random(in: 0...1_000_000),
            todo: name,
            todoDescription: description,
            time: time,
            completed: completed,
            userID: 0
        )
        todoDTOs.insert(todoDTO, at: 0)
        model.add(todo: todoDTO)
    }

    func deleteTodo(at indexPath: IndexPath) {
        let todo = todoDTOs[indexPath.row]
        todoDTOs.remove(at: indexPath.row)
        model.delete(todo: todo)
        print("🍎", #function, todo)
    }

    func editTodo(at indexPath: IndexPath, name: String, description: String, time: String, completed: Bool) {
        var todo = todoDTOs[indexPath.row]
        todo.todo = name
        todo.todoDescription = description
        todo.time = time
        todo.completed = completed
        todo.userID = 0
        todoDTOs[indexPath.row] = todo
        model.edit(todo: todo)
    }
}

private extension TodoListTableViewCellModel {
    init(todoDTO: TodoDTO) {
        name = todoDTO.todo
        status = todoDTO.completed
        description = todoDTO.todoDescription
        date = todoDTO.time
    }
}
