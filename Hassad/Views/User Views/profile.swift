//
//  profile.swift
//  Hassad
//
//  Created by Raghad on 20/07/1444 AH.
//

import SwiftUI

struct profile: View {
    
    @EnvironmentObject var auth: Auth
    @State private var showingErrorAlert = false
    @State private var user: User? = nil
    @AppStorage("key") var uinew = ""
    
     
     init(auth: Auth) {
//         if _uinew.wrappedValue == ""{
//             _uinew.wrappedValue = "\(auth.ui!)"
//
//         }
     }
    var body: some View {
        NavigationView{
            ZStack{
                
            Color("defultColor").edgesIgnoringSafeArea(.all)
                VStack {
                    Rectangle()
                        .frame(width: UIScreen.screenWidth, height:  UIScreen.screenHeight/2)
                        .foregroundColor(Color("darkBlue"))
                    .ignoresSafeArea()
                    Spacer()
                }
                ZStack {
                    VStack(spacing: 20){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 109.0, height: 110.0)
                            .foregroundColor(Color.accentColor)
                            .padding(4)
                            .overlay(
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 1)
                            )
                            .padding(.top,30)
            
                      VStack{
                        
                            Text(user?.businessname ?? "")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                   
                                
                                Text("_____________________________")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.white)
                          
                          Text(user?.email ?? "")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                           
                                
                                Text("__________________________________")
                                    .fontWeight(.thin)                        .foregroundColor(Color.white)
                            }
                        
                        
                            Spacer()
                    }
                    VStack{
                        Spacer()
                        Button("Sign Out") {
                            auth.logout()
                            
                        }
                        .frame(width: 150.0, height: 30.0)
                        .font(.title2)
                        .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(UIColor(named: "lightBlue")!))
                            .cornerRadius(17.5)
                        Spacer()
                    }.ignoresSafeArea()
                }

            }
            
        }
       
        .onAppear(perform: getUserInfo)
    }
    
    
   func getUserInfo() {
        
        if let a = auth.ui{

            UserRequest<User>(userID: a).getOneUserInfo{
                userRequest in
                switch userRequest {
                case .failure:
                    DispatchQueue.main.async {

                    }
                case .success(let u):
                    DispatchQueue.main.async {
                        self.user = u
                    }

                }
            }
        } else {

            UserRequest<User>(userID:UUID(uuidString: self.uinew)!).getOneUserInfo{
                userRequest in
                switch userRequest {
                case .failure:
                    DispatchQueue.main.async {

                    }
                case .success(let u):
                    DispatchQueue.main.async {
                        self.user = u
                    }

                }
            }
        }
    }

}
