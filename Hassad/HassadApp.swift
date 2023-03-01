//
//  HassadApp.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import SwiftUI

@main
struct HassadApp: App {
    @StateObject
    var auth = Auth()
    @State private var isActive = false
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                VStack{
                    if isActive {
                        if auth.isLoggedIn {
                           TabView {
                             HassadView(auth: auth)
                               .tabItem {
                                 Label("Hassad", systemImage: "chart.bar.xaxis")
                               }
                             InventoryView(auth: auth)
                               .tabItem {
                                 Label("Inventory", systemImage: "archivebox")
                               }
                               ProductView(auth: auth)
                               .tabItem {
                                 Label("Products", systemImage: "shippingbox")
                               }
                               OrdersView(auth: auth)
                               .tabItem {
                                 Label("Orders", systemImage: "doc.plaintext")
                               }
                           }
                           .environmentObject(auth)
                         } else {
                           LoginView().environmentObject(auth)
                         }
                    }else{
                        Logoanimation()
                    }
                }.onAppear(){
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
                        self.isActive = true
                        
                    }
                }
                }
        
         }
       }
    }


struct Logoanimation: View {
    @State private var size = 0.5
    @State private var opacity = 0.5
    
    
    var body: some View {
        
        
        ZStack{
            
            ZStack{
                Color("darkBlue")
                    .ignoresSafeArea()
                
                VStack(spacing: -70){
             
                        Image("logo")
                            .resizable()
                            .frame(width: 290.0, height: 275.0)
                          

                }
                
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.5)){
                        self.size = 1.3
                        self.opacity = 1.0
                    }
                }
                
            }
        }
        
    }
}


