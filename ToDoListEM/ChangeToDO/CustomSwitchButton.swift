
import UIKit

final class CustomSwitchButtonView: UIView {

    var switchButtonTapped: Bool

    let openTodoLeftButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .blue
        return button
    }()

    let closeTodoRightButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .blue
        return button
    }()

    init(completed: Bool) {
        self.switchButtonTapped = completed
        openTodoLeftButton.backgroundColor = completed ? .lightGray : .blue
        closeTodoRightButton.backgroundColor = completed ? .blue : .lightGray
        openTodoLeftButton.setTitleColor(completed ? .black : .white, for: .normal)
        closeTodoRightButton.setTitleColor(completed ? .white : .black, for: .normal)

        super.init(frame: .zero)
        openTodoLeftButton.translatesAutoresizingMaskIntoConstraints = false
        closeTodoRightButton.translatesAutoresizingMaskIntoConstraints = false

        openTodoLeftButton.addTarget(self, action: #selector(tapOnSwitchButton), for: .touchUpInside)
        closeTodoRightButton.addTarget(self, action: #selector(tapOnSwitchButton), for: .touchUpInside)

        let backgroundColorHStackForButtons = UIStackView(arrangedSubviews: [openTodoLeftButton, closeTodoRightButton])
        addSubview(backgroundColorHStackForButtons)
        backgroundColorHStackForButtons.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorHStackForButtons.axis = .horizontal
        backgroundColorHStackForButtons.distribution = .fillEqually
        backgroundColorHStackForButtons.backgroundColor = .blue
        backgroundColorHStackForButtons.layer.cornerRadius = 16

        NSLayoutConstraint.activate([
            backgroundColorHStackForButtons.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundColorHStackForButtons.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            backgroundColorHStackForButtons.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            backgroundColorHStackForButtons.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
        ])
    }

    @objc func tapOnSwitchButton() {
        if switchButtonTapped == false {
            switchButtonTapped = true
            openTodoLeftButton.setTitleColor(UIColor.black, for: .normal)
            closeTodoRightButton.setTitleColor(UIColor.white, for: .normal)
            openTodoLeftButton.backgroundColor = .lightGray
            closeTodoRightButton.backgroundColor = .blue
        } else {
            switchButtonTapped = false
            openTodoLeftButton.setTitleColor(UIColor.white, for: .normal)
            closeTodoRightButton.setTitleColor(UIColor.black, for: .normal)
            openTodoLeftButton.backgroundColor = .blue
            closeTodoRightButton.backgroundColor = .lightGray
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

