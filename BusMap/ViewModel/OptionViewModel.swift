//
//  CellVM.swift
//  GoogleLogin
//
//  Created by user on 6/11/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import Foundation

struct OptionViewModel{
    var title: String
    var isMapBox: Bool
    
    init(Option: Option){
        self.title = Option.title
        self.isMapBox = Option.isMapBox
        
        if Option.title == "Google Maps" || Option.title == "Map Box"{
            if isMapBox {
                self.title = "Google Maps"
            } else {
                self.title = "Map Box"
            }
        }
    }
}
