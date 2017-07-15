//
//  PopUpViewController.swift
//  cameraLocation
//
//  Created by Landon Vago-Hughes on 15/07/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class PopUpViewController: UIViewController, UITextFieldDelegate {
    
    
    var stringFromGR = String()
    @IBOutlet weak var storeNameString: SkyFloatingLabelTextField!
    @IBOutlet weak var popUpView: designView!

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.popUpView.layer.cornerRadius = 15.0
        super.viewDidLoad()
        setup()
        print(stringFromGR)
        
        
    }
    
    private func setup() {
        
        let storeLabel = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        
        let genericColor = UIColor(red:90/255, green:187/255, blue:234/255, alpha:1.0)
        
        storeLabel.placeholder = "Storename"
        storeLabel.title = "Storename"
        storeLabel.errorColor = UIColor.red
        storeLabel.delegate = self
        storeLabel.translatesAutoresizingMaskIntoConstraints = false
        storeLabel.lineHeight = 1.5
        storeLabel.selectedLineHeight = 3.5
        storeLabel.selectedLineColor = genericColor
        storeLabel.selectedTitleColor = genericColor
        storeLabel.tintColor = genericColor
        self.popUpView.addSubview(storeLabel)
        
        storeLabel.centerXAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
        storeLabel.centerYAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.centerYAnchor, constant: 0).isActive = true
        storeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

}
