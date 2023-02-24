//
//  CreateProductView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//


import SwiftUI
import Combine

struct CreateProductView: View {
    
    init() {
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    
    @State var productname = ""
    @State var laborcost = ""
    @State var actualcost = ""
    @State var totalprice = ""
    @State var profit = ""
    @State var profitD = 0.0
    @State var quantity = 0

  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingProductSaveErrorAlert = false

  var body: some View {
      
    NavigationView {
        
        ZStack{
            
            Color("Prime").edgesIgnoringSafeArea(.all)
            
            HStack{
                VStack(alignment: .leading, spacing: 20){
                    
                    
                    Text("Product name")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    HStack {
                        TextField("", text: $productname)
                            .foregroundColor(Color("text"))
                            .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: UIScreen.screenWidth-40, height: 35).cornerRadius(5)
                    }
                    Text("Labor Cost")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    HStack {
                        TextField("", text: $laborcost)
                            .foregroundColor(Color("text"))
                            .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: UIScreen.screenWidth-40, height: 35).cornerRadius(5)
                            .keyboardType(.asciiCapableNumberPad)
                        
                            .onReceive(Just(laborcost)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.laborcost = filtered
                                }
                            }
                    }
                    
                    Text("Materials Cost")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    HStack {
                        TextField("", text: $actualcost)
                            .foregroundColor(Color("text"))
                            .textFieldStyle(RoundedBorderTextFieldStyle()).frame(width: UIScreen.screenWidth-40, height: 35).cornerRadius(5)
                            .keyboardType(.asciiCapableNumberPad)
                            .onReceive(Just(actualcost)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.actualcost = filtered
                                }
                            }
                    }
                    Text("Profit Margin")
                        .foregroundColor(Color.white)
                        .font(.title2)
                        .bold()
                    
                    Stepper("Profit Percentage % :  \(profitD, specifier: "%.2f")", value: $profitD, in: 0...100, step: 5)
                        .padding()
                    
                    
                }.padding(.bottom,60)
                
            }.padding()
        }
        .navigationBarTitle("Create Product", displayMode: .inline).foregroundColor(.white)
        
     
        
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
            
          Button(
            action: saveProduct) {
                if(productname != "" && laborcost != ""  && actualcost != "" && profitD != 0.0) {
                    Text("Save")
                        .foregroundColor(.white)
                } else {
                    Text("Save")
                }
          }
            .disabled(productname.isEmpty || laborcost.isEmpty || actualcost.isEmpty || profitD == 0.0
                )
          .bold()
         
      )

    }.modifier(ResponsiveNavigationStyle())
    .alert(isPresented: $showingProductSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the acronym"))
    }
  }


  func saveProduct() {
      
      let productSaveData = CreateProductData(productname: productname, laborcost: Double(laborcost)!, actualcost: Double(actualcost)!, totalprice: (Double(actualcost)! + Double(laborcost)! + (Double(actualcost)! + Double(laborcost)!) * (profitD) / 100.0), profit: (Double(actualcost)! + Double(laborcost)!) * (profitD) / 100.0, quantity: 0)
      ResourceRequest<Product>(resourcePath: "products").save(productSaveData, auth: auth) { result in
          switch result {
          case .failure:
              DispatchQueue.main.async {
                  self.showingProductSaveErrorAlert
              }
          case .success:
              DispatchQueue.main.async {
                  presentationMode.wrappedValue.dismiss()
              }
          }

      }
  }
  
    
    
    
}

struct CreateProductView_Previews: PreviewProvider {
  static var previews: some View {
      CreateProductView()
  }
}

    
    
   
