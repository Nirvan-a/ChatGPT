//
//  ChatGPTMainViewController.swift
//  ChatGPT
//
//  Created by nirvana on 3/5/23.

import UIKit
import SnapKit

class ChatGPTMainViewController: UIViewController, UITextViewDelegate {
    
    var locadSavedModel = LocalSavedModel()
    
    var functionHelper: FunctionHelper = FunctionHelper()
    
    //UI:
    var sampleCell1:QuestionAndAnswerView? = nil
    var sampleCell2:QuestionAndAnswerView? = nil
    
    var questionAndAnswerCells: [QuestionAndAnswerView] = []
    
    var sizeConstraint: Constraint?
    
    var keyboardheight: CGFloat = 0
    
    var inputValid = false
    
    var iconShouldEnable = false {
        didSet {
            if iconShouldEnable {
                sendIcon.alpha = 1
            } else {
                sendIcon.alpha = 0.3
            }
        }
    }
    
    var bottomViewOffset: CGFloat = 0 {
        didSet {
            bottomView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-bottomViewOffset)
            }
            fullScrollView.setNeedsLayout()
            fullScrollView.layoutIfNeeded()
        }
    }
    
    lazy var bgImageView: UIImageView = {
        var bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        bgImageView.clipsToBounds = true
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    
    lazy var titleView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "AI-Chatbot"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = UIColor(hexString: "#477a85")
        label.textAlignment = .center
        return label
    }()
    
    lazy var settingButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gear")
        imageView.alpha = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSetting)))
        return imageView
    }()
    
    lazy var fullScrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    lazy var scrollContent: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var bottomView: UIView = {
        var view = UIView()
        return view
    }()
    
    lazy var proImage: UIImageView = {
        var image = UIImageView()
        return image
    }()
    
    lazy var textView: AutoExpendTextView = {
        var textView = AutoExpendTextView()
        textView.maxHeight = 168
        textView.minHeight = 40
        textView.text = "Send message here."
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 18)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 4
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    lazy var sendIcon: UIImageView = {
        var icon = UIImageView()
        icon.image = UIImage(systemName: "paperplane.circle")
        icon.isUserInteractionEnabled = true
        icon.alpha = 0.3
        return icon
    }()
    
    lazy var grayLine: UIView = {
        var line = UIView()
        line.backgroundColor = .black.withAlphaComponent(0.5)
        return line
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedModel = try? functionHelper.loadSettingModel() {
            locadSavedModel = savedModel
        }
        functionHelper.api.apiKey = locadSavedModel.apiKey
        
        setUpViews()
        addActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingButton.alpha = 1
        addKeyBoardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if locadSavedModel.apiKey.isEmpty {
            initiateSampleCell()
            openSetting()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyBoardObserver()
    }
    
    
    private func addActions() {
        textView.delegate = self
        functionHelper.delegate = self
        
        sendIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendRequest)))
    }
    
    @objc func sendRequest() {
        
        guard iconShouldEnable, let question = textView.text else { return }
        
        iconShouldEnable = false
        inputValid = false
        
        let cell = QuestionAndAnswerView(
            questionText: "\(question)",
            questionColor: locadSavedModel.questionColor,
            answerText: "Loading...",
            answerColor: locadSavedModel.answerColor,
            proImage: locadSavedModel.proFile,
            botImage: locadSavedModel.robotFile)
        scrollContent.addSubview(cell)
        
        if questionAndAnswerCells.count == 0 {
            cell.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
                make.height.equalTo(cell.totalHeight)
                sizeConstraint = make.bottom.equalTo(scrollContent.snp.bottom).constraint
            }
        } else {
            if let view = questionAndAnswerCells.last {
                
                sizeConstraint?.deactivate()
                
                cell.snp.makeConstraints { make in
                    make.top.equalTo(view.snp.bottom)
                    make.leading.trailing.equalToSuperview()
                    make.height.equalTo(cell.totalHeight)
                    sizeConstraint = make.bottom.equalTo(scrollContent.snp.bottom).constraint
                }
            }
        }
        questionAndAnswerCells.append(cell)
        
        if bottomViewOffset == ChatDefinedFrame.safeBottomHeight {
            textView.text = "Please wait a moment."
            textView.textColor = .lightGray
            textView.contentSize.height = 40
            bottomView.snp.updateConstraints { make in
                make.height.equalTo(56)
            }
            fullScrollView.setNeedsLayout()
            fullScrollView.layoutIfNeeded()
            self.fullScrollView.setContentOffset(CGPoint(x: 0, y: max(0,(scrollContent.frame.height - fullScrollView.frame.height))), animated: true)
        } else {
            textView.resignFirstResponder()
            textView.text = "Please wait a moment."
            self.fullScrollView.setContentOffset(CGPoint(x: 0, y: max(0,(scrollContent.frame.height - fullScrollView.frame.height))), animated: true)
        }
        textView.isUserInteractionEnabled = false
        
        Task {
            await functionHelper.sendRequestAndUpdateCell(inputText: question,cell: cell) { [weak self] in
                guard let strongSelf = self else { return }
                DispatchQueue.main.async {
                    strongSelf.textView.isUserInteractionEnabled = true
                    strongSelf.textView.text = "Send message here."
                }
            }
        }
    }
    
    @objc private func openSetting() {
        
        let vc = BottomAlertViewController(presentTransitionDelegate: self, proImage: locadSavedModel.proFile, botImage: locadSavedModel.robotFile, apiKey: locadSavedModel.apiKey)
        
        vc.updataQuestionText = { [weak self](questionColor: UIColor) in
            guard let strongSelf = self else { return }
            for i in strongSelf.questionAndAnswerCells {
                i.questionTextView.textColor = questionColor
            }
            strongSelf.locadSavedModel.questionColor = questionColor
        }
        
        vc.updateAnswerText = { [weak self](answerColor: UIColor) in
            guard let strongSelf = self else { return }
            for i in strongSelf.questionAndAnswerCells {
                i.answerTextView.textColor = answerColor
            }
            strongSelf.locadSavedModel.answerColor = answerColor
        }
        
        vc.updateMainView = { [weak self](titleColor: UIColor, image: UIImage, isFromaddButton: (Bool,Int)) in
            guard let strongSelf = self else { return }
            if isFromaddButton.0 {
                strongSelf.titleLabel.textColor = titleColor
                strongSelf.bgImageView.image = image
                strongSelf.locadSavedModel.backgroundFile = image
            } else {
                if isFromaddButton.1 == 1 {
                    for i in strongSelf.questionAndAnswerCells {
                        i.proImage.image = image
                    }
                    strongSelf.locadSavedModel.proFile = image
                    strongSelf.proImage.image = image
                } else if isFromaddButton.1 == 2 {
                    for i in strongSelf.questionAndAnswerCells {
                        i.robotImage.image = image
                    }
                    strongSelf.locadSavedModel.robotFile = image
                }
            }
            
        }
        
        vc.saveButtonTapped = { [weak self](apiKey: String) in
            guard let strongSelf = self else { return }
            strongSelf.locadSavedModel.apiKey = apiKey
            strongSelf.functionHelper.saveSettingInfo(model: strongSelf.locadSavedModel)
            strongSelf.functionHelper.api.apiKey = apiKey
            if !apiKey.isEmpty {
                strongSelf.sampleCell2?.removeFromSuperview()
                strongSelf.sampleCell1?.removeFromSuperview()
                strongSelf.sampleCell1 = nil
                strongSelf.sampleCell2 = nil
                strongSelf.textView.isUserInteractionEnabled = true
                strongSelf.textView.text = "Send message here."
            }
            
        }
        
        settingButton.alpha = 0.3
        self.present(vc, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //输入框状态
        if !iconShouldEnable && textView.text == "Send message here." {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //更新高度约束
        bottomView.snp.updateConstraints { make in
            make.height.equalTo(textView.intrinsicContentSize.height + 16)
        }
        //判断输入是否有效
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        if textView.text.trimmingCharacters(in: whitespace).isEmpty {
            iconShouldEnable = false
            inputValid = false
        } else {
            iconShouldEnable = true
            inputValid = true
        }
    }
    
    private func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeKeyBoardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        settingButton.isUserInteractionEnabled = false
        settingButton.alpha = 0.3
        //输入框掉起时更新约束
        let keyboardinfo = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        keyboardheight = (keyboardinfo as AnyObject).cgRectValue.size.height
        
        bottomViewOffset = keyboardheight
        
        let bottomOffset = CGPoint(x: 0,y: max(0,(scrollContent.frame.height - fullScrollView.frame.height)))
        self.fullScrollView.setContentOffset(bottomOffset, animated: false)
        
    }
    
    @objc func keyboardHide(_ noti: Notification) {
        settingButton.isUserInteractionEnabled = true
        settingButton.alpha = 1
        if !inputValid {
            textView.text = "Send message here."
            textView.textColor = .lightGray
            textView.contentSize.height = 40
            bottomView.snp.updateConstraints { make in
                make.height.equalTo(56)
            }
        }
        bottomViewOffset = ChatDefinedFrame.safeBottomHeight
    }
    
    private func initiateSampleCell() {
        let cell = QuestionAndAnswerView(
            questionText: "(Here are sample text and style) Hello, how can I start using this app?",
            questionColor: locadSavedModel.questionColor,
            answerText: "Oh, it's easy. If you can't send a message right now, it means you didn't enter your APIKey. Just go to Settings, enter and save.",
            answerColor: locadSavedModel.answerColor,
            proImage: locadSavedModel.proFile,
            botImage: locadSavedModel.robotFile)
        cell.stopDotAnimination()
        let cell2 = QuestionAndAnswerView(
            questionText: "I see, but what is my APIKey",
            questionColor: locadSavedModel.questionColor,
            answerText: "Haha, I knew you were going to ask this. Just go to Settings, there are instructions, and in a few simple steps you can get your APIKey and we'll have fun.",
            answerColor: locadSavedModel.answerColor,
            proImage: locadSavedModel.proFile,
            botImage: locadSavedModel.robotFile)
        cell2.stopDotAnimination()
        scrollContent.addSubview(cell)
        scrollContent.addSubview(cell2)
        cell.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(cell.totalHeight)
            make.bottom.equalTo(scrollContent.snp.bottom)
        }
        cell2.snp.makeConstraints { make in
            make.top.equalTo(cell.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(cell2.totalHeight)
            sizeConstraint = make.bottom.equalTo(scrollContent.snp.bottom).constraint
        }
        sampleCell1 = cell
        sampleCell2 = cell2
        
        textView.isUserInteractionEnabled = false
        textView.text = "Enter APIKey first."
    }
    
    private func setUpViews() {
        bgImageView.image = locadSavedModel.backgroundFile
        proImage.image = locadSavedModel.proFile
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        bgImageView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(ChatDefinedFrame.navViewHeight)
        }
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        titleView.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.height.width.equalTo(40)
            make.centerY.equalTo(titleLabel)
        }
        titleView.bringSubviewToFront(settingButton)
        
        bgImageView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-ChatDefinedFrame.safeBottomHeight)
            make.height.equalTo(56)
        }
        bottomView.addSubview(proImage)
        bottomView.addSubview(textView)
        bottomView.addSubview(sendIcon)
        proImage.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        sendIcon.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
        textView.snp.makeConstraints { make in
            make.leading.equalTo(proImage.snp.trailing).offset(8)
            make.trailing.equalTo(sendIcon.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        
        bgImageView.addSubview(grayLine)
        grayLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
            make.height.equalTo(1)
        }
        
        bgImageView.addSubview(fullScrollView)
        fullScrollView.addSubview(scrollContent)
        fullScrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleView.snp.bottom).offset(4)
            make.bottom.equalTo(bottomView.snp.top).offset(-2)
        }
        scrollContent.snp.makeConstraints { make in
            make.leading.trailing.equalTo(bgImageView)
            make.top.bottom.equalTo(fullScrollView)
        }
        
    }
    
}

extension ChatGPTMainViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        return present
    }
}
