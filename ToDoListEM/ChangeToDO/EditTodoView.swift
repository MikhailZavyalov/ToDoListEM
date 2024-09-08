
import UIKit

final class EditTodoView: UIViewController, UITextFieldDelegate {

    let viewModel: TodoListViewModel
    let indexPath: IndexPath

    private let editTodoNameLabel: UILabel = {
        let name = UILabel()
        name.text = "Edit Todo"
        name.font = UIFont(name: "Mulish", size: 16)
        name.textColor = .black
        return name
    }()

    private let editTodoNameTextField = TextFieldView()

    private let editTodoDescriptionLabel: UILabel = {
        let description = UILabel()
        description.text = "Description"
        description.font = UIFont(name: "Mulish", size: 16)
        description.textColor = .black
        return description
    }()

    private let editTodoDescriptionField = TextFieldView()

    private let editTodoTimeAndDate: UILabel = {
        let time = UILabel()
        time.text = "Time"
        time.font = UIFont(name: "Mulish", size: 16)
        time.textColor = .black
        return time
    }()

    private let editTodoTimeAndDateField = TextFieldView()

    private let editTodoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Edit ToDo", for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()

    private var customSwitchButton: CustomSwitchButtonView

    init(viewModel: TodoListViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        customSwitchButton = CustomSwitchButtonView(completed: viewModel.todosModels[indexPath.row].status)

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

        editTodoNameTextField.text = viewModel.todosModels[indexPath.row].name
        editTodoDescriptionField.text = viewModel.todosModels[indexPath.row].description
        editTodoTimeAndDateField.text = viewModel.todosModels[indexPath.row].date

        editTodoNameTextField.delegate = self
        editTodoDescriptionField.delegate = self
        editTodoTimeAndDateField.delegate = self
        editTodoButton.addTarget(self, action: #selector(editTodo), for: .touchUpInside)
    }

    private func setupConstraints() {
        view.addSubview(editTodoNameLabel)
        editTodoNameLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(editTodoNameTextField)
        editTodoNameTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(editTodoDescriptionLabel)
        editTodoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(editTodoDescriptionField)
        editTodoDescriptionField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(editTodoTimeAndDate)
        editTodoTimeAndDate.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(editTodoTimeAndDateField)
        editTodoTimeAndDateField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(customSwitchButton)
        customSwitchButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(editTodoButton)
        editTodoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            editTodoNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            editTodoNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoNameLabel.heightAnchor.constraint(equalToConstant: 22),
            editTodoNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            editTodoNameTextField.topAnchor.constraint(equalTo: editTodoNameLabel.bottomAnchor, constant: 8),
            editTodoNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoNameTextField.heightAnchor.constraint(equalToConstant: 48),
            editTodoNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            editTodoDescriptionLabel.topAnchor.constraint(equalTo: editTodoNameTextField.bottomAnchor, constant: 20),
            editTodoDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoDescriptionLabel.heightAnchor.constraint(equalToConstant: 22),
            editTodoDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            editTodoDescriptionField.topAnchor.constraint(equalTo: editTodoDescriptionLabel.bottomAnchor, constant: 8),
            editTodoDescriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoDescriptionField.heightAnchor.constraint(equalToConstant: 48),
            editTodoDescriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            editTodoTimeAndDate.topAnchor.constraint(equalTo: editTodoDescriptionField.bottomAnchor, constant: 20),
            editTodoTimeAndDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoTimeAndDate.heightAnchor.constraint(equalToConstant: 22),
            editTodoTimeAndDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            editTodoTimeAndDateField.topAnchor.constraint(equalTo: editTodoTimeAndDate.bottomAnchor, constant: 8),
            editTodoTimeAndDateField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoTimeAndDateField.heightAnchor.constraint(equalToConstant: 48),
            editTodoTimeAndDateField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            customSwitchButton.topAnchor.constraint(equalTo: editTodoTimeAndDateField.bottomAnchor, constant: 20),
            customSwitchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customSwitchButton.heightAnchor.constraint(equalToConstant: 48),
            customSwitchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            editTodoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            editTodoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editTodoButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    @objc
    func editTodo() {
        viewModel.editTodo(
            at: indexPath,
            name: editTodoNameTextField.text ?? "",
            description: editTodoDescriptionField.text ?? "",
            time: editTodoTimeAndDateField.text ?? "",
            completed: customSwitchButton.switchButtonTapped
        )
        dismiss(animated: true)
    }
}
