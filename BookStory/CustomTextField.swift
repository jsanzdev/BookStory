//
//  CustomTextField.swift
//  BookStory
//
//  Created by Jesus Sanz on 4/3/23.
//

import SwiftUI

struct CustomTextField: View {
    let label:String?
    let placeholder:String
    @Binding var text:String
    var validation:((String) -> String?)?
    
    @State var error = false
    @State var message = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            if let label {
                Text(label)
                    .font(.headline)
                    .padding(.leading, 3)
            }
            HStack(alignment: .top) {
                TextField(placeholder, text: $text)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                            .opacity(0.5)
                    )
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark")
                            .symbolVariant(.circle)
                            .symbolVariant(.fill)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .opacity(0.5)
                }
            }
            .padding(.horizontal, 3)
            .background {
                Rectangle()
                    .stroke(lineWidth: 2)
                    .fill(.red)
                    .opacity(error ? 1.0 : 0.0)
            }
            if error {
                Text(message)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: text) { newValue in
            if let validation, let message = validation(newValue) {
                self.message = message
                self.error = true
            } else {
                self.error = false
            }
        }
    }
    
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(label: "", placeholder: "Enter your email address", text: .constant(""), validation: { value in return nil })
    }
}
