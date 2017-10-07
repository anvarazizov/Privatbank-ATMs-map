//
//  CustomAnnotationPopUpView.swift
//  PrivatbankATMMap
//
//  Created by Anvar Azizov on 07.10.17.
//  Copyright © 2017 Anvar Azizov. All rights reserved.
//

import UIKit

class CustomAnnotationPopUpView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    func setupXib() {
        UINib(nibName: "CustomAnnotationPopUpView", bundle: nil).instantiate(withOwner: self, options: nil)
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 4.0
        contentView.backgroundColor = UIColor.white
        contentView.alpha = 0.9
    }
}
