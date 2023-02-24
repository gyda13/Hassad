//
//  UpdateProductView.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//
import SwiftUI
import Combine

struct UpdateProductView: View {
    
    
   
  var product: Product
    @State var productname: String
    @State var laborcost: Double
    @State var actualcost: Double
    @State var totalprice: Double
    @State var profit: Double
    @State var quantity: Int
    @State var profitD = 0.0
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()

  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var auth: Auth
  @State private var showingProductSaveErrorAlert = false

  init(product: Product) {
    self.product = product
      _productname = State(initialValue: product.productname)
      _laborcost = State(initialValue: product.laborcost)
      _actualcost = State(initialValue: product.actualcost)
      _totalprice = State(initialValue: product.totalprice)
      _profit = State(initialValue: product.profit)
      _quantity = State(initialValue: product.quantity)
      
      UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
  }

  var body: some View {
      
    NavigationView {
        
        ZStack{
            
            Color("Prime").edgesIgnoringSafeArea(.all)
            
            VStack(spacing:30){
          
                Text("Product name")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                 
                
                HStack {
                    TextField("", text: $productname)
                        .foregroundColor(Color.black)
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
               // .offset(y:-238)
                .padding(.horizontal,40)
          
          
                Text("Labor Cost")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                  
                
                HStack {
                    TextField("", value: $laborcost, formatter: formatter)
                        .foregroundColor(Color.black)
                        .keyboardType(.asciiCapableNumberPad)
                    
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
               // .offset(y:-238)
                .padding(.horizontal,40)
                
            
            
            
            
          
                Text("Materials Cost")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                  
                
                HStack {
                    TextField("", value: $actualcost, formatter: formatter)                        .foregroundColor(Color.black)
                        .keyboardType(.asciiCapableNumberPad)
                    
                    
                }
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white).frame(width: UIScreen.screenWidth-50, height: 35))
               // .offset(y:-238)
                .padding(.horizontal,40)
                
                
            
        
                Text("Profit Margin")
                    .foregroundColor(Color.white)
                    .font(.title2)
                    .bold()
                   
                
                Stepper("Profit Percentage % :  \(profitD, specifier: "%.2f")", value: $profitD, in: 0...100, step: 5)
                    .padding(.horizontal, 40)
        
            
            
            
        }.padding(.bottom,60)
        }
        
     // .navigationBarTitle("Edit Product", displayMode: .inline)
         .navigationBarTitle("Edit Product", displayMode: .inline).foregroundColor(.white)
        
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
          Button(action: updateProduct) {
           
                  Text("Save")
                      .foregroundColor(.white)
             
          }
            .disabled(productname.isEmpty || laborcost.isZero || actualcost.isZero
                      || totalprice.isZero || profitD == 0)
        
          .foregroundColor(Color.white)
          .bold()
      )
    }.modifier(ResponsiveNavigationStyle())
    .alert(isPresented: $showingProductSaveErrorAlert) {
      Alert(title: Text("Error"), message: Text("There was a problem saving the product"))
    }
  }
    

  func updateProduct() {
      let data = CreateProductData(productname: self.productname, laborcost: self.laborcost, actualcost: self.actualcost, totalprice: ((self.actualcost + self.laborcost) + (self.actualcost + self.laborcost) * (self.profitD) / 100.0), profit: ((self.actualcost + self.laborcost) * (self.profitD) / 100.0), quantity: self.quantity)
     
    guard let id = self.product.id else {
      fatalError("Product had no ID")
    }
    ProductRequest(productID: id).update(with: data, auth: auth) { result in
      switch result {
      case .failure:
        DispatchQueue.main.async {
          self.showingProductSaveErrorAlert = true
        }
      case .success(_):
        DispatchQueue.main.async {
            self.product.productname = self.productname
            self.product.laborcost = self.laborcost
            self.product.actualcost = self.actualcost
            self.product.totalprice = self.totalprice
            self.product.profit = self.profit
            self.product.quantity = self.quantity
          presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
}

struct UpdateProductView_Previews: PreviewProvider {
  static var previews: some View {
      UpdateProductView(product: Product(productname: "", laborcost: 0.0, actualcost: 0.0, totalprice: 0.0, profit: 0.0, quantity: 1, userID: UUID()))
  }
}
