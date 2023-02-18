//
//  SignUpView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import SwiftUI

struct SignUpView: View {
  @State var businessname = ""
  @State var email = ""
  @State var password = ""
  @EnvironmentObject var auth: Auth
     
  @State private var showingUserSaveErrorAlert = false
    @State private var showingLoginErrorAlert = false

  var body: some View {

        VStack{

            TextField("Business Name", text: $businessname)
                .padding()
                .padding(.horizontal)

                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .padding(.horizontal)


                    SecureField("Password", text: $password)
                .padding()
                .padding(.horizontal)

            NavigationLink(destination: ProductView() .onAppear {
                saveUser()
            }) {
                Text("Sign Up")
                    .foregroundColor(.black)
            }
            
//            Button("Sign Up") {
//              saveUser()
//            }
            .disabled(businessname.isEmpty || email.isEmpty || password.isEmpty)

            NavigationLink(destination: LoginView()) {
                Text("already have an account? Log In")
                    .foregroundColor(.black)
            }
        }
      .navigationBarTitle("SignUp")


    .alert(isPresented: $showingUserSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the user"))
    }
    .alert(isPresented: $showingLoginErrorAlert) {
        Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
    }

  }


  func saveUser() {
      let createUser = CreateUserData(businessname: businessname, email: email, password: password)
      ResourceRequest<User>(resourcePath: "users").saveUser(createUser) { result in
          switch result {
          case .success:
              auth.login(email: email, password: password) {
                  result in
                  switch result {
                  case .success:
                      break
                  case .failure:
                      DispatchQueue.main.async {
                          self.showingLoginErrorAlert = true
                      }
                  }
              }
          case .failure:
              DispatchQueue.main.async {
                  self.showingUserSaveErrorAlert
              }
          }
      }
  }


}

struct SignUpView_Previews: PreviewProvider {
  static var previews: some View {
      SignUpView()
  }
}
