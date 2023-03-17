//
//  QuestionAndAnswerView.swift
//  ChatGPT
//
//  Created by nirvana on 3/5/23.
//

import UIKit

class QuestionAndAnswerView: UIView {
    
    var retryClosure: (()-> Void)?
        
    var totalHeight: CGFloat {
        max(questionTextHeight,30) + max(answerTextHeight,30) + 75
    }
    var questionTextHeight: CGFloat = 0
    var answerTextHeight: CGFloat = 0
    
    lazy var questionView: UIView = {
        var view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.1)
        return view
    }()
    
    lazy var proImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        return imageView
    }()
    
    lazy var questionTextView: AutoExpendTextView = {
        var textView = AutoExpendTextView()
        textView.font = .boldSystemFont(ofSize: 17)
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        return textView
    }()
    
    lazy var answerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.1)
        return view
    }()
    
    lazy var robotImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "robot")
        return imageView
    }()
    
    lazy var answerTextView: AutoExpendTextView = {
        var textView = AutoExpendTextView()
        textView.font = .boldSystemFont(ofSize: 17)
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        return textView
    }()
    
    lazy var dotLoadingView: DotLoadingView = {
        let view = DotLoadingView()
        return view
    }()
    
    lazy var errorLabel: UILabel = {
        return UILabel()
    }()
    
    init(questionText: String, questionColor: UIColor, answerText: String, answerColor: UIColor, proImage: UIImage, botImage: UIImage) {
        super.init(frame: .zero)
        
        questionTextView.text = questionText
        questionTextView.textColor = questionColor
        answerTextView.text = answerText
        answerTextView.textColor = answerColor
        
        self.proImage.image = proImage
        self.robotImage.image = botImage
        
        questionTextHeight = questionText.height(withFont: .boldSystemFont(ofSize: 17), maximumWidth: ChatDefinedFrame.screenWidth - 77)
        answerTextHeight = answerText.height(withFont: .boldSystemFont(ofSize: 17), maximumWidth: ChatDefinedFrame.screenWidth - 77)
        
        errorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(retryAction)))
        
        setUpUI()
    }
    
    func stopDotAnimination() {
        dotLoadingView.stopAnimating()
        dotLoadingView.isHidden = true
    }
    
    func reStartDotAnimination() {
        dotLoadingView.startAnimating()
        dotLoadingView.isHidden = false
    }
    
    func showNetWorkErrorText(error: CustomError) {
        errorLabel.isHidden = false
        stopDotAnimination()
        switch error {
        case .netWorkLost, .defaultError:
            errorLabel.text = "Network error, click here to try again!"
        case .responseUnexpected(let int):
            errorLabel.text = "Error code:\(int), click here to try again!"
        default:
            errorLabel.text = "Unknown error, email me please."
        }
        errorLabel.textColor = .red
        errorLabel.font = .boldSystemFont(ofSize: 17)
        errorLabel.textAlignment = .center
        errorLabel.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.stopDotAnimination()
            
            strongSelf.answerView.addSubview(strongSelf.errorLabel)
            strongSelf.errorLabel.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(strongSelf.answerView.snp.bottom)
                make.height.equalTo(30)
            }
        }
    }
    
    @objc func retryAction() {
        errorLabel.isHidden = true
        reStartDotAnimination()
        retryClosure?()
    }
    
    func updateUI(answerText: String) {
        answerTextHeight = answerText.height(withFont: .boldSystemFont(ofSize: 17), maximumWidth: ChatDefinedFrame.screenWidth - 77)
        answerView.snp.updateConstraints { make in
            make.height.equalTo(max(answerTextHeight,30) + 45)
        }
        answerTextView.snp.updateConstraints { make in
            make.height.equalTo(answerTextHeight)
        }
        answerTextView.text = answerText
    }
    
    private func setUpUI() {
        
        addSubview(questionView)
        questionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo( max(questionTextHeight,30) + 30)
        }
        questionView.addSubview(proImage)
        questionView.addSubview(questionTextView)
        proImage.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        questionTextView.snp.makeConstraints { make in
            make.leading.equalTo(proImage.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            if questionTextHeight < 30 {
                make.centerY.equalTo(proImage.snp.centerY)
            } else {
                make.top.equalToSuperview().offset(15)
            }
            make.height.equalTo(questionTextHeight)
        }
        
        addSubview(answerView)
        answerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(questionView.snp.bottom)
            make.height.equalTo(max(answerTextHeight,30) + 45)
        }
        answerView.addSubview(dotLoadingView)
        answerView.addSubview(robotImage)
        answerView.addSubview(answerTextView)
        robotImage.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
        }
        answerTextView.snp.makeConstraints { make in
            make.leading.equalTo(robotImage.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(answerTextHeight)
        }
        dotLoadingView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalTo(answerTextView)
            make.height.equalTo(10)
        }
        dotLoadingView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

