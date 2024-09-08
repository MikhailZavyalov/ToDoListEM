
import UIKit

final class NewTodoView: UIViewController, UITextFieldDelegate {

    let viewModel: TodoListViewModel

    private let newTodoNameLabel: UILabel = {
        let name = UILabel()
        name.text = "New Todo"
        name.font = UIFont(name: "Mulish", size: 16)
        name.textColor = .black
        return name
    }()

    private let newTodoTextField = TextFieldView()

    private let newTodoDescriptionLabel: UILabel = {
        let description = UILabel()
        description.text = "Description"
        description.font = UIFont(name: "Mulish", size: 16)
        description.textColor = .black
        return description
    }()

    private let newTodoDescriptionField = TextFieldView()

    private let newTodoTimeAndDate: UILabel = {
        let newTodo = UILabel()
        newTodo.text = "Time"
        newTodo.font = UIFont(name: "Mulish", size: 16)
        newTodo.textColor = .black
        return newTodo
    }()

    private let newTodoTimeAndDateField = TextFieldView()

    private let addNewTodoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Add new ToDo", for: .normal)
        button.layer.cornerRadius = 16
        return button
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
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        setupConstraints()

        newTodoTextField.delegate = self
        newTodoDescriptionField.delegate = self
        newTodoTimeAndDateField.delegate = self
        addNewTodoButton.addTarget(self, action: #selector(addNewTodo), for: .touchUpInside)
    }

    private func setupConstraints() {
        view.addSubview(newTodoNameLabel)
        newTodoNameLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(newTodoTextField)
        newTodoTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(newTodoDescriptionLabel)
        newTodoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(newTodoDescriptionField)
        newTodoDescriptionField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(newTodoTimeAndDate)
        newTodoTimeAndDate.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(newTodoTimeAndDateField)
        newTodoTimeAndDateField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addNewTodoButton)
        addNewTodoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newTodoNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            newTodoNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoNameLabel.heightAnchor.constraint(equalToConstant: 22),
            newTodoNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            newTodoTextField.topAnchor.constraint(equalTo: newTodoNameLabel.bottomAnchor, constant: 8),
            newTodoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoTextField.heightAnchor.constraint(equalToConstant: 48),
            newTodoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            newTodoDescriptionLabel.topAnchor.constraint(equalTo: newTodoTextField.bottomAnchor, constant: 20),
            newTodoDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoDescriptionLabel.heightAnchor.constraint(equalToConstant: 22),
            newTodoDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            newTodoDescriptionField.topAnchor.constraint(equalTo: newTodoDescriptionLabel.bottomAnchor, constant: 8),
            newTodoDescriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoDescriptionField.heightAnchor.constraint(equalToConstant: 48),
            newTodoDescriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            newTodoTimeAndDate.topAnchor.constraint(equalTo: newTodoDescriptionField.bottomAnchor, constant: 20),
            newTodoTimeAndDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoTimeAndDate.heightAnchor.constraint(equalToConstant: 22),
            newTodoTimeAndDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            newTodoTimeAndDateField.topAnchor.constraint(equalTo: newTodoTimeAndDate.bottomAnchor, constant: 8),
            newTodoTimeAndDateField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoTimeAndDateField.heightAnchor.constraint(equalToConstant: 48),
            newTodoTimeAndDateField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            addNewTodoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addNewTodoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNewTodoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addNewTodoButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc
    func addNewTodo() {
        viewModel.addTodo(
            name: newTodoTextField.text ?? "New ToDo",
            completed: false,
            description: newTodoDescriptionField.text ?? " ",
            time: newTodoTimeAndDateField.text ?? " "
        )
        dismiss(animated: true)
    }
}
