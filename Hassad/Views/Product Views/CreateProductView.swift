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
            VStack(spacing:30){
        
                Text("Product name")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                    //.offset(x:-105 , y:-278)
                
                HStack {
                    TextField("", text: $productname)
                        .foregroundColor(Color.black)
                       
                        //.offset(x:10)
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
               // .offset(y:-238)
                .padding(.horizontal,40)
            
            
           
                Text("Labor Cost")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                   // .offset(x:-120 , y:-166)
                
                HStack {
                    TextField("", text: $laborcost)
                        .foregroundColor(Color.black)
                       // .padding()
                       // .offset(x:10)
                    
                        .keyboardType(.numberPad)
                    
                        .onReceive(Just(laborcost)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.laborcost = filtered
                            }
                        }
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))  .padding(.horizontal,40)
               // .offset(y:-126)
                
            
            
           
                Text("Materials Cost")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                    //.offset(x:-103 , y:-54)
                
                HStack {
                    TextField("", text: $actualcost)
                        .foregroundColor(Color.black)
                       // .padding()
                        .offset(x:10)
                    
                        .keyboardType(.numberPad)
                    
                        .onReceive(Just(actualcost)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.actualcost = filtered
                            }
                        }
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width:UIScreen.screenWidth-50, height: 35))  .padding(.horizontal,40)
              //  .offset(y:-14)
                
                
            
            
      
                Text("Profit Margin")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                   // .offset(x:-110 , y:58)
                
                Stepper("Profit Percentage % :  \(profitD, specifier: "%.2f")", value: $profitD, in: 0...100, step: 5)
                   // .offset(y:98)
                    .padding(.horizontal, 40)
            
            
            
            
            
            }.padding(.bottom,60)
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

    
    
   
