//
//  CreateProductView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//


import SwiftUI

struct CreateProductView: View {
    @State var productname = ""
    @State var laborcost = ""
    @State var actualcost = ""
    @State var totalprice = ""
    @State var profit = ""
    @State var profitD = 0.0
    @State var quantity = 0

    
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingProductSaveErrorAlert = false
    
    
  
  var body: some View {
      
    NavigationView {
        VStack{
            
            TextField("Product Name:", text: $productname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
          
            TextField("Labor Cost:", text: $laborcost)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
          
            
            TextField("Actual Cost:", text: $actualcost)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            
        
       
            Stepper("Profit Percentage % :  \(profitD, specifier: "%.2f")", value: $profitD, in: 0...100, step: 5)
                .padding()
         
            

        }
      .navigationBarTitle("Create Product", displayMode: .inline)
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
          Button(action: saveProduct) {
            Text("Save")
          } .disabled(productname.isEmpty || laborcost.isEmpty || actualcost.isEmpty || profitD == 0)
      )
    }
    
    
    
            
    .alert(isPresented: $showingProductSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the product"))
    }
  }
       
   

  func saveProduct() {
    
      let productSaveData = CreateProductData(productname: productname, laborcost: Double(laborcost)!, actualcost: Double(actualcost)!, totalprice: (Double(actualcost)! + Double(laborcost)! + (Double(actualcost)! + Double(laborcost)!) * (profitD) / 100.0), profit: (Double(actualcost)! + Double(laborcost)!) * (profitD) / 100.0, quantity: 0)
      ResourceRequest<Product>(resourcePath: "products").save(productSaveData, auth: auth) { result in
          switch result {
          case .failure:
              DispatchQueue.main.async {
                  self.showingProductSaveErrorAlert
              }
          case .success:
              DispatchQueue.main.async {
                  presentationMode.wrappedValue.dismiss()
              }
          }

      }
  }
    
    
    
}

struct CreateProductView_Previews: PreviewProvider {
  static var previews: some View {
      CreateProductView()
  }
}

    
    
   
