//
//  UpdateOrdersView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//

import SwiftUI

struct UpdateOrdersView: View {
  var product: Product
    @State var productname: String
    @State var laborcost: Double
    @State var actualcost: Double
    @State var totalprice: Double
    @State var profit: Double
    @State var quantity: Int
    @State var newquantity = 0
    @State private var showingSheet = false
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingProductSaveErrorAlert = false

  init(product: Product) {
    self.product = product
      _productname = State(initialValue: product.productname)
      _laborcost = State(initialValue: product.laborcost)
      _actualcost = State(initialValue: product.actualcost)
      _totalprice = State(initialValue: product.totalprice)
      _profit = State(initialValue: product.profit)
      _quantity = State(initialValue: product.quantity)
  }

  var body: some View {
    NavigationView {
        
        ZStack{
            
            Color("Prime").edgesIgnoringSafeArea(.all)
            HStack{
                VStack(alignment: .leading, spacing: 20){
                    
                    
                Text("Materials used:")
                    .foregroundColor(.white)
                    .bold()
                    .font(.title2)
                ZStack{
                    RoundedRectangle(cornerRadius: 17)
                        .fill(.white)
                        .frame(width: 80, height: 80)
                    Button(
                        action: {
                            showingSheet.toggle()
                        }, label: {
                            Image(systemName:"archivebox")
                                .font(.system(size: 60))
                        })
                }.padding()
                
                Text("Product Quantity:")
                    .foregroundColor(.white)
                    .bold()
                    .font(.title2)
                TextField("Product Quantity:", value: $newquantity, formatter: formatter)
                        .frame(width: UIScreen.screenWidth-40, height: 35)
                            .foregroundColor(Color(.black))
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                    .keyboardType(.asciiCapableNumberPad)
                   
                
            
                Spacer()
                }
                
                .sheet(isPresented: $showingSheet) {
                    InventoryForProductsView(auth: auth)
                }.padding()
            }.padding()
        }
      .navigationBarTitle("Set Order", displayMode: .inline)
      .navigationBarItems(
        leading:
          Button(
            action: {
              presentationMode.wrappedValue.dismiss()
            }, label: {
              Text("Cancel")
                .fontWeight(Font.Weight.regular)
                .foregroundColor(.white)
            }),
        trailing:
          Button(action: updateProduct) {
              if(newquantity != 0 ) {
                  Text("Save")
                      .foregroundColor(.white)
              } else {
                  Text("Save")
              }
          }
            .disabled( newquantity == 0)
      )
    }
    .alert(isPresented: $showingProductSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the product"))
    }
  }
    
  func updateProduct() {
      if(self.quantity != 0) {
          let data = CreateProductData(productname: self.productname, laborcost: self.laborcost, actualcost: self.actualcost, totalprice: self.totalprice, profit: (self.profit / Double(self.quantity) * Double(self.newquantity + self.quantity)), quantity: self.quantity + self.newquantity)
          guard let id = self.product.id else {
            fatalError("Product had no ID")
          }
          ProductRequest(productID: id).update(with: data, auth: auth) { result in
            switch result {
            case .failure:
              DispatchQueue.main.async {
                self.showingProductSaveErrorAlert = true
              }
            case .success(_):
              DispatchQueue.main.async {
                  self.product.productname = self.productname
                  self.product.laborcost = self.laborcost
                  self.product.actualcost = self.actualcost
                  self.product.totalprice = self.totalprice
                  self.product.profit = self.profit
                  self.product.quantity = self.quantity
                presentationMode.wrappedValue.dismiss()
              }
            }
          }
      } else {
          
          let data = CreateProductData(productname: self.productname, laborcost: self.laborcost, actualcost: self.actualcost, totalprice: self.totalprice, profit: self.profit * Double(self.newquantity + self.quantity), quantity: self.quantity + self.newquantity)
          guard let id = self.product.id else {
            fatalError("Product had no ID")
          }
          ProductRequest(productID: id).update(with: data, auth: auth) { result in
            switch result {
            case .failure:
              DispatchQueue.main.async {
                self.showingProductSaveErrorAlert = true
              }
            case .success(_):
              DispatchQueue.main.async {
                  self.product.productname = self.productname
                  self.product.laborcost = self.laborcost
                  self.product.actualcost = self.actualcost
                  self.product.totalprice = self.totalprice
                  self.product.profit = self.profit
                  self.product.quantity = self.quantity
                presentationMode.wrappedValue.dismiss()
              }
            }
          }
      }
     
   
  
  }
}
