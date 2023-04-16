//
//  MilkShake.swift
//  FoodDeliveryApp
//
//  Created by Balaji on 08/09/22.
//

import SwiftUI

// MARK: Model And Sample Data
struct MilkShake: Identifiable,Hashable{
    var id: String = UUID().uuidString
    var title: String
    var price: String
    var image: String
}

var milkShakes: [MilkShake] = [
    .init(title: "Hyderabi Biriyani", price: "originating in the kitchens of the Nizam of Hyderabad, it combines elements of Hyderabadi and Mughlai cuisines.", image: "Shake 1"),
    .init(title: "Kaju Ladoo", price: "origin of ladoos can be traced back to the 4th century BC when an ancient Indian physician named Susruta used the sweet as a medium to feed Ayurvedic medicines to his patients.", image: "Shake 2"),
    .init(title: "Boote Ka Samosa", price: "a dainty delicacy, served as a snack in the great courts of the mighty Ghaznavid empire.", image: "Shake 3"),
    .init(title: "Palak Paneer", price: "a north Indian vegetarian delecacy with origins in the Punjab region.", image: "Shake 4"),
]
