
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

    private let allButton = FilterButton(title: "All")
    private var openButton = FilterButton(title: "Open")
    private let closedButton = FilterButton(title: "Closed")

    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "gray")
        return separator
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "LightGray")
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
        view.backgroundColor = UIColor(named: "LightGray")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.reuseID)
        viewModel.$todosModels.bind(executeInitially: true) { [weak self] models in
            guard let self else { return }
            tableView.reloadData()
            //diffableDataSource - googl it
        }

        viewModel.$allCount.bind(executeInitially: true) { [weak self] allCount in
            guard let self else { return }
            allButton.setCountText("\(allCount)")
        }

        viewModel.$openCount.bind(executeInitially: true) { [weak self] openCount in
            guard let self else { return }
            openButton.setCountText("\(openCount)")
        }

        viewModel.$closedCount.bind(executeInitially: true) { [weak self] closedCount in
            guard let self else { return }
            closedButton.setCountText("\(closedCount)")
        }

        newTaskButton.addTarget(self, action: #selector(goToNewTodoScreen), for: .touchUpInside)
        allButton.addTarget(self, action: #selector(filterAll), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(filterOpen), for: .touchUpInside)
        closedButton.addTarget(self, action: #selector(filterClosed), for: .touchUpInside)
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        allButton.updateCornerRadius()
        openButton.updateCornerRadius()
        closedButton.updateCornerRadius()
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

        view.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false

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

            separator.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 30),
            separator.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 20),
            separator.heightAnchor.constraint(equalToConstant: 20),
            separator.widthAnchor.constraint(equalToConstant: 2),

            openButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 30),
            openButton.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 20),
            openButton.heightAnchor.constraint(equalToConstant: 20),

            closedButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 30),
            closedButton.leadingAnchor.constraint(equalTo: openButton.trailingAnchor, constant: 20),
            closedButton.heightAnchor.constraint(equalToConstant: 20),

            tableView.topAnchor.constraint(equalTo: closedButton.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
        ])
    }

    @objc
    func goToNewTodoScreen() {
        let newTodoView = NewTodoView { [weak self] newTodoModel in
            self?.viewModel.addTodo(newTodo: newTodoModel)
        }
        present(newTodoView, animated: true)
    }

    @objc
    func filterAll() {
        viewModel.filterTodos(by: .all)
    }

    @objc
    func filterOpen() {
        viewModel.filterTodos(by: .open)
    }

    @objc
    func filterClosed() {
        viewModel.filterTodos(by: .closed)
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
        viewModel.todosModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListTableViewCell.reuseID, for: indexPath)
        guard let taskCell = cell as? TodoListTableViewCell else { return cell }
        taskCell.configure(with: viewModel.todosModels[indexPath.row])
        return taskCell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            viewModel.deleteTodo(at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard 
            let editTodo = viewModel.todoDTOs.first(where: {
                $0.id == viewModel.todosModels[indexPath.row].id
            }) else { return }
        let editTodoView = EditTodoView(editTodo: editTodo) { [weak self] newTodo in
            self?.viewModel.editTodo(newTodo: newTodo)
        }
        present(editTodoView, animated: true)
    }
}
