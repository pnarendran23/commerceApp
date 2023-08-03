//
//  ContentView.swift
//  CommerceApp
//
//  Created by Pradheep Narendran P on 03/08/23.
//



import SwiftUI
import CoreData

struct ProductsView: View {
    @ObservedObject var viewModel : ProductViewModel
    @State var isShowingProductDetail: Bool = false
    @State var productSelected: Product?
    init() {
        
        self.viewModel = ProductViewModel()
        viewModel.getProductsFromAPI()
    }
    var body: some View {
        NavigationStack {
            if self.viewModel.products.count > 0 {
                List {
                    ForEach(Array(viewModel.products.enumerated()), id: \.offset) { index, product in
                        ZStack{
                            Button(action: {
                                self.productSelected = product
                                self.isShowingProductDetail = true
                            },
                                   label: {
                                HStack(spacing: 10){
                                    AsyncImage(url: URL(string: product.productImageURL ?? ""), scale: 3){ phase in
                                        switch phase {
                                        case .empty:
                                            Image(systemName: "photo.artframe")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .overlay(content: {
                                                    ProgressView()
                                                        .progressViewStyle(.circular)
                                                })
                                            
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .aspectRatio(contentMode: .fit)
                                        case .failure:
                                            Image(systemName: "photo.artframe")
                                                .resizable().frame(width: 50, height: 50)
                                        @unknown default:
                                            Image(systemName: "photo.artframe")
                                                .resizable().frame(width: 50, height: 50)
                                        }
                                    }
                                    VStack(spacing: 10) {
                                        VStack{
                                            Text(product.productName ?? "").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
                                            Text(product.productCategory?.capitalized ?? "").font(.subheadline).frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        HStack {
                                            Text("\(String(format: "%.2f", product.productPrice).setAsRupees())").frame(maxWidth: .infinity, alignment: .leading).font(.custom("Arial", size: 19)).fontWeight(.bold)
                                            Spacer()
                                            if product.rating > 0 {
                                                RatingView(rating: product.rating, maxRating: 5)
                                            }
                                        }
                                    }
                                }
                            }).foregroundColor(.black)
                        }
                        
                        .onAppear(){
                            self.checkIfPaginationNeeded(curentIndex: index)
                        }
                    }
                }
                .navigationTitle("Products")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "cart").foregroundColor(.black)
                        })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "arrow.backward").foregroundColor(.black)
                        })
                    }
                }
                .navigationDestination(isPresented: $isShowingProductDetail, destination: {
                    ProductDetailsView(product: productSelected)
                })
                
            } else{
                Text("No product found")
            }
            
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Error"), message: Text("\(viewModel.getErrorMessage())"), dismissButton: .default(Text("OK")))
        }
        
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search Products")
        .onChange(of: viewModel.searchText) { newText in
            viewModel.searchProduct()
        }
    }
    
    func checkIfPaginationNeeded(curentIndex: Int){
        guard curentIndex == viewModel.products.count - 1 else { return }
        viewModel.loadMoreContent()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}

