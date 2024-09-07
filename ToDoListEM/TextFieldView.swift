import UIKit

final class TextFieldView: UITextField {

    init() {
        super.init(frame: .zero)

        layer.cornerRadius = 16
        backgroundColor = .white
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 10
        layer.shadowColor = UIColor(.gray).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:16, height:10))
        leftViewMode = .always
        leftView = spacerView
        rightViewMode = .always
        rightView = spacerView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
