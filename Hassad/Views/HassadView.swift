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
    @State private var user: User? = nil
    @State private var showingProductErrorAlert = false
    @AppStorage("key") var uinew = ""
    @State var selection: String = "ProductProfits"
     init(auth: Auth) {
         if _uinew.wrappedValue == ""{
             _uinew.wrappedValue = "\(auth.ui!)"

         }
     }
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    func TotalProfit() -> Double {
        var total = 0.0
        for p in products{
            if p.quantity != 0 {
                total = p.profit + total
            }
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
                VStack(spacing: 30){
                    VStack (spacing: 10){
                       
                        HStack {
                            Text(user?.businessname ?? "no")
                                .font(.title)
                                .bold()
                            Spacer()
                            
                        }.padding()
                        
                        ZStack {
                            Rectangle()
                                .frame(width: UIScreen.screenWidth - 40 , height: 150)
                                .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .foregroundColor(Color.accentColor)
                            VStack {
                                Text(Date().formatted(date: .complete, time: .omitted))
                                    .foregroundColor(.white)
                                
                                HStack(alignment: .bottom, spacing: 35){
                                    
                                    VStack{
                                        
                                        Text("\(TotalProfit().formatted())").font(.largeTitle).bold()
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
                        
                    
                    }
                    VStack(spacing: 15){
                        Picker("" , selection: $selection){
                            
                            Text("Products Profits").tag("ProductProfits")
                            Text("Products Quantity").tag("ProductQuantity")
                            
                        }.pickerStyle(.segmented).padding(.horizontal,20)
                        
                        if selection == "ProductProfits"{
                            
                            GroupBox ( "Products Profits Chart") {
                                Chart {
                                    ForEach(products, id: \.id){
                                        product in
                                        if product.quantity != 0 {
                                            BarMark(
                                                x: .value("Product Name", product.productname),
                                                y: .value("Product Profits", product.profit)
                                            ).foregroundStyle(Color.pink.gradient)
                                                .annotation(position: .top) {
                                                                    Text("\(String(format: "%.0f", product.profit)) SR")
                                                                        .foregroundColor(Color.gray)
                                                                        .font(.system(size: 12, weight: .bold))
                                                }
                                        }
                                     
                                    }
                                }.frame(height: 240)
                            }.padding(.horizontal,20)
                            
                        } else {
                            GroupBox ( "Products Quantity Chart") {
                                Chart {
                                    ForEach(products, id: \.id){
                                        product in
                                        if product.quantity != 0 {
                                            BarMark(
                                                x: .value("Product Name", product.productname),
                                                y: .value("Product Quantity", product.quantity)
                                            ) .foregroundStyle(Color.blue.gradient)
                                        }
                                    }
                                }.frame(height: 240)
                            }.padding(.horizontal,20)
                            
                        }
                        ZStack {
                            Rectangle()
                                .frame(width: UIScreen.screenWidth - 40, height: 50)
                                .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .foregroundColor(Color.accentColor)
                            ShareLink("PDF Business Summery", item: render())
                                .foregroundColor(Color.white)
                        }
                    }
                }.padding(.top,25)
            }
            .toolbar{
                NavigationLink(destination: profile(auth: auth)) {
                    
                    Label("pro", systemImage: "person.circle")
                        .bold().foregroundColor(.accentColor)
                         .font(.system(size: 25))
        
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
    
    func render() -> URL {
        let renderer = ImageRenderer(content:
        ZStack{
            Color("Prime").edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text(user?.businessname ?? "no name")
                        .font(.title2)
                        .foregroundColor(.white)
                    Text("Summery").font(.title2)
                        .foregroundColor(.white)
                }
                Text("Total profits | \(String(format: "%.0f", TotalProfit())) SR")
                Text("Total Orders  | \(TotalOrders())")
               
                GroupBox ( "Products Profits Chart") {
                    Chart {
                        ForEach(products, id: \.id){
                            product in
                            if product.quantity != 0 {
                                BarMark(
                                    x: .value("Product Name", product.productname),
                                    y: .value("Product Profits", product.profit)
                                ).foregroundStyle(Color.pink.gradient)
                                    .annotation(position: .top) {
                                  Text("\(String(format: "%.0f", product.profit)) SR")
                                    .foregroundColor(Color.gray)
                                  .font(.system(size: 12, weight: .bold))
                        }
                            }
                         
                        }
                    }.frame(height: 100)
                }.padding(.horizontal,20)
                GroupBox ( "Products Quantity Chart") {
                    Chart {
                        ForEach(products, id: \.id){
                            product in
                            if product.quantity != 0 {
                                BarMark(
                                    x: .value("Product Name", product.productname),
                                    y: .value("Product Quantity", product.quantity)
                                ) .foregroundStyle(Color.blue.gradient)
                            }
                        }
                    }.frame(height: 100)
                }.padding(.horizontal,20)
                
                VStack{
                    ForEach(products, id: \.id){
                        product in
                        Text("Product name: \(product.productname)")
                        Text("Product quantity: \(product.quantity)")
                        Text("Product profits: \(String(format: "%.0f", product.profit)) SR")
                        Text("-------------------------------------")
                    }
                }
                
            }
        }
        )

        let url = URL.documentsDirectory.appending(path: "output.pdf")

        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }

            pdf.beginPDFPage(nil)

            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
    
}

//
//struct HassadView_Previews: PreviewProvider {
//    static var previews: some View {
//        HassadView()
//    }
//}
