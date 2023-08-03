//
//  ProductViewModel.swift
//  CommerceApp
//
//  Created by Pradheep Narendran P on 03/08/23.
//

import Foundation
import CoreData

@MainActor class ProductViewModel: ObservableObject, APIProtocol {
    private let viewContext = PersistenceController.shared.viewContext
    private var start = 0
    @Published var products: [Product] = []
    private let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    @Published var searchText: String = ""
    @Published var showingAlert: Bool = false
    private var errorMessage: String = ""
    init() {
        fetchProducts()
    }
    
    func loadMoreContent(){
        start += 5
        fetchProducts()
    }
    
    func searchProduct(){
        if searchText.isEmpty {
            fetchProducts()
            return
        }
        let request = NSFetchRequest<Product>(entityName: "Product")
        let productNamePredicate = NSPredicate(format: "productName CONTAINS[cd] %@", searchText)
        let productDescriptionPredicate = NSPredicate(format: "productDescription CONTAINS[cd] %@", searchText)
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [productNamePredicate, productDescriptionPredicate])
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(request)
            self.products = result
            
        } catch {
            
            print("Failed")
        }
    }
    
    func fetchProducts() {
        
        let request = NSFetchRequest<Product>(entityName: "Product")
        request.fetchOffset = start
        request.fetchLimit = 5
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: request){  fetchResult -> Void in
            if let resutls = fetchResult.finalResult {
                DispatchQueue.main.async {
                    if self.start > 0 {
                        self.products.append(contentsOf: resutls)
                    }else{
                        self.products = resutls
                    }
                }
            }
        }
        
        do {
            _ = try viewContext.execute(asyncFetchRequest)
        } catch {
            print("error: \(error)")
        }
    }
    
    func getIfProductExist(productID: Int?) -> Product? {
        let request = NSFetchRequest<Product>(entityName: "Product")
        let predicate = NSPredicate(format: "productID = %d", Int16(productID ?? 0))
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try viewContext.fetch(request)
            return result.count > 0 ? result.first : nil
        } catch {
            print("Failed")
            return nil
        }
    }
    
    
    func addDataToCoreData(productID: Int?, productName: String?, productPrice: Double?, productDescription: String?, productCategory: String?, rating: Double?, productImageURL: String?) {        
        let product = Product(context: viewContext)
        product.productID = Int16(productID ?? 0)
        product.productName = productName
        product.productDescription = productDescription
        product.productImageURL = productImageURL
        product.productCategory = productCategory
        product.productPrice = productPrice ?? 0
        product.rating = rating ?? 0
    }
    
    func save() {
        do {
            try viewContext.save()
        }catch {
            print(error.localizedDescription)
            print("Error saving")
        }
    }
    
    func getErrorMessage() -> String{
        return errorMessage
    }
    
    func getProductsFromAPI(){
        guard let url = URL(string: Constants.productURL) else {
            products = []
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        processAPIRequest(request: request, memberType: [ProductData].self, completionHandler: {[weak self] data, error in
            guard let dataUW = data else {
                DispatchQueue.main.async {
                    self?.products = []
                    self?.errorMessage = error?.localizedDescription ?? "Error occurred"
                    self?.showingAlert = true
                }
                return
            }
            self?.storeProductsFromAPI(productArray: dataUW)
        })
    }
    
    func storeProductsFromAPI(productArray: [ProductData]){
        for product in productArray {
            self.addDataToCoreData(productID: product.productID, productName: product.productName, productPrice: product.productPrice, productDescription: product.productDescription, productCategory: product.productCategory, rating: product.rating?.rate, productImageURL: product.productImageURL)
        }
        if viewContext.hasChanges {
            save()
        }
        self.fetchProducts()
    }
}

