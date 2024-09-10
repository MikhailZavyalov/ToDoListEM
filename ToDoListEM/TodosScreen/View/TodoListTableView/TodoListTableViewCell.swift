
import UIKit

final class TodoListTableViewCell: UITableViewCell {

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()

    private let titlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "gray")
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()

    private var statusIcon: UIImageView = {
        var status = UIImageView()
        status.image = UIImage(systemName: "circle")
        return status
    }()

    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(named: "middleGray")
        return separator
    }()

    private let dateAndTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "gray")
        label.font = label.font.withSize(14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        backgroundColor = .clear
        selectionStyle = .none
        layer.masksToBounds = false
        self.setEditing(true, animated: true)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func configure(with model: TodoListTableViewCellModel) {
        titlelabel.text = model.name
        descriptionLabel.text = model.description
        statusIcon.image = if model.status { UIImage(systemName: "checkmark.circle.fill")
        } else {
            UIImage(systemName: "circle")
        }

        statusIcon.tintColor = if model.status {
            UIColor(named: "blue")
        } else {
            UIColor(named: "gray")
        }
        dateAndTimeLabel.text = model.timeText
    }

    private func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titlelabel)
        titlelabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(dateAndTimeLabel)
        dateAndTimeLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(statusIcon)
        statusIcon.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 140),

            titlelabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titlelabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titlelabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -65),

            descriptionLabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
//            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -65),

            separator.topAnchor.constraint(equalTo: statusIcon.bottomAnchor, constant: 30),
            separator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            separator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            separator.heightAnchor.constraint(equalToConstant: 1),

            dateAndTimeLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            dateAndTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

            statusIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            statusIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            statusIcon.heightAnchor.constraint(equalToConstant: 25),
            statusIcon.widthAnchor.constraint(equalToConstant: 25),

        ]

        constraints.forEach {
            $0.priority = .defaultHigh
        }

        NSLayoutConstraint.activate(constraints)
    }
}

