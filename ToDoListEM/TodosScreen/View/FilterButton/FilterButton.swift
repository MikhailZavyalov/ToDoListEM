
import UIKit

private enum Constants {
    static let counterInsets = UIEdgeInsets(top: -10, left: 5, bottom: -10, right: 5)
    static let titleInsets = UIEdgeInsets.zero
}

final class FilterButton: UIView {

    private let title: UILabel = {
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor(named: "gray")
        return title
    }()

    private let taskCountBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "blue")
        view.layer.masksToBounds = true
        return view
    }()

    private let countOfTasks: UILabel = {
        let countOfTasks = UILabel()
        countOfTasks.textColor = .white
        countOfTasks.font = countOfTasks.font.withSize(16)
        return countOfTasks
    }()

    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private let button: UIButton = {
        let button = UIButton()
        return button
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.title.text = title
        isUserInteractionEnabled = true

        setupConstraints()
    }

    func setCountText(_ text: String) {
        countOfTasks.text = text
    }

    private func setupConstraints() {
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false

        hStack.addArrangedSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        hStack.addArrangedSubview(taskCountBackground)
        taskCountBackground.translatesAutoresizingMaskIntoConstraints = false

        taskCountBackground.addSubview(countOfTasks)
        countOfTasks.translatesAutoresizingMaskIntoConstraints = false

        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),

            title.topAnchor.constraint(equalTo: hStack.topAnchor, constant: Constants.titleInsets.top),
            title.leadingAnchor.constraint(equalTo: hStack.leadingAnchor, constant: Constants.titleInsets.left),

            countOfTasks.topAnchor.constraint(equalTo: taskCountBackground.topAnchor, constant: Constants.counterInsets.top),
            countOfTasks.trailingAnchor.constraint(equalTo: taskCountBackground.trailingAnchor, constant: -Constants.counterInsets.right),
            countOfTasks.bottomAnchor.constraint(equalTo: taskCountBackground.bottomAnchor, constant: -Constants.counterInsets.bottom),
            countOfTasks.leadingAnchor.constraint(equalTo: taskCountBackground.leadingAnchor, constant: Constants.counterInsets.left),

            taskCountBackground.topAnchor.constraint(equalTo: hStack.topAnchor, constant: 0),
            taskCountBackground.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8),
            taskCountBackground.widthAnchor.constraint(equalTo: countOfTasks.widthAnchor, constant: Constants.counterInsets.left + Constants.counterInsets.right),
            taskCountBackground.trailingAnchor.constraint(equalTo: hStack.trailingAnchor),
            taskCountBackground.bottomAnchor.constraint(equalTo: hStack.bottomAnchor),

            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCornerRadius() {
        taskCountBackground.layer.cornerRadius = taskCountBackground.frame.height / 2
    }

    func addTarget(
        _ target: Any?,
        action: Selector,
        for controlEvents: UIControl.Event
    ) {
        button.addTarget(target, action: action, for: controlEvents)
    }
}
