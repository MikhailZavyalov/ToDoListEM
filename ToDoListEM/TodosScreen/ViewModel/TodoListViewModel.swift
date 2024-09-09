
import Foundation

final class TodoListViewModel {

    var openTodosModels: [TodoListTableViewCellModel] = []

    var closedTodosModels: [TodoListTableViewCellModel] = []

    @Observable
    var filteredTodosModels: [TodoListTableViewCellModel] = []

    @Observable
    var todosModels: [TodoListTableViewCellModel] = []
    private(set) var todoDTOs: [TodoDTO] = [] {
        didSet {
            todosModels = todoDTOs.map(TodoListTableViewCellModel.init(todoDTO:))
            
            if filteredTodosModels.isEmpty {
                filteredTodosModels = todoDTOs.map(TodoListTableViewCellModel.init(todoDTO:))
            } else { return }

            openTodosModels = todoDTOs.map(TodoListTableViewCellModel.init(todoDTO:)).filter({ $0.status == false })

            closedTodosModels = todoDTOs.map(TodoListTableViewCellModel.init(todoDTO:)).filter({ $0.status == true })
        }
    }

    private let model: TodoListModelProtocol

    init(model: TodoListModelProtocol) {
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

    func addTodo(newTodo: NewTodoModel) {
        let todoDTO = TodoDTO(
            id: Int.random(in: 0...1_000_000),
            todo: newTodo.name,
            todoDescription: newTodo.description,
            startDate: newTodo.start,
            endDate: newTodo.end,
            completed: newTodo.completed,
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

    func editTodo(newTodo: TodoDTO) {
        if let todoIndex = todoDTOs.firstIndex(where: { $0.id == newTodo.id }) {
            todoDTOs[todoIndex] = newTodo
        }
        model.edit(todo: newTodo)
    }
}

private extension TodoListTableViewCellModel {
    init(todoDTO: TodoDTO) {
        name = todoDTO.todo
        status = todoDTO.completed
        description = todoDTO.todoDescription
        timeText =
        if let startDate = todoDTO.startDate, let endDate = todoDTO.endDate {
            dateFormatter.string(from: startDate) + " - " + dateFormatter.string(from: endDate)
        } else {
            ""
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

extension TodoListViewModel {
    func filterByOpenTodos() -> [TodoListTableViewCellModel] {
        filteredTodosModels = openTodosModels
        return filteredTodosModels
    }

    func filterByClosedTodos() -> [TodoListTableViewCellModel] {
        filteredTodosModels = closedTodosModels
        return filteredTodosModels
    }
}
