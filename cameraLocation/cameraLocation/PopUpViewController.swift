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

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var forLabel1: SkyFloatingLabelTextField!
    @IBOutlet weak var forLabel2: SkyFloatingLabelTextField!
    @IBOutlet weak var forLabel3: SkyFloatingLabelTextField!
    @IBOutlet weak var forLabel4: SkyFloatingLabelTextField!
    
    @IBOutlet weak var labelEx: UILabel!

    let apiPost = PostApi()
    
    var dictionaryN: [String: Any] = [:]

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
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let label4 = UILabel()
        
        let forLabel1 = SkyFloatingLabelTextField()
        let forLabel2 = SkyFloatingLabelTextField()
        let forLabel3 = SkyFloatingLabelTextField()
        let forLabel4 = SkyFloatingLabelTextField()

        self.label1 = label1
        self.label2 = label2
        self.label3 = label3
        self.label4 = label4
        
        self.forLabel1 = forLabel1
        self.forLabel2 = forLabel2
        self.forLabel3 = forLabel3
        self.forLabel4 = forLabel4
        
        setupNsConstraints(labels: label1, height: 80,  text: "Physical Quality")
        setupNsConstraints(labels: label2, height: 120, text: "Chemical Contaminents")
        setupNsConstraints(labels: label3, height: 160, text: "Microbial Safety")
        setupNsConstraints(labels: label4, height: 200, text: "Temperature Control")
        
        setupNsConstraintsNumber(labels: forLabel1, height: 80, text: "score")
        setupNsConstraintsNumber(labels: forLabel2, height: 120, text: "score")
        setupNsConstraintsNumber(labels: forLabel3, height: 160, text: "score")
        setupNsConstraintsNumber(labels: forLabel4, height: 200, text: "score")
        
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
        upload.bottomAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.bottomAnchor, constant: -5).isActive = true
        upload.widthAnchor.constraint(equalToConstant: 60).isActive = true
        upload.heightAnchor.constraint(equalToConstant: 60).isActive = true
    
    }
    
    private func setupNsConstraints(labels: UILabel, height: CGFloat, text: String) {
        
        labels.font = UIFont(name: "Avenir-Black", size: 13.0)
        labels.text = text
        labels.textColor = UIColor.black
        labels.translatesAutoresizingMaskIntoConstraints = false
        self.popUpView.addSubview(labels)
        
        labels.leadingAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        labels.topAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.topAnchor, constant: height).isActive = true
        
    }
    private func setupNsConstraintsNumber(labels: SkyFloatingLabelTextField, height: CGFloat, text: String) {
        
        let genericColor = UIColor(red:90/255, green:187/255, blue:234/255, alpha:1.0)
        
        labels.placeholder = text
        labels.title = text
        labels.textAlignment = .center
        labels.errorColor = UIColor.red
        labels.delegate = self
        labels.translatesAutoresizingMaskIntoConstraints = false
        labels.lineHeight = 1.5
        labels.selectedLineHeight = 3.5
        labels.selectedLineColor = genericColor
        labels.selectedTitleColor = genericColor
        labels.tintColor = genericColor
        self.storeNameString = labels
        self.popUpView.addSubview(labels)
        
        labels.trailingAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.trailingAnchor, constant: -10).isActive = true
        labels.topAnchor.constraint(equalTo: popUpView.layoutMarginsGuide.topAnchor, constant: height-20).isActive = true
        labels.widthAnchor.constraint(equalToConstant: 50).isActive = true
        labels.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                self.popUpView.frame.origin.y -= 20
            }
        }
    }
    
    func keyboardWillhide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.popUpView.frame.origin.y += 20
            }
        }
    }
    
    @IBAction func setToApiClass(_ sender: UIButton) {
        if sender.tag == 1 {
            
            let suppplier = self.storeNameString.text
            let locate = location(lat: "51.1111", long: "-0.12121")
            createDictionary(location: locate, supplier: suppplier!)
            

        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let field = textField as? SkyFloatingLabelTextField {
            field.resignFirstResponder()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillhide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        }
        return true
    }
    
    func createDictionary(location: location, supplier: String) {
        let latitude = location.latitude!
        let longitude = location.longitude!
        let physical = Double(forLabel1.text!)
        let chemical = Double(forLabel2.text!)
        let microbial = Double(forLabel3.text!)
        let temp = Double(forLabel4.text!)

        let dict: [String: Any] = [
            "location": ["lat": "\(latitude)", "long": "\(longitude)"],
            "supplier": supplier,
            "facilityName": "bigfactory",
            "physicalQuality": physical!,
            "FSA": "govhack",
            "chemicalContaminents": chemical!,
            "microbialSafety": microbial!,
            "temperatureControl": temp!,
        ]
            
        print(dict)
            
        self.dictionaryN = dict
            
        apiPost.post(parameters: dictionaryN, id: self.stringFromGR)
        
        

    }

    
    
    
 
    
    
    
    
    
    
    
    
    

}
