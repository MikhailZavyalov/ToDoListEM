
import Foundation

struct TodosDTO: Decodable {
    let todos: [TodoDTO]
    let total, skip, limit: Int
}

struct TodoDTO: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
