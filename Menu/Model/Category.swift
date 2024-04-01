//
//  Category.swift
//  Menu
//
//  Created by Omid Shojaeian Zanjani on 31/03/24.
//

import Foundation
//
struct Category:Hashable, Equatable {
    
    var id:UUID = UUID()
    var type:SubCategoryItems
    var img:String
    var number:Int
    var subNames:[String] = []
    static var sampleCategory:[Category] = [
        Category(type: .Pizza, img: "pizza1",number: 16, subNames: [
            "Margherita",
            "Marinara",
            "Quattro Stagioni",
            "Capricciosa",
            "Quattro Formaggi",
            "Diavola",
            "Pizza ai Frutti di Mare"
        ]),
        Category(type: .Hamburger, img: "hamburger2",number: 5, subNames: [
            "Classic Hamburger",
            "Cheeseburger",
            "Bacon Cheeseburger",
            "Mushroom Swiss Burger",
            "BBQ Burger",
            "Jalapeno Burger",
            "Veggie Burger",
            "Turkey Burger",
            "Hawaiian Burger",
            "Double Burger"
        ]),
        Category(type: .Pasta, img: "pasta2",number: 8, subNames: [
            "Spaghetti",
            "Penne",
            "Fusilli",
            "Farfalle (Bowtie)",
            "Linguine",
            "Rigatoni",
            "Fettuccine",
            "Macaroni",
            "Lasagna",
            "Ravioli"
        ]),
        Category(type: .AlcoholDrinks, img: "alcohol1", number: 7, subNames: [
            "Martini",
            "Mojito",
            "Margarita",
            "Cosmopolitan",
            "Daiquiri",
            "Old Fashioned",
            "Manhattan",
            "Pina Colada",
            "Bloody Mary",
            "Long Island Iced Tea"
        ])
    ]
    
    

}
