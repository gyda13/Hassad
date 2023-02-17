//
//  LoginView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//


import SwiftUI

struct LoginView: View {
  @State var email = ""
  @State var password = ""
  @State private var showingLoginErrorAlert = false
  @EnvironmentObject var auth: Auth
   
    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .padding()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)
                SecureField("Password", text: $password)
                    .padding()
                    .padding(.horizontal)
                Button("Log In") {
                    login()
                }
                .disabled(email.isEmpty || password.isEmpty)
                
                NavigationLink(destination: SignUpView()) {
                    Text("dont have an account? SignUp")
                        .foregroundColor(.black)
                    
                }.navigationBarBackButtonHidden(true)
            }
           
            .alert(isPresented: $showingLoginErrorAlert) {
                Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
            }
            .navigationTitle("Log In")
            .navigationBarBackButtonHidden(true)
        }
    }
  func login() {
      
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
    
  }
}

struct Login_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
