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
                .padding(.horizontal,40)
            
            
         
                Text("Material price")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                  
                
                HStack {
                    TextField("", text: $inventoryprice)
                        .foregroundColor(Color.black)
                        .keyboardType(.asciiCapableNumberPad)
                    
                        .onReceive(Just(inventoryprice)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.inventoryprice = filtered
                            }
                        }
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
                .padding(.horizontal,40)
                
                
            
            
        
                Text("Material quantity")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
               
                
                HStack {
                    TextField("", text: $quantity)
                        .foregroundColor(Color.black)
                    
                        .keyboardType(.asciiCapableNumberPad)
                    
                        .onReceive(Just(quantity)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.quantity = filtered
                            }
                        }
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
                .padding(.horizontal,40)
            
            }.padding(.bottom,90)
        }
      .navigationBarTitle("Create Material", displayMode: .inline).foregroundColor(.white)
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
              if(inventoryname != "" && inventoryprice != "" && quantity != "") {
                  Text("Save")
                      .foregroundColor(.white)
              } else {
                  Text("Save")
              }
          } .disabled(inventoryname.isEmpty || inventoryprice.isEmpty || quantity.isEmpty)
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
