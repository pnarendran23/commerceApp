//
//  ProductDetailsView.swift
//  CommerceApp
//
//  Created by Pradheep Narendran P on 04/08/23.
//

import SwiftUI

struct ProductDetailsView: View {
    
    private var viewModel: ProductDetailsViewModel
    @State var showingAlert: Bool = false
    init(product: Product?) {
        self.viewModel = ProductDetailsViewModel(
            productName: product?.productName ?? "",
            productDescription: product?.productDescription ?? "",
            productPrice: product?.productPrice ?? 0,
            productRating: product?.rating ?? 0,
            productCategory: product?.productCategory ?? "",
            productImageURL: product?.productImageURL ?? "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10){
                    AsyncImage(url: URL(string: viewModel.getProductImageURL()), scale: 5) {
                        image in
                        image
                    } placeholder: {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    HStack {
                        Text("\(String(format: "%.2f", viewModel.getProductPrice()).setAsRupees())").frame(maxWidth: .infinity, alignment: .leading).font(.title2).fontWeight(.bold)
                        Spacer()
                        Text("Rating:").font(.caption).fontWeight(.light)
                        RatingView(rating: viewModel.getProductRating(), maxRating: 5)
                        Text("(\(String(format: "%.1f)", viewModel.getProductRating()))").font(.caption).fontWeight(.light)
                        
                    }
                    VStack(spacing: 8){
                        Text(viewModel.getProductName()).frame(maxWidth: .infinity, alignment: .leading).font(.title3).fontWeight(.heavy)
                        Text(viewModel.getProductCategory()).frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).fontWeight(.light)
                        Text("Product Description").frame(maxWidth: .infinity, alignment: .leading).font(.subheadline).fontWeight(.heavy)
                        Text(viewModel.getProductDescription()).frame(maxWidth: .infinity, alignment: .leading).font(.subheadline)
                        Button(action: {
                            showingAlert = true
                        }){
                            HStack {
                                Text("Add to cart").frame(maxWidth: .infinity, alignment: .center)
                                Spacer()
                            }
                        }
                        
                        .contentShape(Rectangle())
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.yellow))
                    }
                }
                .navigationTitle("Product Details").font(.title)
                .navigationBarTitleDisplayMode(.automatic)
            }.padding()
        }
        Spacer()
        
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Yay! Item added to cart"), message: Text("\(viewModel.getProductName()) has been added to your shopping cart. Please check your cart to proceed for payment."), dismissButton: .default(Text("Got it")))
            }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(product: nil)
    }
}
