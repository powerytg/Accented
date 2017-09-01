//
//  CategorySelectorModel.swift
//  Accented
//
//  Created by You, Tiangong on 8/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class CategorySelectorModel: MenuModel {

    override init() {
        super.init()

        // Supported categories, in alphabetical order
        items = [CategoryEntry(category : .uncategorized, text : "Uncategorized"),
                 CategoryEntry(category : .abstract, text : "Abstract"),
                 CategoryEntry(category : .aerial, text : "Aerial"),
                 CategoryEntry(category : .animals, text : "Animals"),
                 CategoryEntry(category : .blackAndWhite, text : "Black & White"),
                 CategoryEntry(category : .celebrities, text : "Celebrities"),
                 CategoryEntry(category : .cityAndArchitecture, text : "City & Architecture"),
                 CategoryEntry(category : .commerical, text : "Commerical"),
                 CategoryEntry(category : .concert, text : "Concert"),
                 CategoryEntry(category : .family, text : "Family"),
                 CategoryEntry(category : .fashion, text : "Fashion"),
                 CategoryEntry(category : .film, text : "Film"),
                 CategoryEntry(category : .fineArt, text : "Fine Art"),
                 CategoryEntry(category : .food, text : "Food"),
                 CategoryEntry(category : .journalism, text : "Journalism"),
                 CategoryEntry(category : .landscapes, text : "Landscapes"),
                 CategoryEntry(category : .macro, text : "Macro"),
                 CategoryEntry(category : .nature, text : "Nature"),
                 CategoryEntry(category : .night, text : "Night"),
                 CategoryEntry(category : .nude, text : "Nude"),
                 CategoryEntry(category : .people, text : "People"),
                 CategoryEntry(category : .performingArts, text : "Performing Arts"),
                 CategoryEntry(category : .sport, text : "Sport"),
                 CategoryEntry(category : .stillLife, text : "Still Life"),
                 CategoryEntry(category : .street, text : "Street"),
                 CategoryEntry(category : .transportation, text : "Transportation"),
                 CategoryEntry(category : .travel, text : "Travel"),
                 CategoryEntry(category : .underwater, text : "Underwater"),
                 CategoryEntry(category : .urbanExploration, text : "Urban Exploration"),
                 CategoryEntry(category : .wedding, text : "Wedding")]

        // Default selected option is "uncategoried"
        selectedItem = items[0]
    }
}
