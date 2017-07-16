//
//  ViewController.swift
//  MapKitOverlay
//
//  Created by Remi Robert on 15/07/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import QRCodeReader

struct DataPoint {
    let lat: Double
    let long: Double
}

let locations = [
    DataPoint(lat: 47.4771, long: -0.7893),
    DataPoint(lat: 48.9666, long: 1.6996),
    DataPoint(lat: 47.3524, long: 4.6304),
    DataPoint(lat: 49.9104, long: 9.8947)
]

internal final class IdView: UIView {
    private let label = UILabel(frame: CGRect.zero)
    var id: String? {
        didSet {
            isHidden = id == nil ? true : false
            label.text = nil
            if let id = id {
                label.text = "Product id : \(id)"
            }
        }
    }

    init(id: String?) {
        self.id = id
        super.init(frame: CGRect.zero)
        setupHierarchy()
        setupLatyout()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(label)
    }

    private func setupLatyout() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
    }

    private func setupViews() {
        backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
    }
}

internal final class BlurButton: UIButton {
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
    let imageViewTop = UIImageView(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(effectView)
        effectView.addSubview(imageViewTop)
    }

    private func setupLayout() {
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageViewTop.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupViews() {
        effectView.isUserInteractionEnabled = false
        imageViewTop.isUserInteractionEnabled = false
        imageViewTop.contentMode = .scaleAspectFit
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }
}

class ViewController: UIViewController {
    fileprivate let locationTracker = LocationTripTracker()
    fileprivate let mapView = MapView()
    fileprivate let buttonPosition = BlurButton(frame: CGRect.zero)
    fileprivate let buttonScan = BlurButton(frame: CGRect.zero)
    fileprivate let buttonStep = BlurButton(frame: CGRect.zero)
    fileprivate let titleLabel = UILabel(frame: CGRect.zero)
    fileprivate let idView = IdView(id: nil)
    fileprivate var id: String? {
        didSet {
            idView.id = id
            buttonStep.isHidden = id == nil ? true : false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        id = nil
        setupHierarchy()
        setupLayout()
        setupViews()
        setupLocation()
    }

    private func setupLocation() {
        locationTracker.requestForAuthorization()
        locationTracker.startLocationTracking()
    }
}

extension ViewController {
    @objc fileprivate func resetPosition() {
        guard let currentLocation = locationTracker.currentLocation else {
            return
        }
        mapView.zoom(at: currentLocation.coordinate)
    }

    @objc fileprivate func scanQrCode() {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
        }
        let controller = QRCodeReaderViewController(builder: builder)
        controller.delegate = self
        controller.startScanning()
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController {
    fileprivate func setupHierarchy() {
        view.addSubview(mapView)
        view.addSubview(buttonPosition)
        view.addSubview(buttonScan)
        view.addSubview(idView)
        view.addSubview(buttonStep)
        navigationController?.navigationBar.addSubview(titleLabel)
    }

    fileprivate func setupLayout() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        buttonPosition.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        buttonScan.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalTo(buttonPosition)
            make.leftMargin.equalTo(buttonPosition.snp.rightMargin).offset(40)
        }
        buttonStep.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalTo(buttonPosition)
            make.rightMargin.equalTo(buttonPosition.snp.leftMargin).offset(-40)
        }
        idView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
    }

    fileprivate func setupViews() {
        mapView.setNewPoints(points: locations)
        buttonPosition.imageViewTop.image = UIImage(named: "position")
        buttonPosition.addTarget(self, action: #selector(resetPosition), for: .touchUpInside)
        buttonPosition.layer.cornerRadius = 35
        buttonScan.imageViewTop.image = UIImage(named: "qrcode-scan")
        buttonScan.addTarget(self, action: #selector(scanQrCode), for: .touchUpInside)
        buttonScan.layer.cornerRadius = 25
        buttonStep.imageViewTop.image = UIImage(named: "add-step")
        buttonStep.addTarget(self, action: #selector(scanQrCode), for: .touchUpInside)
        buttonStep.layer.cornerRadius = 25
        idView.id = nil
        titleLabel.textColor = UIColor.black
        titleLabel.text = "Stamp food 🍗"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
}

extension ViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        DispatchQueue.main.async {
            self.id = result.value
        }
        dismiss(animated: true, completion: nil)
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {}

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}
