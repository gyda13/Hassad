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
    @State private var users: [User] = []
    @State private var showingProductErrorAlert = false
    @AppStorage("key") var uinew = ""
    @State var selection: String = "ProductProfits"
     
     init(auth: Auth) {
         if _uinew.wrappedValue == ""{
             _uinew.wrappedValue = "\(auth.ui!)"

         }
     }
    
    func TotalProfit() -> Double {
        var total = 0.0
        for p in products{
            total = p.profit + total
            }
        return total
    }
    
    func TotalOrders() -> Int {
        var total = 0
        for p in products{
            total = p.quantity + total
            }
        return total
    }
  
    var body: some View {


        NavigationView {
            
            ScrollView{
                VStack {
                    ForEach(users, id: \.id){
                        user in
                        Text("\(user.businessname)")
                            .foregroundColor(.black)
                    }
                    HStack {
                        Text("\(String(format: "%.2f", TotalProfit()))")
                            .foregroundColor(.white)
                        Text("|")
                            .foregroundColor(.white)
                        Text("\(TotalOrders())")
                            .foregroundColor(.white)
                          
                        }
                    .frame(width: 345, height: 164)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))

                    
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
                    
                }
            }
            .toolbar{
                NavigationLink(destination: profile(auth: auth)) {
                    
                    Label("pro", systemImage: "person.circle")
                         .bold().foregroundColor(.accentColor)
                         .font(.system(size: 30))
        
                }
                               
                
            }
        }
            .onAppear{
                loadData()
                getUserInfo()
            }
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
    
    
 
    func getUserInfo() {

        if let a = auth.ui{

            UserRequest<User>(userID: a).getUserInfo{
                userRequest in
                switch userRequest {
                case .failure:
                    DispatchQueue.main.async {

                    }
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users = users
                    }

                }
            }
        } else {

            UserRequest<User>(userID:UUID(uuidString: self.uinew)!).getUserInfo{
                userRequest in
                switch userRequest {
                case .failure:
                    DispatchQueue.main.async {

                    }
                case .success(let users):
                    DispatchQueue.main.async {
                        self.users = users
                    }

                }
            }
        }
    }
    
}

//
//struct HassadView_Previews: PreviewProvider {
//    static var previews: some View {
//        HassadView()
//    }
//}
