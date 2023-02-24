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
    @State private var confirmPassword: String = ""
  @State private var showingUserSaveErrorAlert = false
    @State private var showingLoginErrorAlert = false

  var body: some View {

      ZStack {
          Color("AccentColor").ignoresSafeArea()
          RoundedRectangle(cornerRadius: 33, style: .circular)
              .fill(Color("defultColor"))
              .frame(width: UIScreen.screenWidth, height: 666)
              .offset(x: 0, y: 130)
          VStack(spacing: 35){
              Spacer()
              Text("Get Started")
                  .font(.title2)
                  .fontWeight(.bold)
               
             
              TextField("\(Image(systemName: "envelope.fill")) Email Address", text: $email)
                  .frame(width: 323)
                  .padding()
                  .background(Color("textfields"))
                  .cornerRadius(14)
                  .overlay(RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("borders"), lineWidth: 1))

              
              TextField("\(Image(systemName: "person.fill")) Business Name", text: $businessname)
                  .frame(width: 323)
                  .padding()
                  .background(Color("textfields"))
                  .cornerRadius(14)
                  .overlay(RoundedRectangle(cornerRadius: 14)
                      .stroke(Color("borders"), lineWidth: 1))
              
              SecureField("\(Image(systemName: "lock.fill")) Password", text: $password)
                  .frame(width: 323)
                  .padding()
                  .background(Color("textfields"))
                  .cornerRadius(14)
                  .overlay(RoundedRectangle(cornerRadius: 14)
                      .stroke(Color("borders"), lineWidth: 1))
                 // .offset(x:0, y: 25)
              SecureField("\(Image(systemName: "lock.fill")) Confirm Password", text: $confirmPassword)
                  .frame(width: 323)
                  .padding()
                  .background(Color("textfields"))
                  .cornerRadius(14)
                  .overlay(RoundedRectangle(cornerRadius: 14)
                      .stroke(Color("borders"), lineWidth: 1))
      
                Button("Sign Up") {
                  saveUser()
                }
                .disabled(businessname.isEmpty || email.isEmpty || password.isEmpty || password != confirmPassword )
                .frame(width: 335.0, height: 30.0)
                .font(.title2)
                .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("darkBlue"))
                    .cornerRadius(17.5)

                NavigationLink(destination: LoginView()) {
                    Text("already have an account? Log In")
                        .foregroundColor(.accentColor)
                }.navigationBarBackButtonHidden(true)
            }
          .navigationBarTitle("SignUp")
          .navigationBarBackButtonHidden(true)

        .alert(isPresented: $showingUserSaveErrorAlert) {
          Alert(title: Text("Error"), message: Text("There was a problem saving the user"))
        }
        .alert(isPresented: $showingLoginErrorAlert) {
            Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
    }
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
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
