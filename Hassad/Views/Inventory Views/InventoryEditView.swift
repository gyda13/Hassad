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
        ZStack{
            
            Color("Prime").edgesIgnoringSafeArea(.all)
            
            HStack{
                VStack(alignment: .leading, spacing: 20){
                    
                    HStack{
                        Text(NSLocalizedString("Material:", comment: "")).font(.title).foregroundColor(.white)
                        Text("\(inventoryname)")
                            .foregroundColor(Color.white)
                            .font(.title)
                            .bold()
                    }
                    Text("Material Quantity needed:")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        TextField("", value: $newquantity, formatter: formatter)                     .frame(width: UIScreen.screenWidth-40, height: 35)
                            .foregroundColor(Color(.black))
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                            .keyboardType(.decimalPad)
                        
                        
                    }
                    
                    
                    
                    
                }.padding(.bottom,60)
            }.padding()
        }
        
      .navigationBarTitle("Edit Material", displayMode: .inline)
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
          Button(action: updateInvetory) {
              if(newquantity != 0 ){
                  Text("Save")
                      .foregroundColor(.white)
              } else {
                  Text("Save")
              }
          }.disabled(newquantity == 0)
            
      )
    }.modifier(ResponsiveNavigationStyle())
    .presentationDetents([.medium])
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


struct InventoryEditView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryEditView(inventory: Inventory(inventoryname: "", inventoryprice: 0.0, quantity: 1, userID: UUID()))
    }
}


