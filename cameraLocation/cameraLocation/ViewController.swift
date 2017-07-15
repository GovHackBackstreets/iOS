import UIKit
import AVFoundation
import QRCodeReader

class ViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    
    @IBOutlet weak var sender: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sender = UIButton()
        sender.setTitle("capture", for: .normal)
        sender.addTarget(self, action:#selector(scanAction(_:)) , for: .touchUpInside)
        sender.translatesAutoresizingMaskIntoConstraints = false
        sender.setTitleColor(UIColor.blue, for: .normal)
        self.sender = sender
        self.view.addSubview(sender)
        
        sender.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -100).isActive = true
        sender.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 0).isActive = true
        
        
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
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }

    // MARK: - QRCodeReaderViewController Delegate Methods

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }

}
