//
//import Foundation
//
//class CoreDataStorageProtocolMock: CoreDataStorageProtocol, NSObject {
//    init() { }
//
//
//    private(set) var getTodosCallCount = 0
//    var getTodosHandler: (() -> ([TodoCoreDataModel]))?
//    func getTodos() -> [TodoCoreDataModel] {
//        getTodosCallCount += 1
//        if let getTodosHandler = getTodosHandler {
//            return getTodosHandler()
//        }
//        return [TodoCoreDataModel]()
//    }
//
//    private(set) var addCallCount = 0
//    var addHandler: ((TodoCoreDataModel) -> ())?
//    func add(todo: TodoCoreDataModel)  {
//        addCallCount += 1
//        if let addHandler = addHandler {
//            addHandler(todo)
//        }
//
//    }
//
//    private(set) var deleteCallCount = 0
//    var deleteHandler: ((TodoCoreDataModel) -> ())?
//    func delete(todo: TodoCoreDataModel)  {
//        deleteCallCount += 1
//        if let deleteHandler = deleteHandler {
//            deleteHandler(todo)
//        }
//
//    }
//
//    private(set) var overwriteCallCount = 0
//    var overwriteHandler: ((TodoCoreDataModel) -> ())?
//    func overwrite(todo: TodoCoreDataModel)  {
//        overwriteCallCount += 1
//        if let overwriteHandler = overwriteHandler {
//            overwriteHandler(todo)
//        }
//
//    }
//}
//
