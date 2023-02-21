//
//  InventoryForProductsView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//

import SwiftUI

struct InventoryForProductsView: View {
  
   
    @State private var showingInventoryErrorAlert = false
    @EnvironmentObject var auth: Auth
    @State private var inventory: [Inventory] = []
    @State var modal: InventoryModalType? = nil
    @AppStorage("key") var uinew = ""
    @Environment(\.presentationMode) var presentationMode
     init(auth: Auth) {
         if _uinew.wrappedValue == ""{
             _uinew.wrappedValue = "\(auth.ui!)"

         }
     }
    
    var body: some View {
      NavigationView {
        List {
            
            ForEach(inventory, id: \.id){
                inventory in
           
                         
                Button {
                    modal = .update(inventory)
                } label: {
                    VStack(alignment: .leading){
                        Text("Material Name: " + inventory.inventoryname).font(.title2).bold().foregroundColor(.white)
                        Text("Quantity: \(inventory.quantity)").font(.title3).foregroundColor(.white)
                     
                        
                    }.frame(width: 345, height: 64)
                }
            }
            .onDelete(perform: {IndexSet in
                for index in IndexSet {
                    if let id = inventory[index].id {
                        let inventoryDetailRequester = InventoryRequest(inventoryID: id)
                        inventoryDetailRequester.delete(auth: auth)
                    }
                }
                inventory.remove(atOffsets: IndexSet)
            })
            .listRowBackground(Color.clear)
            .background(RoundedRectangle(cornerRadius: 17).fill(Color.accentColor))
            .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        }.listStyle(.insetGrouped)
       
        .navigationBarTitle("Inventory", displayMode: .inline)
        .navigationBarItems(
          leading:
            Button(
              action: {
                presentationMode.wrappedValue.dismiss()
              }, label: {
                Text("Cancel")
                  .fontWeight(Font.Weight.regular)
              }))

      }
      .modifier(ResponsiveNavigationStyle())
        
        
      .sheet(item: $modal, onDismiss: {
           loadData()
      }) { modal in
          switch modal {
          case .add:
             InventoryForProductsView(auth: auth)
          case .update(let inventory):
             InventoryEditView(inventory: inventory)
          }
      }
        
     
      .onAppear(perform: loadData)
      .alert(isPresented: $showingInventoryErrorAlert) {
        Alert(title: Text("Error"), message: Text("There was an error getting the inventory"))
      }
    }
    
    func loadData() {
        
        if let a = auth.ui{
            
            UserInvetoryRequest<Inventory>(userID: a).getUserInventory{
                inventoryRequest in
                switch inventoryRequest {
                case .failure:
                    DispatchQueue.main.async {
                        self.showingInventoryErrorAlert = true
                    }
                case .success(let inventory):
                    DispatchQueue.main.async {
                        self.inventory = inventory
                    }
                    
                }
            }
        } else {
            
            UserInvetoryRequest<Inventory>(userID:UUID(uuidString: self.uinew)!).getUserInventory{
                productsRequest in
                switch productsRequest {
                case .failure:
                    DispatchQueue.main.async {
                        self.showingInventoryErrorAlert = true
                    }
                case .success(let inventory):
                    DispatchQueue.main.async {
                        self.inventory = inventory
                    }
                    
                }
            }
        }
    }
}

struct InventoryForProductsView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryForProductsView(auth: Auth())
    }
}
