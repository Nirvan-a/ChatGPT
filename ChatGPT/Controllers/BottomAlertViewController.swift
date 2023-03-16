//
//  BottomAlertViewController.swift
//  ChatGPT
//
//  Created by nirvana on 3/12/23.

import UIKit

class BottomAlertViewController: UIViewController, UITextFieldDelegate {
    
    var updataQuestionText: ((_ questionColor: UIColor)-> Void)?
    var updateAnswerText: ((_ questionColor: UIColor)-> Void)?
    var updateMainView: ((_ titleColor: UIColor, _ image: UIImage,_ isFromAddButton: (Bool,Int))-> Void)?
    var callFromAddButtonOrEditButton = (true,0)
    var editButtonImage: UIImage = UIImage() {
        didSet {
            if callFromAddButtonOrEditButton.1 == 1 {
                chooseFilePicutre.profileButton.setImage(editButtonImage, for: .normal)
            } else if callFromAddButtonOrEditButton.1 == 2 {
                chooseFilePicutre.botButton.setImage(editButtonImage, for: .normal)
            }
        }
    }
    var saveButtonTapped: ((_ apiKey: String)-> Void)?
    
    private lazy var closeButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.app")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonClosed)))
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var apiView: APIKeyLineView = {
        let view = APIKeyLineView(api: "Enter your Key,return to finish!")
        view.remindIcon.addTarget(self, action: #selector(remindButtonTapped(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var colorChoose: ColorChooseView = {
        let view = ColorChooseView(title: "Question ", colorList: [.white,UIColor(hexString: "#FF8C00"), UIColor(hexString: "#006400"),UIColor(hexString: "#1E90FF"), UIColor(hexString: "#DC143C"), UIColor(hexString: "#696969")])
        view.updateSelect = updataQuestionText
        return view
    }()
    
    private lazy var colorChoose2: ColorChooseView = {
        let view = ColorChooseView(title: "Response ", colorList: [.white,UIColor(hexString: "#FF8C00"), UIColor(hexString: "#006400"),UIColor(hexString: "#1E90FF"), UIColor(hexString: "#DC143C"), UIColor(hexString: "#696969")])
        view.updateSelect = updateAnswerText
        return view
    }()
        
    private lazy var chooseBgPicture: ChooseBgView = {
        let view = ChooseBgView()
        view.updateMainView = updateMainView
        return view
    }()
    
    private lazy var chooseFilePicutre: ChooseProfileView = {
        let view = ChooseProfileView()
        return view
    }()
    
    private lazy var saveButton: BottomAlertButton = {
        let button = BottomAlertButton(title: "Save APIKey and Changes")
        button.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.2.circlepath.circle"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white.withAlphaComponent(0.7)
        view.layer.cornerRadius = 10
        apiView.inputTextField.delegate = self
        
        chooseBgPicture.addBGButtonTapped = { [weak self](addButton: UIButton) in
            guard let strongSelf = self else { return }
            strongSelf.callFromAddButtonOrEditButton = (true,0)
            strongSelf.addBGButtonTapped(addButton)
        }
        chooseFilePicutre.updateFilePicture = { [weak self](editButton: UIButton) in
            guard let strongSelf = self else { return }
            strongSelf.callFromAddButtonOrEditButton = (false,editButton.tag)
            strongSelf.addBGButtonTapped(editButton)
        }
        
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        apiView.inputTextField.resignFirstResponder()
    }

    func setUpViews() {
        view.addSubview(titleLabel)
        view.addSubview(closeButton)
        view.bringSubviewToFront(closeButton)
        view.addSubview(apiView)
        view.addSubview(colorChoose)
        view.addSubview(colorChoose2)
        view.addSubview(chooseBgPicture)
        view.addSubview(chooseFilePicutre)
        view.addSubview(saveButton)
//        view.addSubview(resetButton)
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.top.equalTo(16)
            make.width.height.equalTo(25)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        apiView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        colorChoose.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(30)
            make.top.equalTo(apiView.snp.bottom).offset(20)
        }
        colorChoose2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(30)
            make.top.equalTo(colorChoose.snp.bottom).offset(20)
        }
        chooseBgPicture.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(60)
            make.top.equalTo(colorChoose2.snp.bottom).offset(20)
        }
        chooseFilePicutre.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(30)
            make.top.equalTo(chooseBgPicture.snp.bottom).offset(20)
        }
        saveButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.top.equalTo(chooseFilePicutre.snp.bottom).offset(25)
        }
//        resetButton.snp.makeConstraints { make in
//            make.centerY.equalTo(saveButton)
//            make.height.width.equalTo(30)
//            make.trailing.equalTo(saveButton.snp.leading).offset(-10)
//        }
        
    }
    
    private func presentPopover(popover: RemindPopverController, sender: UIView, size: CGSize, arrowDirection: UIPopoverArrowDirection = .down) {
        
        let popoverViewController = popover
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = size
        
        let popoverPresentationController = popoverViewController.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = arrowDirection
        popoverPresentationController?.delegate = self
        popoverPresentationController?.sourceView = sender
        popoverPresentationController?.sourceRect = sender.bounds
        self.present(popoverViewController, animated: true, completion: nil)
    }

    @objc func remindButtonTapped(_ sender: UIButton) {
        let remindVC = RemindPopverController(width: 330)
        presentPopover(popover: remindVC, sender: sender, size: CGSize(width: remindVC.popwindowWidth, height: remindVC.popWindowHeight))
    }
    
    @objc func saveButtonAction() {
        self.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.saveButtonTapped?(strongSelf.apiView.inputTextField.text ?? "")
        }
    }

    
    @objc func closeButtonClosed() {
        self.dismiss(animated: true, completion: nil)
    }

    init(presentTransitionDelegate: UIViewControllerTransitioningDelegate, proImage: UIImage, botImage: UIImage, apiKey: String) {
        self.init()
        modalPresentationStyle = .custom
        transitioningDelegate = presentTransitionDelegate
        
        self.chooseFilePicutre.profileButton.setImage(proImage, for: .normal)
        self.chooseFilePicutre.botButton.setImage(botImage, for: .normal)
        
        if !apiKey.isEmpty {
            self.apiView.inputTextField.text = apiKey
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomAlertViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension BottomAlertViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func addBGButtonTapped(_ sender: UIButton) {
            //创建实例并设置自身代理
             let imagePicker = UIImagePickerController()
            imagePicker.delegate = self

            let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            //判断图库是否可用
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let photoLibraryActin = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                })
                alertController.addAction(photoLibraryActin)
            }
            alertController.popoverPresentationController?.sourceView = sender
            present(alertController, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]){
           //.originalImage used here
            //you need to typecast the value to "UIImage"
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            editButtonImage = selectedImage
            updateMainView?(UIColor.white, selectedImage, callFromAddButtonOrEditButton)
            dismiss(animated: true, completion: nil)
        }
}
