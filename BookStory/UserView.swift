//
//  UserView.swift
//  BookStory
//
//  Created by Jesus Sanz on 5/3/23.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    @ObservedObject var userVM:UserViewModel
    
    @FocusState var field:DetailField?
    
    @Environment(\.dismiss) var dismiss
    
    @State var userUpdated = false
    @State var showAlert = false
    @State var alertMsg = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    CustomTextField(label: "Name",
                                    placeholder: "Enter your Name",
                                    text: $userVM.name,
                                    validation: booksVM.validateEmpty)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                    .focused($field, equals: .name)
                    CustomTextField(label: "Email",
                                    placeholder: "Enter your email address",
                                    text: $userVM.email,
                                    validation: booksVM.validateEmail)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($field, equals: .email)
                    .keyboardType(.emailAddress)
                    CustomTextField(label: "Address",
                                    placeholder: "Enter your Address",
                                    text: $userVM.location,
                                    validation: booksVM.validateEmpty)
                    .textContentType(.fullStreetAddress)
                    .textInputAutocapitalization(.words)
                    .focused($field, equals: .location)
                } header: {
                    Text("Edit Your Details")
                }
                Button(role: .destructive)  {
                    booksVM.user = User(email: "")
                    booksVM.screenState = .loginScreen
                } label : {
                    Label("Logout", systemImage: "power")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Your Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button {
                            field?.prev()
                        } label: {
                            Image(systemName: "chevron.up")
                        }
                        Button {
                            field?.next()
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                        Spacer()
                        Button {
                            field = nil
                        } label: {
                            Image(systemName: "keyboard")
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            if await booksVM.createUser(user: User(name: userVM.name, location: userVM.location, email: userVM.email, role: .user)) {
                                userUpdated.toggle()
                                alertMsg = "Now you can login"
                            } else {
                                showAlert.toggle()
                                alertMsg = "Error, try again later"
                            }
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
            .alert("User Updated", isPresented: $userUpdated) {
                Button {
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
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(userVM: UserViewModel(user: .userTest))
            .environmentObject(BooksViewModel())
    }
}
