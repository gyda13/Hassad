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
  //  @State private var users: User? = nil
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
//                    ForEach(users, id: \.id){
//                        user in
//                        Text("\(user.businessname)")
//                            .foregroundColor(.black)
//                    }
//                    Text(users?.businessname ?? "none").foregroundColor(.red)
//                    Text(users?.email ?? "none").foregroundColor(.red)
                   ZStack {
                        Rectangle()
                            .frame(width: 340, height: 150)
                            .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .foregroundColor(Color(red: 0.466, green: 0.552, blue: 0.661))
                        //                        .padding(.top , -230)
                        VStack {
                            Text(Date().formatted(date: .complete, time: .omitted))
                                .foregroundColor(.white)
                                
                            HStack(alignment: .bottom, spacing: 35){
                               
                                VStack{
                              
                                    Text("\(TotalProfit())").font(.largeTitle).bold()
                                        .padding(.bottom,4)
                                    Text("Profits").bold()
                                }.foregroundColor(.white)
                                
                                Rectangle()
                                    .frame(width: 1, height: 80)
                                    .foregroundColor(.white)
                              
                                VStack{
                                    Text("\(TotalOrders())").font(.largeTitle).bold()
                                        .padding(.bottom,4)
                                    Text("Orders").bold()
                                }.foregroundColor(.white)
                          
                            }
                        }
                    }
                    
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
               // getUserInfo()
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
    
    
 
    
}

//
//struct HassadView_Previews: PreviewProvider {
//    static var previews: some View {
//        HassadView()
//    }
//}
