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
            HStack{
                VStack(alignment: .leading, spacing: 20){
                    
                    
                    
                    Text("Material name")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        TextField("", text: $inventoryname)
                            .frame(width: UIScreen.screenWidth-40, height: 35)
                            .foregroundColor(Color(.black))
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                        
                    }
                    
                    
                    
                    Text("Material price")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    
                    
                    HStack {
                        TextField("", text: $inventoryprice)
                            .frame(width: UIScreen.screenWidth-40, height: 35)
                            .foregroundColor(Color(.black))
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                            .keyboardType(.decimalPad)
                    }
                    
                    Text("Material quantity")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        TextField("", text: $quantity)
                            .frame(width: UIScreen.screenWidth-40, height: 35)
                            .foregroundColor(Color(.black))
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                            .keyboardType(.decimalPad)
                    }
                    
                }.padding(.bottom,90)
            }.padding()
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
                .foregroundColor(.white)
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


