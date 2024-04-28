//
//  FormValidator.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import Foundation
import SwiftUI

class FormValidator {
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func onValidateEmail(email: String) -> String {
       return email.isEmpty || isValidEmail(email: email) ? "" : "Email is not in correct format"
    }
    
    static func isValid(email: String, password: String) -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        return true
    }
}


struct CustomTextField: View {
    var title:String
    @Binding var text:String
    var textContentType:UITextContentType?
    var keyboardType: UIKeyboardType = .default
    
    var focusedField: FocusState<FocusField?>.Binding
    var focusFieldType: FocusField
    
    @Binding var strokeColor:Color
    
    @State private var isSecure: Bool = true
    var isPassword: Bool = false
    
    var body: some View {
        HStack(spacing: Vconst.DESIGN_HEIGHT_RATIO * 12) {
            if isPassword {
                Group{
                    if isSecure{
                        SecureField(title, text: $text)
                            .multilineTextAlignment(.leading)
                            .truncationMode(.tail)
                            .textContentType(textContentType)
                            .keyboardType(keyboardType)
                            .focused(focusedField, equals: focusFieldType)
                            .textInputAutocapitalization(.never)
                    }else{
                        TextField(title, text: $text)
                            .multilineTextAlignment(.leading)
                            .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                            .textContentType(textContentType)
                            .keyboardType(keyboardType)
                            .focused(focusedField, equals: focusFieldType)
                            .textInputAutocapitalization(.never)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isSecure)
                Button(action: {
                    isSecure.toggle()
                }, label: {
                    Image(systemName: !isSecure ? "eye.slash" : "eye" )
                        .foregroundColor(.gray)
                })
            } else {
                TextField(title, text: $text)
                    .multilineTextAlignment(.leading)
                    .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                    .textContentType(textContentType)
                    .keyboardType(keyboardType)
                    .focused(focusedField, equals: focusFieldType)
                    .textInputAutocapitalization(.never)
            }
            
        }
        .padding(.horizontal, Vconst.DESIGN_HEIGHT_RATIO * 12)
        .frame(height: Vconst.DESIGN_HEIGHT_RATIO * 47.0)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(strokeColor, lineWidth: 1))
        .frame(maxWidth: .infinity)
    }
}
