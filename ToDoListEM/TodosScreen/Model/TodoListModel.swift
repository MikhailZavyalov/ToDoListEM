import Foundation

private let requestSucceededKey = "requestSucceededKey"

final class TodoListModel {
    private let networkService: NetworkService
    private let coreDataStorage: CoreDataStorageProtocol

    init(networkService: NetworkService, coreDataStorage: CoreDataStorageProtocol) {
        self.networkService = networkService
        self.coreDataStorage = coreDataStorage
    }

    func loadTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        if wasRequestSucceeded() {
            loadTodosFromCoreData(completion: completion)
        } else {
            loadTodosFromBackend(completion: completion)
        }
    }

    func add(todo: TodoDTO) {
        try? coreDataStorage.add(todo: TodoCoreDataModel(dto: todo))
    }

    func delete(todo: TodoDTO) {
        try? coreDataStorage.delete(todo: TodoCoreDataModel(dto: todo))
    }

    func edit(todo: TodoDTO) {
        try? coreDataStorage.overwrite(todo: TodoCoreDataModel(dto: todo))
    }
}

private extension TodoListModel {
    func loadTodosFromBackend(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        networkService.fetchTodos { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(serverTodos):
                serverTodos.todos.forEach { todo in
                    try? self.coreDataStorage.add(
                        todo: TodoCoreDataModel(
                            id: todo.id,
                            todo: todo.todo,
                            completed: todo.completed,
                            userID: todo.userID
                        )
                    )
                }
                requestSucceededSaveToUserDefaults()
                completion(.success(serverTodos.todos.map(TodoDTO.init)))
            }
        }
    }

    func loadTodosFromCoreData(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        completion(.success(coreDataStorage.todos.map(TodoDTO.init)))
    }
}

private extension TodoListModel {

    func requestSucceededSaveToUserDefaults() {
        UserDefaults.standard.setValue(true, forKey: requestSucceededKey)
    }

    func wasRequestSucceeded() -> Bool {
        UserDefaults.standard.bool(forKey: requestSucceededKey)
    }
}



