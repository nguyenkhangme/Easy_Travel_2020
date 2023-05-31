//
//  CustomSearchBar.swift
//  GoogleLogin
//
//  Created by user on 6/18/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import Foundation

import UIKit

class CustomSearchBar: UISearchBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }
}

class CustomSearchController: UISearchController, UISearchBarDelegate {

    lazy var _searchBar: CustomSearchBar = {
        [unowned self] in
        let result = CustomSearchBar(frame: .zero)
        result.delegate = self

        return result
    }()

    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
}
