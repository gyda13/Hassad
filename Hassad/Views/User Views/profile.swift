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
                VStack {
                    Rectangle()
                        .frame(width: UIScreen.screenWidth, height:  UIScreen.screenHeight/2)
                        .foregroundColor(.accentColor)
                    .ignoresSafeArea()
                    Spacer()
                }
                ZStack {
                    VStack(spacing: 20){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 109.0, height: 110.0)
                            .foregroundColor(Color(UIColor(named: "personColor")!))
                            .padding(4)
                            .overlay(
                            Circle()
                                .stroke(Color("personColor"), lineWidth: 1)
                            )
                            .padding(.top,30)
            
                      VStack{
                        
                            Text(user?.businessname ?? "no")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .offset(x: 0, y: 10)
                                
                                Text("_____________________________")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.white)
                                    .offset(x: 0, y: -15)
                          Text(user?.email ?? "no")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .offset(x: 0, y: 0)
                                
                                Text("__________________________________")
                                    .fontWeight(.thin)                        .foregroundColor(Color.white)
                                    .offset(x: 0, y: -25)
                            }
                        
                        
                     
                           // .offset(x: 0,y: -30)
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
                            .background(Color(UIColor(named: "darkBlue")!))
                            .cornerRadius(17.5)
                        Spacer()
                    }.ignoresSafeArea()
                }
               // .offset(x: 0, y: -100)

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

//struct profile_Previews: PreviewProvider {
//    static var previews: some View {
//        profile(auth: Auth())
//    }
//}
