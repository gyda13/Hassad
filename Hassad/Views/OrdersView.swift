//
//  OrdersView().swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import SwiftUI

struct OrdersView: View {

    @EnvironmentObject var auth: Auth
    @State private var user: User?
    @State private var showingUserErrorAlert = false
    var body: some View {
   
        VStack{
//            if let user = user {
//                Section(header: Text("User").textCase(.uppercase)) {
//                    Text(user.businessname)
//                }
//            }
        }
          //  .onAppear(perform: getAcronymData)
            .alert(isPresented: $showingUserErrorAlert) {
              Alert(title: Text("Error"), message: Text("There was an error getting the user"))
            }
     
      }
      
      
    
//    func getAcronymData() {
//
//        guard let id = auth.token else {
//            return
//        }
//        let tokenRequester = TokenRequest(tokenID: id)
//        tokenRequester.getUser { result in
//            switch result {
//            case .success(let user):
//                DispatchQueue.main.async {
//                    self.user = user
//                }
//            case .failure:
//                DispatchQueue.main.async {
//                    self.showingUserErrorAlert = true
//                }
//            }
//        }
//
//      }
    }

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
