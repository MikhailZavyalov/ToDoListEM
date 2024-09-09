
import UIKit

final class EditTodoView: UIViewController, UITextFieldDelegate {
    private let editTodo: TodoDTO
    private let onEditCompleted: (TodoDTO) -> Void

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

    private let startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        return datePicker
    }()

    private let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        return datePicker
    }()

    private let finishEditingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "lightBlue")
        button.setTitle("Edit ToDo", for: .normal)
        button.setTitleColor(UIColor(named: "blue"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 16
        return button
    }()

    private var customSwitchButton: CustomSwitchButtonView

    init(editTodo: TodoDTO, onEditCompleted: @escaping (TodoDTO) -> Void) {
        self.editTodo = editTodo
        self.onEditCompleted = onEditCompleted
        customSwitchButton = CustomSwitchButtonView(completed: editTodo.completed)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(named: "lightGray")
        setupConstraints()

        editTodoNameTextField.text = editTodo.todo
        editTodoDescriptionField.text = editTodo.todoDescription

        if let start = editTodo.startDate {
            startDatePicker.date = start
        }

        if let end = editTodo.endDate {
            endDatePicker.date = end
        }

        editTodoNameTextField.delegate = self
        editTodoDescriptionField.delegate = self
        finishEditingButton.addTarget(self, action: #selector(finishEditing), for: .touchUpInside)
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

        view.addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(endDatePicker)
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(customSwitchButton)
        customSwitchButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(finishEditingButton)
        finishEditingButton.translatesAutoresizingMaskIntoConstraints = false

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
            editTodoDescriptionField.heightAnchor.constraint(equalToConstant: 300),
            editTodoDescriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            editTodoTimeAndDate.topAnchor.constraint(equalTo: editTodoDescriptionField.bottomAnchor, constant: 20),
            editTodoTimeAndDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editTodoTimeAndDate.heightAnchor.constraint(equalToConstant: 22),
            editTodoTimeAndDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            startDatePicker.topAnchor.constraint(equalTo: editTodoTimeAndDate.bottomAnchor, constant: 8),
            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            endDatePicker.topAnchor.constraint(equalTo: editTodoTimeAndDate.bottomAnchor, constant: 8),
            endDatePicker.leadingAnchor.constraint(equalTo: startDatePicker.trailingAnchor, constant: 8),

            customSwitchButton.topAnchor.constraint(equalTo: endDatePicker.bottomAnchor, constant: 20),
            customSwitchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customSwitchButton.heightAnchor.constraint(equalToConstant: 48),
            customSwitchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            finishEditingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            finishEditingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            finishEditingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            finishEditingButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    @objc
    func finishEditing() {
        let newTodo = TodoDTO(
            id: editTodo.id,
            todo: editTodoNameTextField.text ?? editTodo.todo,
            todoDescription: editTodoDescriptionField.text,
            startDate: startDatePicker.date,
            endDate: endDatePicker.date,
            completed: customSwitchButton.switchButtonTapped,
            userID: editTodo.userID
        )
        onEditCompleted(newTodo)
        dismiss(animated: true)
    }
}
