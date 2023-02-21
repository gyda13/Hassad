//
//  HassadView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import SwiftUI
import Charts
struct HassadView: View {

    @EnvironmentObject var auth: Auth
    @State private var products: [Product] = []
    @State private var showingProductErrorAlert = false
    @AppStorage("key") var uinew = ""
    @State var selection: String = "ProductProfits"
     
     init(auth: Auth) {
         if _uinew.wrappedValue == ""{
             _uinew.wrappedValue = "\(auth.ui!)"

         }
     }
    var body: some View {


        VStack {
            Button(
              action: {
                auth.logout()
              }, label: {
                Text("Log Out")
          })
            
            
            Picker("" , selection: $selection){
                              
                              Text("Product Profits").tag("ProductProfits")
                              Text("Product Quintity").tag("ProductQuintit")
                              
                              
                          }.pickerStyle(.segmented).padding()
                          
            if selection == "ProductProfits"{
                
                GroupBox ( "Product Profit Chart") {
                    Chart {
                        ForEach(products, id: \.id){
                            product in
                            if product.quantity != 0 {
                                BarMark(
                                    x: .value("Product Name", product.productname),
                                    y: .value("Product Profits", product.profit)
                                ).foregroundStyle(Color.blue.gradient)
                            }
                        }
                    }.frame(height: 240)
                }
            } else {
                GroupBox ( "Product Quintity Chart") {
                    Chart {
                        ForEach(products, id: \.id){
                            product in
                            if product.quantity != 0 {
                                BarMark(
                                    x: .value("Product Name", product.productname),
                                    y: .value("Product Quintity", product.quantity)
                                ).foregroundStyle(Color.pink.gradient)
                            }
                        }
                    }.frame(height: 240)
                }
            }
         
        } .onAppear(perform: loadData)
    }
 
    func loadData() {
        
        if let a = auth.ui{
            
            UserProductsRequest<Product>(userID: a).getUserProduct{
                productsRequest in
                switch productsRequest {
                case .failure:
                    DispatchQueue.main.async {
                        self.showingProductErrorAlert = true
                    }
                case .success(let products):
                    DispatchQueue.main.async {
                        self.products = products
                    }
                    
                }
            }
        } else {
            
            UserProductsRequest<Product>(userID:UUID(uuidString: self.uinew)!).getUserProduct{
                productsRequest in
                switch productsRequest {
                case .failure:
                    DispatchQueue.main.async {
                        self.showingProductErrorAlert = true
                    }
                case .success(let products):
                    DispatchQueue.main.async {
                        self.products = products
                    }
                    
                }
            }
        }
    }
}


//struct HassadView_Previews: PreviewProvider {
//    static var previews: some View {
//        HassadView()
//    }
//}



//            if let a = auth.ui{
//                Text("\(a)")
//            }

