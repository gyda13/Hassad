//
//  profile.swift
//  Hassad
//
//  Created by Raghad on 20/07/1444 AH.
//

import SwiftUI

struct profile: View {
    @State var businessname = "Elegant Abaya"
    @State var email = "lulukalmisfer@hotmail.com"
    @EnvironmentObject var auth: Auth
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
                        Text(businessname)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .offset(x: 0, y: 10)

                        Text("_____________________________")
                            .fontWeight(.thin)
                            .foregroundColor(Color.white)
                            .offset(x: 0, y: -15)
                        Text(email)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .offset(x: 0, y: 0)

                        Text("__________________________________")
                            .fontWeight(.thin)                        .foregroundColor(Color.white)
                            .offset(x: 0, y: -25)
                            
                        
                     
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
    }
}

struct profile_Previews: PreviewProvider {
    static var previews: some View {
        profile()
    }
}
