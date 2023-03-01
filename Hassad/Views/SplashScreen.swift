//
//  SplashScreen.swift
//  Hassad
//
//  Created by gyda almohaimeed on 10/08/1444 AH.
//

//import SwiftUI
//
//
//struct SplashScreen: View {
//    @State private var isActive = false
//    @StateObject
//    var auth = Auth()
//    var body: some View {
//        ZStack{
//            VStack{
//                if isActive {
//                   HassadView(auth: auth)
//                }else{
//                    Logoanimation()
//                }
//            }.onAppear(){
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8){
//                    self.isActive = true
//                    
//                }
//            }
//            }
//           
//    }
//}
//
//struct Logoanimation: View {
//    @State private var size = 0.5
//    @State private var opacity = 0.5
//    
//    
//    var body: some View {
//        
//        
//        ZStack{
//            
//            ZStack{
//                Color("darkBlue")
//                    .ignoresSafeArea()
//                
//                VStack(spacing: -70){
//             
//                        Image("logo")
//                            .resizable()
//                            .frame(width: 290.0, height: 200.0)
//                          
//
//                }
//                
//                .scaleEffect(size)
//                .opacity(opacity)
//                .onAppear{
//                    withAnimation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.5)){
//                        self.size = 1.3
//                        self.opacity = 1.0
//                    }
//                }
//                
//            }
//        }
//        
//    }
//}
