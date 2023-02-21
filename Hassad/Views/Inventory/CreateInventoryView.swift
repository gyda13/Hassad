//
//  CreateInventoryView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//


import SwiftUI
import Combine

struct CreateInventoryView: View {
    @State var inventoryname = ""
    @State var inventoryprice = ""
    @State var quantity = ""

    
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingInventorySaveErrorAlert = false

  var body: some View {
      
    NavigationView {
        ZStack{
            
            Color("Prime").edgesIgnoringSafeArea(.all)
            
            Section {
                Text("Material name")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                    .offset(x:-105 , y:-278)
                
                HStack {
                    TextField("", text: $inventoryname)
                        .foregroundColor(Color.black)
                        .padding()
                        .offset(x:10)
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: 355, height: 35))
                .offset(y:-238)
            }
            
            Section {
                Text("Material price")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                    .offset(x:-105 , y:-166)
                
                HStack {
                    TextField("", text: $inventoryprice)
                        .foregroundColor(Color.black)
                        .padding()
                        .offset(x:10)
                    
                        .keyboardType(.numberPad)
                    
                        .onReceive(Just(inventoryprice)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.inventoryprice = filtered
                            }
                        }
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: 355, height: 35))
                .offset(y:-126)
                
               
            }
      
            Section {
                Text("Material Quantity")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                    .offset(x:-90 , y:-54)
                
                HStack {
                    TextField("", text: $quantity)
                        .foregroundColor(Color.black)
                        .padding()
                        .offset(x:10)
                    
                        .keyboardType(.numberPad)
                    
                        .onReceive(Just(quantity)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.quantity = filtered
                            }
                        }
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: 355, height: 35))
         
               
            }
          
           
        }
      .navigationBarTitle("Create Inventory", displayMode: .inline).foregroundColor(.white)
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
              if(inventoryname != "" && inventoryprice != "" ) {
                  Text("Save")
                      .foregroundColor(.white)
              } else {
                  Text("Save")
              }
          } .disabled(inventoryname.isEmpty || inventoryprice.isEmpty)
      )
    }.modifier(ResponsiveNavigationStyle())
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
