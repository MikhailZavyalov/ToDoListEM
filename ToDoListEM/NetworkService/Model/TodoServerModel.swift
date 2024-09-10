
import Foundation

struct TodosServerModel: Decodable {
    let todos: [TodoServerModel]
}

struct TodoServerModel: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
