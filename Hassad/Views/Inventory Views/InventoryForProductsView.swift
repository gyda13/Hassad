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
            ZStack{
                Color("defultColor").edgesIgnoringSafeArea(.all)
             
                    VStack{
                        List {
                            
                            ForEach(inventory, id: \.id){
                                inventory in
                                
                                
                                Button {
                                    modal = .update(inventory)
                                } label: {
                                    VStack(alignment: .leading){
                                        
                                        HStack {
                                            
                                            VStack{
                                                Text(inventory.inventoryname).font(.title2).bold().foregroundColor(.white)
                                                HStack{
                                                    Text(NSLocalizedString("  Quantity:", comment: "")).font(.title3).foregroundColor(.white)
                                                    Text("\(inventory.quantity)").font(.title3).foregroundColor(.white)
                                                }
                                            }
                                            Spacer()
                                            Image(systemName: "plus.circle")
                                                .foregroundColor(.white)
                                                .bold()
                                                .font(.system(size: 24))
                                            
                                        }.padding()
                                    }.frame(width: UIScreen.screenWidth - 40, height: 72)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .background(RoundedRectangle(cornerRadius: 17).fill(Color.accentColor))
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }.listStyle(.insetGrouped)
                    }
                
            }
        .navigationBarTitle("Inventory", displayMode: .inline)
        .foregroundColor(.black)
        .navigationBarItems(
            trailing:
            Button(
              action: {
                presentationMode.wrappedValue.dismiss()
              }, label: {
                Text("Done")
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
