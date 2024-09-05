import Foundation

final class TodoListModel {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func loadTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        networkService.fetchTodos { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(todosDTO):
                completion(.success(todosDTO.todos))
            }
        }
    }
}

