
import UIKit

private enum Constants {
    static let counterInsets = UIEdgeInsets(top: -2, left: 10, bottom: -2, right: 10)
    static let titleInsets = UIEdgeInsets.zero
}

final class FilterButton: UIButton {

    private let title: UILabel = {
        let title = UILabel()
        title.font = title.font.withSize(16)
        title.textColor = .black
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
        return countOfTasks
    }()

    init(title: String, countOfTasks: String) {
        super.init(frame: .zero)
        self.title.text = title
        self.countOfTasks.text = countOfTasks
        
        setupConstraints()
    }

    func setCountText(_ text: String) {
        countOfTasks.text = text
    }

    private func setupConstraints() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        addSubview(taskCountBackground)
        taskCountBackground.translatesAutoresizingMaskIntoConstraints = false

        taskCountBackground.addSubview(countOfTasks)
        countOfTasks.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: Constants.titleInsets.top),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.titleInsets.left),

            countOfTasks.topAnchor.constraint(equalTo: taskCountBackground.topAnchor, constant: Constants.counterInsets.top),
            countOfTasks.trailingAnchor.constraint(equalTo: taskCountBackground.trailingAnchor, constant: -Constants.counterInsets.right),
            countOfTasks.bottomAnchor.constraint(equalTo: taskCountBackground.bottomAnchor, constant: -Constants.counterInsets.bottom),
            countOfTasks.leadingAnchor.constraint(equalTo: taskCountBackground.leadingAnchor, constant: Constants.counterInsets.left),

            taskCountBackground.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            taskCountBackground.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8),
            taskCountBackground.widthAnchor.constraint(equalTo: countOfTasks.widthAnchor, constant: Constants.counterInsets.left + Constants.counterInsets.right),
            taskCountBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskCountBackground.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        taskCountBackground.layer.cornerRadius = taskCountBackground.frame.height / 2
    }
}
