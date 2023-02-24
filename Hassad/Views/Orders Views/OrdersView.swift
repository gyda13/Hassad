//
//  OrdersView().swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//


import SwiftUI

struct OrdersView: View {
  
    @State private var showingProductErrorAlert = false
    @EnvironmentObject var auth: Auth
    @State private var products: [Product] = []
    @State var modal: ModalType? = nil
   @AppStorage("key") var uinew = ""
    
    init(auth: Auth) {
        if _uinew.wrappedValue == ""{
            _uinew.wrappedValue = "\(auth.ui!)"

        }
    }
    var body: some View {
      NavigationView {
        List {
            ForEach(products, id: \.id){
                product in
           
                         
                Button {
                    modal = .update(product)
                } label: {
                    VStack(alignment: .leading){
                        Text("Product Name: " + product.productname).font(.title2).bold().foregroundColor(.white)
                        Text("Product Total Price: \(String(format: "%.2f", product.totalprice))").font(.title3).foregroundColor(.white)
                        
                    }.frame(width: 345, height: 100)
                }
            }
            .onDelete(perform: {IndexSet in
                for index in IndexSet {
                    if let id = products[index].id {
                        let productDetailRequester = ProductRequest(productID: id)
                        productDetailRequester.delete(auth: auth)
                    }
                }
                products.remove(atOffsets: IndexSet)
            })
            .listRowBackground(Color.clear)
            .background(RoundedRectangle(cornerRadius: 17).fill(Color.accentColor))
            .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        }.listStyle(.insetGrouped)
       
        .navigationTitle("Set Order")
      }
      .modifier(ResponsiveNavigationStyle())
        
     
      .sheet(item: $modal, onDismiss: {
           loadData()
      }) { modal in
          switch modal {
          case .add:
              CreateProductView()
          case .update(let product):
             UpdateOrdersView(product: product)
          }
      }
        
     
      .onAppear(perform: loadData)
      .alert(isPresented: $showingProductErrorAlert) {
        Alert(title: Text("Error"), message: Text("There was an error getting the products"))
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

