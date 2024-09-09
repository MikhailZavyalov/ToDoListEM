
import UIKit

class TodoListViewController: UIViewController {
    let viewModel: TodoListViewModel

    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Today's Task"
        title.font = UIFont.boldSystemFont(ofSize: 28)
        title.textColor = .black

        return title
    }()

    private let date: UILabel = {
        let label = UILabel()
        let date = Date().dayOfWeek()!
        label.text = date
        label.font = label.font.withSize(16)
        label.textColor = UIColor(named: "gray")
        return label
    }()

    private let newTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ New Task", for: .normal)
        button.setTitleColor(UIColor(named: "blue"), for: .normal)
        button.backgroundColor = UIColor(named: "lightBlue")
        button.layer.cornerRadius = 16
        return button
    }()

    private var allButton = FilterButton(title: "All", countOfTasks: "")
    var openButton = FilterButton(title: "Open", countOfTasks: "15")
    var closedButton = FilterButton(title: "Closed", countOfTasks: "8")

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "lightGray")
        return tableView
    }()

    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        view.backgroundColor = UIColor(named: "lightGray")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.reuseID)
        viewModel.$todosModels.bind(executeInitially: true) { [weak self] models in
            guard let self else { return }
            tableView.reloadData()
            let closedTodosCount = closedTodosCount()
            allButton.setCountText("\(viewModel.todosModels.count)")
            closedButton.setCountText("\(closedTodosCount)")
            openButton.setCountText("\(viewModel.todosModels.count - closedTodosCount)")
            //diffableDataSource - googl it
        }

        viewModel.$filteredTodosModels.bind(executeInitially: true) { [weak self] models in
            guard let self else { return }
            tableView.reloadData()
        }
        newTaskButton.addTarget(self, action: #selector(goToNewTodoScreen), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(filterByOpenTodos), for: .touchUpInside)
        closedButton.addTarget(self, action: #selector(filterByClosedTodos), for: .touchUpInside)
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(date)
        date.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(newTaskButton)
        newTaskButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(allButton)
        allButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(openButton)
        openButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(closedButton)
        closedButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            date.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            date.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            newTaskButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            newTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTaskButton.heightAnchor.constraint(equalToConstant: 50),
            newTaskButton.widthAnchor.constraint(equalToConstant: 130),

            allButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 30),
            allButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            allButton.heightAnchor.constraint(equalToConstant: 20),

            openButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 30),
            openButton.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 30),
            openButton.heightAnchor.constraint(equalToConstant: 20),

            closedButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 30),
            closedButton.leadingAnchor.constraint(equalTo: openButton.trailingAnchor, constant: 30),
            closedButton.heightAnchor.constraint(equalToConstant: 20),

            tableView.topAnchor.constraint(equalTo: closedButton.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }

    @objc
    func goToNewTodoScreen() {
        viewModel.filterByOpenTodos()
        print("🍎", #function, "Open")

//        viewModel.filterByClosedTodos()
//        print("🍎", #function, "Closed")

//        let newTodoView = NewTodoView { [weak self] newTodoModel in
//            self?.viewModel.addTodo(newTodo: newTodoModel)
//        }
//        present(newTodoView, animated: true)
    }

    @objc
    func filterByOpenTodos() {
//        viewModel.filterByOpenTodos()
//        print("🍎", #function, "Open")
    }

    @objc
    func filterByClosedTodos() {
//        viewModel.filterByClosedTodos()
//        print("🍎", #function, "Closed")
    }

    private func closedTodosCount() -> Int {
        var closedTodos = 0
        for todo in viewModel.todosModels {
            if todo.status {
                closedTodos += 1
            }
        }
        return closedTodos
    }
}

extension TodoListViewController: UITableViewDelegate {

}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredTodosModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.reuseID, for: indexPath)
        guard let taskCell = cell as? TodoListTableViewCell else { return cell }
        taskCell.configure(with: viewModel.filteredTodosModels[indexPath.row])
        return taskCell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            viewModel.deleteTodo(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editTodoView = EditTodoView(editTodo: viewModel.todoDTOs[indexPath.row]) { [weak self] newTodo in
            self?.viewModel.editTodo(newTodo: newTodo)
        }
        present(editTodoView, animated: true)
    }
}

