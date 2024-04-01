//
//  SubCategory.swift
//  Menu
//
//  Created by Omid Shojaeian Zanjani on 31/03/24.
//

import Foundation


struct SubCategory : Hashable, Equatable{
    var id: UUID = UUID()
    var name:String
    var image:String
    var description:String
    var category:Category
    var price:Int
    var isFavorite:Bool
    
    mutating func toggleFavorite() {
            isFavorite.toggle()
        }
}
