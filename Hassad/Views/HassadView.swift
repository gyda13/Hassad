//
//  HassadView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import SwiftUI

struct HassadView: View {
    
    @EnvironmentObject var auth: Auth
    var body: some View {
        
       
        VStack {
            if let a = auth.ui{
                Text("\(a)")
            }
            Button(
              action: {
                auth.logout()
              }, label: {
                Text("Log Out")
          })
        }
    }
}

struct HassadView_Previews: PreviewProvider {
    static var previews: some View {
        HassadView()
    }
}
