//
//  UpdateProductView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//
import SwiftUI

struct UpdateProductView: View {
  var product: Product
    @State var productname: String
    @State var laborcost: Double
    @State var actualcost: Double
    @State var totalprice: Double
    @State var profit: Double
    @State var quantity: Int
    @State var profitD = 0.0
    
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
        VStack{
            TextField("Product Name:", text: $productname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
          
            TextField("Labor Cost:", value: $laborcost, formatter: formatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
          
            
            TextField("Actual Cost:", value: $actualcost, formatter: formatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            TextField("Quintity:", value: $quantity, formatter: formatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
       
            Stepper("Profit Percentage % :  \(profitD, specifier: "%.2f")", value: $profitD, in: 0...100, step: 5)
                .padding()
          
  
           
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
            Text("Save")
          }
            .disabled(productname.isEmpty || laborcost.isZero || actualcost.isZero
                      || totalprice.isZero || profitD == 0)
      )
    }.presentationDetents([.medium])
    .alert(isPresented: $showingProductSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the product"))
    }
  }
    

  func updateProduct() {
      let data = CreateProductData(productname: self.productname, laborcost: self.laborcost, actualcost: self.actualcost, totalprice: ((self.actualcost + self.laborcost) + (self.actualcost + self.laborcost) * (self.profitD) / 100.0), profit: ((self.actualcost + self.laborcost) * (self.profitD) / 100.0), quantity: self.quantity)
     
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

//struct EditAcronymView_Previews: PreviewProvider {
//  static var previews: some View {
//    EditAcronymView(acronym: dummyAcronyms[0])
//  }
//}