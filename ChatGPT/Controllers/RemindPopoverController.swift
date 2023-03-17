//
//  RemindPopoverController.swift
//  ChatGPT
//
//  Created by nirvana on 3/13/23.
//
import UIKit

class RemindPopverController: UIViewController {
    
    var popWindowHeight: CGFloat = 0
    var popwindowWidth: CGFloat = 0
    
    private var titleHeight1: CGFloat = 0
    private var titleHeight2: CGFloat = 0
    private var contentHeight1: CGFloat = 0
    private var contentHeight2: CGFloat = 0
    
    lazy var titleLabel1: UILabel = {
        var label = UILabel()
        label.text = "What's an APIKey?"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var titleLabel2: UILabel = {
        var label = UILabel()
        label.text = "How to get an APIKey?"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentLabel1: UITextView = {
        var label = UITextView()
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.isEditable = false
        label.isScrollEnabled = false
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset = .zero
        return label
    }()
    
    lazy var contentLabel2: UITextView = {
        var label = UITextView()
        label.textColor = .black
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.isEditable = false
        label.isScrollEnabled = false
        label.textContainer.lineFragmentPadding = 0
        label.textContainerInset = .zero
        return label
    }()
        
    init(width: CGFloat) {
        self.init()
        
        popwindowWidth = width
        
        let attributedString1 = NSMutableAttributedString(
            string: "An API key is passed by an application, which then calls the API to identify the user to access a website. Your input here is completely private, so you don't have to worry about your APIKEY being leaked.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        contentLabel1.attributedText = attributedString1
        
        let attributedString2 = NSMutableAttributedString(
            string: "Follow the link: https://platform.openai.com/overview to the official website of OpenAI (creator of chatGPT) to sign up.\nTap your profile icon to find 'View APIKeys' to receive a free APIKEY.",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        let foundRange = attributedString2.mutableString.range(of: "https://platform.openai.com/overview")
        if foundRange.location != NSNotFound {
            attributedString2.addAttribute(.link, value: "https://platform.openai.com/overview", range: foundRange)
        }
        contentLabel2.attributedText = attributedString2
        
        titleHeight1 = "What's an APIKey?".height(withFont: .boldSystemFont(ofSize: 16), maximumWidth: width - 20)
        titleHeight2 = "How to get a APIKey?".height(withFont: .boldSystemFont(ofSize: 16), maximumWidth: width - 20)
        contentHeight1 = attributedString1.height(with: width - 20)
        contentHeight2 = attributedString2.height(with: width - 20)
        popWindowHeight = titleHeight1 + titleHeight2 + contentHeight1 + contentHeight2 + 50
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel1)
        view.addSubview(titleLabel2)
        view.addSubview(contentLabel1)
        view.addSubview(contentLabel2)
        
        titleLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(titleHeight1)
        }
        contentLabel1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel1.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(contentHeight1)
        }
        titleLabel2.snp.makeConstraints { make in
            make.top.equalTo(contentLabel1.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(titleHeight2)
        }
        contentLabel2.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(contentHeight2)
        }
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
