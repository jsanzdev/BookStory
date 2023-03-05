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
    
    var body: some View {
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
                Text("Your Details")
            }
        }
        .navigationTitle("Edit your details")
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
                    
                } label: {
                    Text("Save")
                }
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
