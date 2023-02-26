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
  @State var showsignUp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
            
                    RoundedRectangle(cornerRadius: 33, style: .circular)
                        .fill(Color("defultColor"))
                
                    .frame(width: UIScreen.screenWidth, height: 676).padding(.top,140)
            
                VStack {
                    Text("Welcome Back")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                  
                    TextField("\(Image(systemName: "person.fill")) Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .frame(width: 323)
                        .padding()
                        .background(Color("textfields"))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Color("borders"), lineWidth: 1))
                      //  .offset(x:0, y: -5)
                    
                    SecureField("\(Image(systemName: "lock.fill")) Password", text: $password)
                        .frame(width: 323)
                        .padding()
                        .background(Color("textfields"))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                        .stroke(Color("borders"), lineWidth: 1))
                        
                    
                    
                    Button("Log In") {
                        login()
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                    .frame(width: 335.0, height: 30.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("darkBlue"))
                    .cornerRadius(17.5)
                    
                   // .offset(x: 0,y: 25)
                    HStack{
                        
                        Text("Don't Have an Account?")
                            .foregroundColor(Color(.gray))
                        NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                            Text("Sign up")
                            
                                .fontWeight(.bold)
                                .foregroundColor(Color("text"))
                            
                            
                        }.navigationBarBackButtonHidden(true)
                    }
                }
               
                .alert(isPresented: $showingLoginErrorAlert) {
                    Alert(title: Text("Error"), message: Text("Could not log in. Check your credentials and try again"))
                }
                .navigationTitle("Log In")
            .navigationBarBackButtonHidden(true)
            }.background(Color("AccentColor"))
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
