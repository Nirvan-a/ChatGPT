//
//  FunctionHelper.swift
//  ChatGPT
//
//  Created by nirvana on 3/11/23.
//

import Foundation
import EasyStash

class FunctionHelper {
    
    var storage: Storage? = nil
    var textFieldclosure: (()-> Void)? = nil
    var delegate: ChatGPTMainViewController? = nil

    let api: ChatGPTAPI
    init() {
        self.api = ChatGPTAPI()
        
        var options: Options = Options()
        options.folder = "Users"
        self.storage = try? Storage(options: options)
    }
    
    private var historyMessages: [[String: String]] = []
    private var tokenAmountLists: [Int] = []
    private var currentTokens = 0
    
    func sendRequestAndUpdateCell(inputText: String, cell: QuestionAndAnswerView, closure: (()->Void)?) async {
        questionTokenAndHistory(inputText)
        textFieldclosure = closure
        await requestAndUpdateCell(inputText, cell)
    }
    
    func sendRequestAndUpdateCellWithoutStream(inputText: String, cell: QuestionAndAnswerView) async {
        await requestAndUpdateCellWithoutStream(inputText, cell)
    }
    
    func saveSettingInfo(model: LocalSavedModel) {
        guard let storage = storage else { return }
        print(model)
        DispatchQueue.global().async {
            do {
                try storage.save(object: model.proFile, forKey: "proFileImage")
                try storage.save(object: model.robotFile, forKey: "botFileImage")
                try storage.save(object: model.backgroundFile, forKey: "bgFileImage")
                
                try storage.save(object: APIKey(apiKey: model.apiKey), forKey: "APIKey")
                
                let data1 = try NSKeyedArchiver.archivedData(withRootObject: model.questionColor, requiringSecureCoding: false)
                let data2 = try NSKeyedArchiver.archivedData(withRootObject: model.answerColor, requiringSecureCoding: false)
                try storage.save(object: data2, forKey: "answerColor")
                try storage.save(object: data1, forKey: "questionColor")
            } catch {
                print(error)
            }
        }
    }
    
    func loadSettingModel() throws -> LocalSavedModel {
        
        guard let storage = storage else { return LocalSavedModel() }

        let key = try storage.load(forKey: "APIKey",as: APIKey.self)
        let profile: UIImage = try storage.load(forKey: "proFileImage")
        let robot: UIImage = try storage.load(forKey: "botFileImage")
        let questionColor: Data = try storage.load(forKey: "questionColor")
        let answerColor: Data = try storage.load(forKey: "answerColor")
        let bgImage: UIImage = try storage.load(forKey: "bgFileImage")
        
        let color1 = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(questionColor) as? UIColor
        let color2 = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(answerColor) as? UIColor

        return LocalSavedModel(apiKey: key.apiKey, questionColor: color1 ?? .white, answerColor: color2 ?? .white, proFile: profile, backgroundFile: bgImage, robotFile: robot)
    }
    
    private func questionTokenAndHistory(_ inputText: String) {
        historyMessages.append(["role": "user", "content": inputText])

        let generatedQuestionToken = inputText.estimateTokens()
        currentTokens += generatedQuestionToken
        tokenAmountLists.append(generatedQuestionToken)
        
        while (currentTokens > 3072) {
            currentTokens -= tokenAmountLists.removeFirst()
            historyMessages.removeFirst()
        }
        api.historyMessages = historyMessages
    }
    
    private func answerTokenAndHistory(_ mutableText: String) {
        
        historyMessages.append(["role": "assistant", "content": mutableText])
        let generatedAnswerTokens = mutableText.estimateTokens()
        currentTokens += generatedAnswerTokens
        tokenAmountLists.append(generatedAnswerTokens)
    }
    
    private func initErrorLabelAction(_ cell: QuestionAndAnswerView, _ inputText: String) {
        DispatchQueue.main.async {
            cell.retryClosure = { [weak self] in
                guard let strongSelf = self else { return }
                Task{
                    await strongSelf.requestAndUpdateCell(inputText, cell)
                }
            }
        }
    }
    
    private func requestAndUpdateCell(_ inputText: String, _ cell: QuestionAndAnswerView) async {
        do {
            //requestAndUpdate:
            var mutableText = ""
            var haveFinished = false
            let messageLines = try await api.sendMessageStream(text: inputText)
            for try await text in messageLines {
                if text != "stop" {
                    mutableText += text
                    updateCellAndScrollWithText(currentText: (mutableText.trimmingCharacters(in: .whitespacesAndNewlines)), cell: cell)
                } else if text == "stop" {
                    haveFinished = true
                }
            }
            if haveFinished {
                DispatchQueue.main.async {
                    cell.stopDotAnimination()
                }
                textFieldclosure?()
                answerTokenAndHistory(mutableText)
            } else {
                initErrorLabelAction(cell, inputText)
                await cell.showNetWorkErrorText(error: .netWorkLost)
            }
        } catch {
            initErrorLabelAction(cell, inputText)
            if let customError = error as? CustomError {
                await cell.showNetWorkErrorText(error: customError)
            } else {
                await cell.showNetWorkErrorText(error: .defaultError)
            }
            
        }
    }
    
    private func requestAndUpdateCellWithoutStream(_ inputText: String, _ cell: QuestionAndAnswerView) async {
        do {
            questionTokenAndHistory(inputText)
            
            let message =  try await api.sendMessage(inputText)
            updateCellAndScrollWithText(currentText: message, cell: cell)
            
            answerTokenAndHistory(message)
            
        } catch {
            initErrorLabelAction(cell, inputText)
            if let customError = error as? CustomError {
                await cell.showNetWorkErrorText(error: customError)
            } else {
                await cell.showNetWorkErrorText(error: .defaultError)
            }
        }
    }
    
    private func updateCellAndScrollWithText(currentText: String, cell: QuestionAndAnswerView) {
        guard let mainController = delegate else { return }
        
        let primHeight = cell.totalHeight
        
        DispatchQueue.main.async {
            cell.updateUI(answerText: currentText)
            
            cell.snp.updateConstraints { make in
                make.height.equalTo(cell.totalHeight)
            }
            mainController.fullScrollView.setNeedsLayout()
            mainController.fullScrollView.layoutIfNeeded()
            if cell.totalHeight != primHeight {
                mainController.fullScrollView.setContentOffset(CGPoint(x: 0, y: max(0,(mainController.scrollContent.frame.height - mainController.fullScrollView.frame.height))),animated: true)
            }
        }
    }
    
}
