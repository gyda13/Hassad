//
//  InventoryEditView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//

import SwiftUI

struct InventoryEditView: View {
  var inventory: Inventory
    @State var inventoryname: String
    @State var inventoryprice: Double
    @State var quantity: Int
    
    @State var newquantity = 0
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingInventorySaveErrorAlert = false

  init(inventory: Inventory) {
    self.inventory = inventory
      _inventoryname = State(initialValue: inventory.inventoryname)
      _inventoryprice = State(initialValue: inventory.inventoryprice)
      _quantity = State(initialValue: inventory.quantity)
      _newquantity = State(initialValue: newquantity)
      
    
    
  }

  var body: some View {
    NavigationView {
        VStack{
            
           Text("Inventory Name:\(inventoryname)")
          
         
            TextField("Quintity:", value: $newquantity, formatter: formatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
     
  
           
        }
        
      .navigationBarTitle("Edit Inventory", displayMode: .inline)
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
          Button(action: updateInvetory) {
            Text("Save")
          }
            
      )
    }.presentationDetents([.medium])
    .alert(isPresented: $showingInventorySaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the inventory"))
    }
  }
    

  func updateInvetory() {
      let data = CreatInventoryData(inventoryname: self.inventoryname, inventoryprice: self.inventoryprice, quantity: self.quantity - newquantity)
      
     
    guard let id = self.inventory.id else {
      fatalError("Inventory had no ID")
    }
    InventoryRequest(inventoryID: id).update(with: data, auth: auth) { result in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self.showingInventorySaveErrorAlert = true
        }
      case .success(_):
        DispatchQueue.main.async {
            self.inventory.inventoryname = self.inventoryname
            self.inventory.inventoryprice = self.inventoryprice
            self.inventory.quantity = self.quantity
        
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}
