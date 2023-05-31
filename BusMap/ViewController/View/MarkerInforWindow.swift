//
//  MyMarkerView.swift
//  GoogleLogin
//
//  Created by user on 6/25/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit
import LayoutOps

class MarkerInforWindow: UIView {

  var title: UILabel = {
       let v = UILabel()
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
   var subtitle: UILabel = {
       let v = UILabel()
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
   var button: UIButton = {
       let v = UIButton()
       v.translatesAutoresizingMaskIntoConstraints = false
       return v
   }()
   
    var imageView = UIImageView(){
        didSet{
            
            imageView.lx.fill()
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(r: 168, g: 168, b: 168)
        
        self.addSubview(title)
        
        self.addSubview(subtitle)
        
        self.addSubview(imageView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
