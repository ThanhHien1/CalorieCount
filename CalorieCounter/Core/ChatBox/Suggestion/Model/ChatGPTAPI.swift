//
//  ChatGPTAPI.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 24/5/24.
//

import Combine
import Foundation

class ChatGPTAPI {
    static let shared = ChatGPTAPI()
    private var subscriber: AnyCancellable?

    private init() {}

    func stream_chat(_ message: String, onDataUpdate: @escaping (String) -> Void) {
        self.subscriber?.cancel()
        self.subscriber = nil
        send(message)
//        var subscriber = ChatGPTWebViewStore.shared.$receivedMsg.sink { newStr in
//            onDataUpdate(newStr)
//        }
//        self.subscriber = subscriber
    }

    func send(_ message: String) {
        let s = "window.sendMsg('\(message)');"
        print("script:", s)
//        ChatGPTWebViewStore.shared.webView.evaluateJavaScript(s)
    }
}
