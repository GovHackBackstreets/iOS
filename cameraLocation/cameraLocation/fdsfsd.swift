import UIKit
import AVFoundation
import QRCodeReader

protocol MyCustomCellDelegator {
    
    func callSegueFromCell(myData dataobject: String)
    
}

class ViewControlleruiouio: UIViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var sender2: UIButton!
    var delegate2: MyCustomCellDelegator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let send = UIButton()
        send.setTitle("capture", for: .normal)
        send.addTarget(self, action:#selector(scanAction(_:)) , for: .touchUpInside)
        send.translatesAutoresizingMaskIntoConstraints = false
        send.setTitleColor(UIColor.blue, for: .normal)
        self.sender2 = send
        self.view.addSubview(send)
        
        send.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -100).isActive = true
        send.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
        
    }

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()

    @IBAction func scanAction(_ sender: AnyObject) {

        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result!)
        }

        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        let valuefromqr = result.value
        print(valuefromqr)
        
        dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "toPopUp", sender: valuefromqr)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender != nil {
            
            let destinationView: PopUpViewController = segue.destination as! PopUpViewController
            destinationView.stringFromGR = (sender as? String)!
            
        } else {
            print("stuff")
        }
    }
    
    

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
