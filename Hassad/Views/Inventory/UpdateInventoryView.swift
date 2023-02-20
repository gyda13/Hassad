//
//  UpdateInventoryView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//

import SwiftUI

struct UpdateInventoryView: View {
  var inventory: Inventory
    @State var inventoryname: String
    @State var inventoryprice: Double
    @State var quantity: Int

    
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
      
    
    
  }

  var body: some View {
    NavigationView {
        VStack{
            TextField("Inventory Name:", text: $inventoryname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
          
            TextField("Inventory Price:", value: $inventoryprice, formatter: formatter)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
         
            TextField("Quintity:", value: $quantity, formatter: formatter)
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
            .disabled(inventoryname.isEmpty || inventoryprice.isZero)
      )
    }.presentationDetents([.medium])
    .alert(isPresented: $showingInventorySaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the inventory"))
    }
  }
    

  func updateInvetory() {
      let data = CreatInventoryData(inventoryname: self.inventoryname, inventoryprice: self.inventoryprice, quantity: self.quantity)
      
     
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
