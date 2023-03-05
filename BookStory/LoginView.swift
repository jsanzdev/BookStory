//
//  LoginView.swift
//  BookStory
//
//  Created by Jesus Sanz on 4/3/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    
    @State var email = ""
    
    @State var createUser = false
    
    var body: some View {
        VStack {
            Text("BookStory Login")
                .font(.title)
            Image("BookStory_Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .cornerRadius(25)
            HStack {
                CustomTextField(label: "Email",
                                placeholder: "Enter your email address",
                                text: $email,
                                validation: booksVM.validateEmail)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
            }
            Button("Login") {
                Task {
                    do {
                        if await booksVM.loginUser(email: email) {
                            booksVM.screenState = .userLogged
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .font(.title)
            .padding()
            Spacer()
            Button {
                createUser.toggle()
            } label: {
                Text("Don't have an account yet?")
            }
            .popover(isPresented: $createUser) {
                NewUserView()
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(BooksViewModel())
    }
}
