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
                        .foregroundColor(.gray.opacity(0.5))
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
                        
                            Text(user?.businessname ?? "no")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                   // .offset(x: 0, y: 10)
                                
                                Text("_____________________________")
                                    .fontWeight(.thin)
                                    .foregroundColor(Color.white)
                          
                                   // .offset(x: 0, y: -15)
                          Text(user?.email ?? "no")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                   // .offset(x: 0, y: 0)
                                
                                Text("__________________________________")
                                    .fontWeight(.thin)                        .foregroundColor(Color.white)
                                  //  .offset(x: 0, y: -25)
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
//struct HP: View {
//    var body: some View {
//        NavigationView{
//            ZStack{
//                Color("Back").ignoresSafeArea()
//                VStack{
//                    VStack{
//                    }    //     .padding(.leading , 20)
//                    VStack{
//                        ScrollView{
//                            ZStack{
//                                Rectangle()
//                                    .frame(width: 340, height: 150)
//                                    .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
//                                    .foregroundColor(Color(red: 0.466, green: 0.552, blue: 0.661))
//                                //                        .padding(.top , -230)
//                                VStack {
//                                    Text(Date().formatted(date: .complete, time: .omitted))
//                                        .foregroundColor(.white)
//                                        
//                                    HStack(alignment: .bottom, spacing: 35){
//                                       
//                                        VStack{
//                                      
//                                            Text("\(TotalProfit())").font(.largeTitle).bold()
//                                                .padding(.bottom,4)
//                                            Text("Profits").bold()
//                                        }.foregroundColor(.white)
//                                        
//                                        Rectangle()
//                                            .frame(width: 1, height: 80)
//                                            .foregroundColor(.white)
//                                      
//                                        VStack{
//                                            Text("\(TotalOrders())").font(.largeTitle).bold()
//                                                .padding(.bottom,4)
//                                            Text("Orders").bold()
//                                        }.foregroundColor(.white)
//                                  
//                                    }
//                                }
//                            }
////-----------------------------------------------------------------------------------
//                            ZStack{
//                               
//                                Rectangle()
//                                    .frame(width: 340, height: 110)
//                                    .mask(RoundedRectangle(cornerRadius: 17, style: .continuous))
//                                    .foregroundColor(.white)
//                                    .padding(.top , 20)
//                                     Text(" Business Info")
//                                    .bold()
//                            }
////-----------------------------------------------------------------------------------
//                            ZStack{
//                                Rectangle()
//                                
//                                    .frame(width: 340, height: 150)
//                                    .mask(RoundedRectangle(cornerRadius: 17, style: .continuous))
//                                    .foregroundColor(.white)
//                                    .padding(.top ,50 )
//                                     Text(" Support")
//                                    .bold()
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Business Name")
//            .navigationBarTitleDisplayMode(.automatic)
//                                .toolbar{
//                                    Button {
//                                
//                                    } label: {
//                                        Label("pro", systemImage: "person.circle")
//                                            .bold()
//            
//                                    }
//                                    .accentColor(Color(red: 0.466, green: 0.552, blue: 0.661))
//                                }
//            
//        } // nav
//     }
//}
//    struct HP_Previews: PreviewProvider {
//        static var previews: some View {
//            HP()
//        }
//    }
