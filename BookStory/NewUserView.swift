//
//  NewUserView.swift
//  BookStory
//
//  Created by Jesus Sanz on 5/3/23.
//

import SwiftUI

struct NewUserView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    
    @FocusState var field:DetailField?
    
    @Environment(\.dismiss) var dismiss
    
    @State var email = ""
    @State var name = ""
    @State var location = ""
    
    @State var showAlert = false
    @State var userCreated = false
    @State var alertMsg = ""
    
    
    
    var body: some View {
        VStack {
            Text("Create your account")
                .font(.title)
            Form {
                    CustomTextField(label: "Name",
                                    placeholder: "Enter your Name",
                                    text: $name,
                                    validation: booksVM.validateEmpty)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .focused($field, equals: .name)
                    CustomTextField(label: "Email",
                                    placeholder: "Enter your email address",
                                    text: $email,
                                    validation: booksVM.validateEmail)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($field, equals: .email)
                        .keyboardType(.emailAddress)
                    CustomTextField(label: "Address",
                                    placeholder: "Enter your Address",
                                    text: $location,
                                    validation: booksVM.validateEmpty)
                        .textContentType(.fullStreetAddress)
                        .textInputAutocapitalization(.words)
                        .focused($field, equals: .location)
            }
            HStack {
                Button(role: .destructive) {
                    dismiss()
                } label : {
                    Text("Cancel")
                }
                .buttonStyle(.borderedProminent)
                .backgroundStyle(.red)
                Button {
                    Task {
                        if await booksVM.loginUser(email: email) {
                            showAlert.toggle()
                            alertMsg = "User already exists, please login or use a different email address"
                        } else {
                            if await booksVM.createUser(user: User(name: name, location: location, email: email, role: .user)) {
                                userCreated.toggle()
                                alertMsg = "Now you can login"
                            } else {
                                showAlert.toggle()
                                alertMsg = "Error, try again later"
                            }
                        }
                    }
                } label: {
                    Text("Sign Up")
                }
                .buttonStyle(.borderedProminent)
            }
            .alert("User Registered", isPresented: $userCreated) {
                Button {
                    dismiss()
                } label: {
                    Text("OK")
                }
            } message: {
                Text(alertMsg)
            }
            .alert("Error", isPresented: $showAlert) {
                Button {
                    
                } label: {
                    Text("OK")
                }
            } message: {
                Text(alertMsg)
            }
        }
        .padding()
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView()
            .environmentObject(BooksViewModel())
    }
}
