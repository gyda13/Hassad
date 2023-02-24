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
        ZStack{
            
            Color("Prime").edgesIgnoringSafeArea(.all)
            
            VStack(spacing:30){
          
                Text("Material name")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                 
                
                HStack {
                    TextField("", text: $inventoryname)
                        .foregroundColor(Color.black)
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
               // .offset(y:-238)
                .padding(.horizontal,40)
          
          
                Text("Material Price")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                  
                
                HStack {
                    TextField("", value: $inventoryprice, formatter: formatter)
                        .foregroundColor(Color.black)
                        .keyboardType(.asciiCapable)
                    
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
               // .offset(y:-238)
                .padding(.horizontal,40)
                
            
            
            
            
          
                Text("Material Quantity:")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                  
                
                HStack {
                    TextField("", value: $quantity, formatter: formatter)                        .foregroundColor(Color.black)
                        .keyboardType(.asciiCapable)
                    
                    
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
               // .offset(y:-238)
                .padding(.horizontal,40)
                
                
            
            
        }.padding(.bottom,60)
        }
       
        
      .navigationBarTitle("Edit Material", displayMode: .inline)
      .foregroundColor(.white)
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
                  .foregroundColor(.white)
          }
            .disabled(inventoryname.isEmpty || inventoryprice.isZero)
      )
    }.modifier(ResponsiveNavigationStyle())
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


struct UpdateInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateInventoryView(inventory: Inventory(inventoryname: "", inventoryprice: 0.0, quantity: 1, userID: UUID()))
    }
}

