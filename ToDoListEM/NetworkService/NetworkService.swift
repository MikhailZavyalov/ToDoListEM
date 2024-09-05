import Foundation

protocol NetworkService {
    func fetchTodos(completion: @escaping (Result<TodosDTO, Error>) -> Void)
}

final class NetworkServiceImplementation: NetworkService {
    static let todosURL = URL(string: "https://dummyjson.com/todos")

    enum NetworkError: Error {
        case httpError(Int)
        case noDataReceived
    }

    func fetchTodos(completion: @escaping (Result<TodosDTO, Error>) -> Void) {
        guard let todosURL = NetworkServiceImplementation.todosURL else { return }
        fetchData(url: todosURL, completion: completion)
    }

    private func fetchData<DTO: Decodable>(url: URL, completion: @escaping (Result<DTO, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                return completion(.failure(error))
            }

            if let httpResponse = response as? HTTPURLResponse,
                !(200..<300).contains(httpResponse.statusCode) {
                return completion(.failure(NetworkError.httpError(httpResponse.statusCode)))
            }

            guard let data else {
                return completion(.failure(NetworkError.noDataReceived))
            }

            do {
                let dto = try JSONDecoder().decode(DTO.self, from: data)
                completion(.success(dto))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

