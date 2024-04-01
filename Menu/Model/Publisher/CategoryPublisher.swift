//
//  CategoryPublisher.swift
//  Menu
//
//  Created by Omid Shojaeian Zanjani on 31/03/24.
//

import Foundation
import SwiftUI

enum SubCategoryItems: String ,CaseIterable {
    case  Pizza = "Pizza"
    case  Hamburger = "Hamburger"
    case  Pasta = "Pasta"
    case  AlcoholDrinks = "alcohol"
}






class SubCategoryPublisher:ObservableObject {
    @Published var subCategory:[SubCategory] = []
    
    
    init(){
        subcategoryMaker(categoty:Category(type: .Pizza, img: "pizza1",number: 16, subNames: [
            "Margherita",
            "Marinara",
            "Quattro Stagioni",
            "Capricciosa",
            "Quattro Formaggi",
            "Diavola",
            "Pizza ai Frutti di Mare"
        ]) )
    }
    func subcategoryMaker(categoty:Category ){
        subCategory.removeAll()
        print(categoty.subNames)
        for item in 1...categoty.number{
            subCategory.append(SubCategory(name: categoty.subNames.randomElement() ?? "noNmae", image: generateImageName(prefix: categoty.type.rawValue, number: item), description: "Something related to the food item exactly here GenerativeAI will generate some article base on user interest", category: categoty, price: 10,isFavorite: false))
            
            print(generateImageName(prefix: categoty.type.rawValue, number: item))
        }
    }
    
    func toggleFavoriteItem(sub:SubCategory ){
        var index = subCategory.firstIndex(of: sub)
        
        guard index != nil else { return}

        subCategory[index!] = SubCategory(id: sub.id, name: sub.name, image: sub.image, description: sub.description, category: sub.category, price: sub.price, isFavorite: sub.isFavorite ? false:true)
    }
    
    func filterSubCategory(words:String){
        var results = subCategory.filter({$0.name.hasPrefix(words)})
        subCategory = results
    }
    
  private  func generateImageName(prefix:String, number:Int) -> String {
      "\(prefix)_\(number)".lowercased()
    }
}
