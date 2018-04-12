//
//  ColorPicker.swift
//  d12fa poc
//
//  Created by Piyapan Poomsirivilai on 11/4/2561 BE.
//  Copyright © 2561 Codium Co. Ltd. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
    func colorSelected(_ sender:ColorPicker, color: UIColor)
}

class ColorPicker: UIView {

    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var color2: UIView!
    @IBOutlet weak var color3: UIView!
    @IBOutlet weak var color4: UIView!
    
    var colorViews:Array<UIView> = []
    
    let nibName = "ColorPicker"
    let selectedBorderColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
    let selectedBorderSize:CGFloat = 5.0
    var colorSelectedDelegate:ColorPickerDelegate? = nil
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
        
        self.colorViews = [color1, color2, color3, color4]
        removeSelection()
        
        return view
    }
    
    func select(hex:String) -> UIColor? {
        removeSelection()
     
        let matched = colorViews.filter({(view) -> Bool in
            return view.backgroundColor?.hexString == hex
            })
        
        guard matched.count > 0 else { return nil }
        
        removeSelection()
        let selectedView = matched[0]
        selectedView.layer.borderColor = selectedBorderColor
        selectedView.layer.borderWidth = selectedBorderSize
        
        return selectedView.backgroundColor
    }
    
    func removeSelection() {
        for view in colorViews {
            view.layer.borderWidth = 0.0
            
            guard let backgroundColor = view.backgroundColor else { continue }
            
            if backgroundColor.isWhite() {
                view.layer.borderColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
                view.layer.borderWidth = 1.0
            }
        }
    }
    
    override func didMoveToSuperview() {
        for view in colorViews {
            let g = UITapGestureRecognizer(target: self, action:  #selector (self.colorSelected (_:)))
            
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(g)
        }
    }
    
    @objc func colorSelected(_ sender:UITapGestureRecognizer){
        guard let selectedView = sender.view else { return }
        guard let backgroundColor = selectedView.backgroundColor else { return }
        
        removeSelection()
        selectedView.layer.borderColor = selectedBorderColor
        selectedView.layer.borderWidth = selectedBorderSize
        self.colorSelectedDelegate?.colorSelected(self, color: backgroundColor)
    }
}
