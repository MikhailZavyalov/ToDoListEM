// TODO: - change color for button if fields are empty
import UIKit

final class NewTodoView: UIViewController, UITextFieldDelegate {

    private let onNewTodoCreated: (NewTodoModel) -> Void

    private let newTodoNameLabel: UILabel = {
        let name = UILabel()
        name.text = "New Todo"
        name.font = UIFont.boldSystemFont(ofSize: 16)
        name.textColor = .black
        return name
    }()

    private let newTodoTextField = TextFieldView()

    private let newTodoDescriptionLabel: UILabel = {
        let description = UILabel()
        description.text = "Description"
        description.font = UIFont.boldSystemFont(ofSize: 16)
        description.textColor = .black
        return description
    }()

    private let newTodoDescriptionField = TextFieldView()

    private let newTodoTimeAndDate: UILabel = {
        let newTodo = UILabel()
        newTodo.text = "Time"
        newTodo.font = UIFont.boldSystemFont(ofSize: 16)
        newTodo.textColor = .black
        return newTodo
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

    private let addNewTodoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "lightBlue")
        button.setTitle("Add new ToDo", for: .normal)
        button.setTitleColor(UIColor(named: "blue"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 16
        return button
    }()

    init(onNewTodoCreated: @escaping (NewTodoModel) -> Void) {
        self.onNewTodoCreated = onNewTodoCreated
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(named: "LightGray")
        setupConstraints()

        newTodoTextField.delegate = self
        newTodoDescriptionField.delegate = self
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

        view.addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(endDatePicker)
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false

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
            newTodoDescriptionField.heightAnchor.constraint(equalToConstant: 300),
            newTodoDescriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            newTodoTimeAndDate.topAnchor.constraint(equalTo: newTodoDescriptionField.bottomAnchor, constant: 20),
            newTodoTimeAndDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newTodoTimeAndDate.heightAnchor.constraint(equalToConstant: 22),
            newTodoTimeAndDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            startDatePicker.topAnchor.constraint(equalTo: newTodoTimeAndDate.bottomAnchor, constant: 8),
            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            endDatePicker.topAnchor.constraint(equalTo: newTodoTimeAndDate.bottomAnchor, constant: 8),
            endDatePicker.leadingAnchor.constraint(equalTo: startDatePicker.trailingAnchor, constant: 8),

            addNewTodoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addNewTodoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addNewTodoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addNewTodoButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc
    func addNewTodo() {
        guard
            let name = newTodoTextField.text,
            let description = newTodoDescriptionField.text
        else { return }
        let newTodoModel = NewTodoModel(
            name: name,
            completed: false,
            description: description,
            start: startDatePicker.date,
            end: endDatePicker.date
        )
        onNewTodoCreated(newTodoModel)
        dismiss(animated: true)
    }
}
