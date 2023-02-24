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
    @State var profitD = 0.0
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
            VStack{
                
                Text("Materials used:")
                    .foregroundColor(.white)
                    .bold()
                    .font(.title2)
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white)
                        .frame(width: 100, height: 100)
                    Button(
                        action: {
                            showingSheet.toggle()
                        }, label: {
                            Image(systemName:"archivebox")
                                .font(.system(size: 60))
                                
                            
                        })
                }
                
                Text("Product Quantity:")
                    .foregroundColor(.white)
                    .bold()
                    .font(.title2)
                TextField("Product Quantity:", value: $newquantity, formatter: formatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding()
                
            
                
            }   .sheet(isPresented: $showingSheet) {
                InventoryForProductsView(auth: auth)
            }
        }
      .navigationBarTitle("Edit Product", displayMode: .inline)
      .navigationBarItems(
        leading:
          Button(
            action: {
              presentationMode.wrappedValue.dismiss()
            }, label: {
              Text("Cancel")
                .fontWeight(Font.Weight.regular)
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
      let data = CreateProductData(productname: self.productname, laborcost: self.laborcost, actualcost: self.actualcost, totalprice: ((self.actualcost + self.laborcost) + (self.actualcost + self.laborcost) * (self.profitD) / 100.0), profit: profit * Double(quantity + newquantity), quantity: quantity + newquantity)
     
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
