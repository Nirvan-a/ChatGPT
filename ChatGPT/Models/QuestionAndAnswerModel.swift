//
//  QuestionAndAnswerModel.swift
//  ChatGPT
//
//  Created by nirvana on 3/10/23.
//

import Foundation

struct ReceivedResponse: Codable {
    let id: String?
    let object: String?
    let created: Int?
    let choices: [ChoicesResponse]?
    let usage: UsageResponse?
}

struct ChoicesResponse: Codable {
    let index: Int?
    let delta: MessageResponse?
    let finish_reason: String?
}
struct MessageResponse: Codable {
    let role: String?
    let content: String?
}
struct UsageResponse: Codable {
    let prompt_tokens: Int?
    let completion_tokens: Int?
    let total_tokens: Int?
}

struct ReceivedResponseWithoutStream: Codable {
    let id: String?
    let object: String?
    let created: Int?
    let choices: [ChoicesResponseWithoutStream]?
    let usage: UsageResponse?
}
struct ChoicesResponseWithoutStream: Codable {
    let index: Int?
    let message: MessageResponse?
    let finish_reason: String?
}
//{
//  "id": "chatcmpl-123",
//  "object": "chat.completion",
//  "created": 1677652288,
//  "choices": [{
//    "index": 0,
//    "message": {
//      "role": "assistant",
//      "content": "\n\nHello there, how may I assist you today?",
//    },
//    "finish_reason": "stop"
//  }],
//  "usage": {
//    "prompt_tokens": 9,
//    "completion_tokens": 12,
//    "total_tokens": 21
//  }
//}

