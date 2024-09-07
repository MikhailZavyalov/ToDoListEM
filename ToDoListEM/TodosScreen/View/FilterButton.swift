
import UIKit

final class FilterButton: UIButton {

    let title: UILabel = {
        let title = UILabel()
        title.font = title.font.withSize(16)
        title.textColor = .black
        return title
    }()

    var countOfTasks: UILabel = {
        var countOfTasks = UILabel()
        countOfTasks.backgroundColor = .blue
        countOfTasks.textColor = .white
        return countOfTasks
    }()

    init(title: String, countOfTasks: String) {
        super.init(frame: .zero)
        self.title.text = title
        self.countOfTasks.text = countOfTasks
        
        setupConstraints()
    }

    func setupConstraints() {
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false

        addSubview(countOfTasks)
        countOfTasks.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),

            countOfTasks.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            countOfTasks.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
