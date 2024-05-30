//
//  Chat.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 24/5/24.
//

import SwiftUI

struct Chat: View {
    @StateObject var viewModel = SuggestViewModel()
    @State var messageInput: String = ""
    @Namespace var bottomID
    
    var body: some View {
        VStack {
            Text("Chat Box")
                .fontWeight(.medium)
                .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                .font(.title2)
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.messages) { message in
                                MessageRow(message: message, viewModel: viewModel)
                            }
                            Spacer().id(bottomID)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                    .onChange(of: viewModel.messages.last?.text) { _ in
                        proxy.scrollTo(bottomID)
                    }
                }
            }
            HStack{
                Button {
                    viewModel.sendMessage(text: "Gợi ý thực đơn hôm nay!", type: .myMessage)
                } label: {
                    Text("Gợi ý thực đơn hôm nay!")
                        .padding(10)
                        .font(.system(size: 12.0))
                        .background(Color(.systemGray4))
                        .foregroundColor(Color(.black))
                        .opacity(0.6)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 16.0)
                        .padding(.vertical, 8.0)
                }
                Spacer()
            }
            HStack {
                TextField("Type a message...", text: $messageInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 10)
                Button(action: {
                    viewModel.sendMessage(text: messageInput, type: .myMessage)
                    messageInput = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .disabled(messageInput.isEmpty)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
            .navigationTitle("Chatbot").navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
            }
        }
    }

    func scrollToBottom() {
        withAnimation {
            if viewModel.messages.count > 0 {
                let lastIndex = viewModel.messages.count - 1
                let lastMessage = viewModel.messages[lastIndex]
                let lastMessageId = lastMessage.id
                let lastMessageIndex = viewModel.messages.firstIndex(where: { $0.id == lastMessageId })
                if let lastMessageIndex = lastMessageIndex {
                    let lastMessageOffset = CGFloat(lastMessageIndex) * 100
                    let maxOffset = UIScreen.main.bounds.height * 2
                    if lastMessageOffset < maxOffset {
                        let offset = CGPoint(x: 0, y: lastMessageOffset)
                        UIScrollView.appearance().setContentOffset(offset, animated: true)
                    }
                }
            }
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
