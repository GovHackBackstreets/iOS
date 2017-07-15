//
//  PopUpViewController.swift
//  cameraLocation
//
//  Created by Landon Vago-Hughes on 15/07/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CoreLocation
import MapKit

class location {
    
    var latitude: String?
    var longitude: String?
    
    init(lat: String, long: String) {
        self.longitude = long
        self.latitude = lat
    }
    
}

class PopUpViewController: UIViewController, UITextFieldDelegate {
    
    var stringFromGR = String()
    @IBOutlet weak var storeNameString: SkyFloatingLabelTextField!
    @IBOutlet weak var popUpView: designView!
    @IBOutlet weak var upload: UIButton!
    
    @IBOutlet weak var labelEx: UILabel!

    let apiPost = PostApi()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.popUpView.layer.cornerRadius = 15.0
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
    }
    
    private func setup() {
        
        let storeLabel = SkyFloatingLabelTextField(frame: CGRect(x: 0, y: 0, width: 50, height: 10))
        let genericColor = UIColor(red:90/255, green:187/255, blue:234/255, alpha:1.0)
        let upload = UIButton()
    
        
        upload.translatesAutoresizingMaskIntoConstraints = false
        upload.setImage(UIImage(named: "upload"), for: .normal)
        upload.tag = 1
        upload.addTarget(self, action: #selector(setToApiClass(_:)), for: .touchUpInside)
        self.popUpView.addSubview(upload)
        
        storeLabel.placeholder = "Supplier"
        storeLabel.title = "Supplier"
        storeLabel.errorColor = UIColor.red
        storeLabel.delegate = self
        storeLabel.translatesAutoresizingMaskIntoConstraints = false
        storeLabel.lineHeight = 1.5
        storeLabel.selectedLineHeight = 3.5
        storeLabel.selectedLineColor = genericColor
        storeLabel.selectedTitleColor = genericColor
        storeLabel.tintColor = genericColor
        self.storeNameString = storeLabel
        self.popUpView.addSubview(storeLabel)
        
        storeLabel.centerXAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
        storeLabel.topAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        storeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        storeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        upload.centerXAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
        upload.bottomAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        upload.widthAnchor.constraint(equalToConstant: 40).isActive = true
        upload.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.popUpView.frame.origin.y -= 50
            }
        }
    }
    
    func keyboardWillhide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.popUpView.frame.origin.y += 50
            }
        }
    }
    
    @IBAction func setToApiClass(_ sender: UIButton) {
        if sender.tag == 1 {
            
            let suppplier = self.storeNameString.text
            let locate = location(lat: "51.1111", long: "-0.12121")
            let dict = createDictionary(location: locate, supplier: suppplier!)
            
            apiPost.post(parameters: dict, id: self.stringFromGR)
            
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let field = textField as? SkyFloatingLabelTextField {
            field.resignFirstResponder()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        }
        return true
    }
    
    func createDictionary(location: location, supplier: String) -> [String: Any] {
        let latitude = location.latitude!
        let longitude = location.longitude!
        
        let dictionary: [String: Any] = [
            "location": ["lat": "\(latitude)", "long": "\(longitude)"],
            "supplier": supplier,
            "rating": 1.3,
            
        ]
        
        return dictionary
    }
    
    
    
    
 
    
    
    
    
    
    
    
    
    

}
