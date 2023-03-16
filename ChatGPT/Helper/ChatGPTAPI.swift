//
//  ChatGPTAPI.swift
//  ChatGPT
//
//  Created by nirvana on 3/10/23.
//

import Foundation

class ChatGPTAPI {
    
    var apiKey: String = ""
        
    var historyMessages: [[String: String]] = []
    
    private let urlSession = URLSession.shared
    
    private let jsonDecoder = JSONDecoder()

    private var headers: [String: String] {
        ["Content-Type": "application/json",
         "Authorization": "Bearer \(apiKey)"]
    }
    
    private var urlRequest: URLRequest? {
        if  let url = URL(string: "https://api.openai.com/v1/chat/completions") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            headers.forEach {  urlRequest.setValue($1, forHTTPHeaderField: $0) }
            return urlRequest
        }
        return nil
    }
        
    private func jsonBody(stream: Bool = false) throws -> Data {
        let jsonBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": historyMessages,
            "temperature": 0.4,
            "max_tokens": 1024,
            "stream": stream
        ]
        return try JSONSerialization.data(withJSONObject: jsonBody)
    }
    
    func sendMessage(_ text: String) async throws -> String {
        
        guard var urlRequest = urlRequest else { throw CustomError.defaultError }
        
        urlRequest.httpBody = try jsonBody(stream: false)

        let (data, response) = try await urlSession.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw CustomError.netWorkLost
        }
        guard 200...299 ~= httpResponse.statusCode else {
            throw CustomError.responseUnexpected(httpResponse.statusCode)
        }

        do {
            let model = try self.jsonDecoder.decode(ReceivedResponseWithoutStream.self, from: data)
            let responseText = model.choices?.first?.message?.content ?? ""
            return responseText
        } catch {
            throw CustomError.modelLoadError
        }
    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error> {
        
        guard var urlRequest = urlRequest else { throw CustomError.defaultError }
        
        urlRequest.httpBody = try jsonBody(stream: true)

        let (result, response) = try await urlSession.bytes(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw CustomError.netWorkLost
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw CustomError.responseUnexpected(httpResponse.statusCode)
        }
        
        return AsyncThrowingStream<String, Error> { continuation in
            Task {
                do {
                    for try await line in result.lines {
                        if line.hasPrefix("data: "),
                           let data = line.dropFirst(6).data(using: .utf8),
                           let model = try? jsonDecoder.decode(ReceivedResponse.self, from: data) {
                            if let receivedText = model.choices?.first?.delta?.content {
                                continuation.yield(receivedText)
                            } else if let finishReason = model.choices?.first?.finish_reason {
                                continuation.yield(finishReason)
                            }
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: CustomError.netWorkLost)
                }
            }
        }
    }

}
