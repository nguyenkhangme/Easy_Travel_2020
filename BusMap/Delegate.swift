//
//  Delegate.swift
//  GoogleLogin
//
//  Created by user on 6/12/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import Foundation

protocol HandleMapSearch {
    func parseDataFromSearch(viewModel: [MapsViewModel], row: Int)
}

protocol ResultClicked: class {
    var isClicked: Bool { get set }
    
    //func Clicked()
}

protocol  searchBarSearchButtonClicked: class {
    func Clicked(category: GoogleCategory)
    
}

protocol updateSearchResultDelegate: class {
    func updateSearchResult(searchBarText: String)
}
