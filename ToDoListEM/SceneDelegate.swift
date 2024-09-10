//
//  SceneDelegate.swift
//  ToDoListEM
//
//  Created by Мария Авдеева on 03.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TodoListViewController(
            viewModel: TodoListViewModel(
                model: TodoListModel(
                    networkService: NetworkServiceImplementation(),
                    coreDataStorage: CoreDataStorage.shared
                )
            )
        )
        window?.makeKeyAndVisible()
    }
}
