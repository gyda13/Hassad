//
//  CreateInventoryView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//


import SwiftUI

struct CreateInventoryView: View {
    @State var inventoryname = ""
    @State var inventoryprice = ""
    @State var quantity = ""

    
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingInventorySaveErrorAlert = false

  var body: some View {
      
    NavigationView {
        VStack{
            
            TextField("Inventory Name:", text: $inventoryname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
          
            TextField("Inventory Price:", text: $inventoryprice)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
          
            
            TextField("Quntity:", text: $quantity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

    
  
           
        }
      .navigationBarTitle("Create Inventory", displayMode: .inline)
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
          Button(action: saveInventory) {
            Text("Save")
          } .disabled(inventoryname.isEmpty || inventoryprice.isEmpty)
      )
    }
    .alert(isPresented: $showingInventorySaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the acronym"))
    }
  }

  func saveInventory() {
    
      let saveInventoryData = CreatInventoryData(inventoryname: inventoryname, inventoryprice: Double(inventoryprice)!, quantity: Int(quantity)!)
    
      ResourceRequest<Inventory>(resourcePath: "inventories").save(saveInventoryData, auth: auth) { result in
          switch result {
          case .failure:
              DispatchQueue.main.async {
                  self.showingInventorySaveErrorAlert
              }
          case .success:
              DispatchQueue.main.async {
                  presentationMode.wrappedValue.dismiss()
              }
          }

      }
  }
    
    
    
}

struct CreateInventoryView_Previews: PreviewProvider {
  static var previews: some View {
      CreateInventoryView()
  }
}
