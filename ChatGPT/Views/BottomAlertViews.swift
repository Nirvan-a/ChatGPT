//
//  BottomAlertViews.swift
//  ChatGPT
//
//  Created by nirvana on 3/13/23.
//

import UIKit

class BottomAlertButton: UIButton {
    
    var saveButtonTapped: ((_ apiKey: String)-> Void)?
    
    let buttonHeight: CGFloat = 40
    
    init(title: String) {
        super.init(frame: .zero)
        layer.borderWidth = 3
        layer.cornerRadius = 20
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .white
        
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class APITextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 5, y: 0, width: bounds.width - 35, height: bounds.height)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 5, y: 0, width: bounds.width - 35, height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 5, y: 0, width: bounds.width - 35, height: bounds.height)
    }
}

class APIKeyLineView: UIView {
    
    lazy var apiLabel: UILabel = {
        let label = UILabel()
        label.text = "APIKey:"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var remindIcon: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        return button
    }()
    
    lazy var inputTextField: APITextField = {
        let field = APITextField()
        field.backgroundColor = .white
        field.layer.cornerRadius = 5
        field.isSecureTextEntry = true
        return field
    }()
    
    init(api: String) {
        super.init(frame: .zero)
        inputTextField.placeholder = api

        addSubview(apiLabel)
        addSubview(inputTextField)
        addSubview(remindIcon)
        apiLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo("APIKey:".width(withFont: .boldSystemFont(ofSize: 18)))
        }
        inputTextField.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(apiLabel.snp.trailing).offset(10)
        }
        remindIcon.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalTo(inputTextField)
            make.trailing.equalTo(inputTextField.snp.trailing).offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColorChooseView: UIView {
    
    var updateSelect: ((_ color: UIColor) -> Void)?
    
    var colorViewList: [UIButton] = []
        
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var colorStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    init(title: String, colorList: [UIColor]) {
        super.init(frame: .zero)
        
        textLabel.text = title
        colorViewList.append(colorButton1)
        colorViewList.append(colorButton2)
        colorViewList.append(colorButton3)
        colorViewList.append(colorButton4)
        colorViewList.append(colorButton5)
        colorViewList.append(colorButton6)
        
        for i in 0..<colorViewList.count {
            let button = colorViewList[i]
            button.backgroundColor = colorList[i]
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.clear.cgColor
            button.snp.makeConstraints { make in
                make.height.width.equalTo(25)
            }
            button.addTarget(self, action: #selector(colorChoosed(_:)), for: .touchUpInside)
        }
        
        addSubview(textLabel)
        addSubview(colorStack)
        colorStack.addArrangedSubview(colorButton1)
        colorStack.addArrangedSubview(colorButton2)
        colorStack.addArrangedSubview(colorButton3)
        colorStack.addArrangedSubview(colorButton4)
        colorStack.addArrangedSubview(colorButton5)
        colorStack.addArrangedSubview(colorButton6)
        
        textLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(title.width(withFont: .boldSystemFont(ofSize: 16)))
        }
        
        colorStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(textLabel.snp.trailing).offset(10)
        }
    }
    
    @objc func colorChoosed(_ sender: UIButton) {
        for i in colorViewList {
            if i === sender {
                i.layer.borderColor = UIColor.black.cgColor
            } else {
                i.layer.borderColor = UIColor.clear.cgColor
            }
        }
        updateSelect?(sender.backgroundColor ?? .clear)
    }
    
    lazy var colorButton1: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var colorButton2: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var colorButton3: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var colorButton4: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var colorButton5: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    lazy var colorButton6: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChooseBgView: UIView {
    
    var updateMainView: ((_ titleColor: UIColor, _ image: UIImage, _ isFromAddButton: (Bool,Int))-> Void)?
    var addBGButtonTapped: ((_ sender: UIButton)-> Void)?
    
    var bgButtonList: [UIButton] = []
    
    var savedTag = -1
    
    lazy var bgStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    lazy var bgLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Background"
        return label
    }()
    
    lazy var bgButto1: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setBackgroundImage(UIImage(named: "background1"), for: .normal)
        return button
    }()
    
    lazy var bgButton2: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.setBackgroundImage(UIImage(named: "background2"), for: .normal)
        return button
    }()
    
    lazy var bgButton3: UIButton = {
        let button = UIButton()
        button.tag = 3
        button.setBackgroundImage(UIImage(named: "background3"), for: .normal)
        return button
    }()
    
    lazy var bgButton4: UIButton = {
        let button = UIButton()
        button.tag = 4
        button.setBackgroundImage(UIImage(named: "background4"), for: .normal)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.tag = 4
        button.setBackgroundImage(UIImage(systemName: "cross.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        bgButtonList.append(bgButto1)
        bgButtonList.append(bgButton2)
        bgButtonList.append(bgButton3)
        bgButtonList.append(bgButton4)
        for i in bgButtonList {
            i.layer.cornerRadius = 5
            i.layer.borderWidth = 2
            i.layer.masksToBounds = true
            i.layer.borderColor = UIColor.clear.cgColor
            i.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.width.equalTo(30)
            }
            i.addTarget(self, action: #selector(bgSelectChoose(_:)), for: .touchUpInside)
        }
        addButton.addTarget(self, action: #selector(addImage(_:)), for: .touchUpInside)
        
        addSubview(bgLabel)
        addSubview(bgStack)
        bgStack.addArrangedSubview(bgButto1)
        bgStack.addArrangedSubview(bgButton2)
        bgStack.addArrangedSubview(bgButton3)
        bgStack.addArrangedSubview(bgButton4)
        bgStack.addArrangedSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        bgLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo("Background".width(withFont: .boldSystemFont(ofSize: 16)))
        }
        bgStack.snp.makeConstraints { make in
            make.leading.equalTo(bgLabel.snp.trailing).offset(20)
            make.top.equalToSuperview()
            make.height.equalTo(60)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        
    }
    
    @objc func bgSelectChoose(_ sender: UIButton) {
        var color = UIColor()
        switch sender.tag {
        case 1:
            color = UIColor(hexString: "#477a85")
        case 2:
            color = .white
        case 3:
            color = UIColor(hexString: "#1E90FF")
        case 4:
            color = UIColor(hexString: "#696969")
        default:
            color = .white
        }
        for i in bgButtonList {
            if i === sender {
                sender.layer.borderColor = UIColor.black.cgColor
            } else {
                i.layer.borderColor = UIColor.clear.cgColor
            }
        }
        updateMainView?(color, sender.currentBackgroundImage ?? UIImage(), (true,0))
        savedTag = sender.tag
    }
    
    @objc func addImage(_ sender: UIButton) {
        addBGButtonTapped?(sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ChooseProfileView: UIView {
    
    var updateFilePicture: ((_ sender: UIButton)-> Void)?
    
    lazy var profile: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Profile & BotImage"
        return label
    }()
    lazy var profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profile"), for: .normal)
        button.addTarget(self, action: #selector(editImage(_:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    lazy var botfile: UILabel = {
        let label = UILabel()
//        label.font = .boldSystemFont(ofSize: 16)
//        label.text = "Botfile"
        return label
    }()
    lazy var botButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "robot"), for: .normal)
        button.addTarget(self, action: #selector(editImage(_:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(profile)
        addSubview(profileButton)
        addSubview(botButton)
        addSubview(botfile)
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        
        profile.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo("Profile & BotImage".width(withFont: .boldSystemFont(ofSize: 16)))
        }
        profileButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        botButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        stack.addArrangedSubview(profile)
        stack.addArrangedSubview(profileButton)
        stack.addArrangedSubview(botButton)
        stack.addArrangedSubview(botfile)
    }
    
    @objc func editImage(_ sender: UIButton) {
        updateFilePicture?(sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

