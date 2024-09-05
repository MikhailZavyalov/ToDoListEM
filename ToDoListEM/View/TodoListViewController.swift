
import UIKit

class TodoListViewController: UIViewController {

    let viewModel: TodoListViewModel

    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Today's Task"
        title.font = title.font.withSize(28)
        title.textColor = .black
        return title
    }()

    private let date: UILabel = {
        let label = UILabel()
        let date = Date().dayOfWeek()!
        label.text = date
        label.font = label.font.withSize(18)
        label.textColor = .black
        return label
    }()

    private let newTaskButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ New Task", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        return button
    }()

    private var allButton = FilterButton(title: "All", countOfTasks: "")
    var openButton = FilterButton(title: "Open", countOfTasks: "15")
    var closedButton = FilterButton(title: "Closed", countOfTasks: "8")

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.masksToBounds = false
        return tableView
    }()

    init(viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        viewModel.loadData()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoListTableViewCell.self, forCellReuseIdentifier: TodoListTableViewCell.reuseID)
        viewModel.$todosModels.bind(executeInitially: true) { [weak self] models in
            self?.tableView.reloadData()
        }

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

            allButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 50),
            allButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            allButton.widthAnchor.constraint(equalToConstant: 60),

            openButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 50),
            openButton.leadingAnchor.constraint(equalTo: allButton.trailingAnchor, constant: 30),
            openButton.widthAnchor.constraint(equalToConstant: 60),

            closedButton.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 50),
            closedButton.leadingAnchor.constraint(equalTo: openButton.trailingAnchor, constant: 30),
            closedButton.widthAnchor.constraint(equalToConstant: 60),

            tableView.topAnchor.constraint(equalTo: closedButton.bottomAnchor, constant: 40),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
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


}

