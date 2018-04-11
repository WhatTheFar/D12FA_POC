//
//  ColorPicker.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 11/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import UIKit

class ColorPicker: UIView {

    @IBOutlet weak var color1: UIView!
    
    let nibName = "ColorPicker"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    override func didMoveToSuperview() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.color1.isUserInteractionEnabled = true
        self.color1.addGestureRecognizer(gesture)
        
        color1.layer.borderColor = UIColor.init(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        color1.layer.borderWidth = 2.0
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        print("selected")
    }
}
