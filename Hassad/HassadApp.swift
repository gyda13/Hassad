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
    
    
    var body: some Scene {
        WindowGroup {
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
         }
       }
    }

