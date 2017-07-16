//
//  MapView.swift
//  MapKitOverlay
//
//  Created by Remi Robert on 15/07/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

internal final class CalloutInformation: UIView {
    private let labelQuality = UILabel(frame: CGRect.zero)
    private let imageViewQuality = UIImageView(frame: CGRect.zero)

    enum Quality {
        case perfect
        case minorIssue
        case warning

        var image: UIImage {
            switch self {
            case .perfect:
                return UIImage(named: "rating-ok")!
            case .minorIssue:
                return UIImage(named: "rating-warning")!
            case .warning:
                return UIImage(named: "rating-danger")!
            }

        }
    }

    init(title: String, quality: Quality) {
        super.init(frame: CGRect.zero)
        labelQuality.text = title
        imageViewQuality.image = quality.image
        setupHierarchy()
        setupLayout()
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(labelQuality)
        addSubview(imageViewQuality)
    }

    private func setupLayout() {
        labelQuality.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
        }
        imageViewQuality.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }

    private func setupViews() {
        labelQuality.font = UIFont.boldSystemFont(ofSize: 20)
        labelQuality.textColor = UIColor.black
        imageViewQuality.contentMode = .scaleAspectFit
    }
}

internal class ViewControlDetailFactory {
    func create() -> [UIView] {
        return [
            CalloutInformation(title: "Physical quality", quality: .perfect),
            CalloutInformation(title: "Chemical contaminents", quality: .perfect),
            CalloutInformation(title: "Microbial safety", quality: .minorIssue),
            CalloutInformation(title: "Temperature control", quality: .warning)
        ]
    }
}

internal final class CalloutView: UIView {
    private let effectView: UIVisualEffectView
    private let labelName = UILabel(frame: CGRect.zero)
    private let stackView: UIStackView
    private let controlViewsFactory = ViewControlDetailFactory()

    override init(frame: CGRect) {
        effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        stackView = UIStackView(arrangedSubviews: controlViewsFactory.create())
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        setupHierarchy()
        setupLayout()
        setupViews()
    }

    private func setupHierarchy() {
        addSubview(effectView)
        effectView.addSubview(labelName)
        effectView.addSubview(stackView)
    }

    private func setupLayout() {
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        labelName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-5)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(labelName.snp.bottomMargin).offset(20)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }

    private func setupViews() {
        backgroundColor = UIColor.clear
        clipsToBounds = true
        layer.borderWidth = 5
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 5
        labelName.numberOfLines = 0
        labelName.font = UIFont.boldSystemFont(ofSize: 30)
        labelName.textColor = UIColor.black
        labelName.text = "name"
        stackView.backgroundColor = UIColor.white
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
    }

    func present(parentView: UIView) {
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.center = CGPoint(x: parentView.bounds.size.width / 2,
                                              y: -self.bounds.size.height * 0.52)
        }, completion: nil)
    }

    func dismiss(parentView: UIView) {
        removeFromSuperview()
    }
}

internal final class MapPin: UIView {
    private let label = UILabel(frame: CGRect.zero)
    let index: Int

    init(index: Int) {
        self.index = index
        super.init(frame: CGRect.zero)
        setupHierarchy()
        setupLayout()
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        addSubview(label)
    }

    private func setupLayout() {
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupViews() {
        label.text = "\(index)"
        backgroundColor = UIColor.black
        layer.cornerRadius = 15
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}

internal final class MapAnnotation: NSObject, MKAnnotation {
    let title: String? = nil
    let subtitle: String? = nil
    let coordinate: CLLocationCoordinate2D
    let index: Int

    init(point: DataPoint, index: Int) {
        coordinate = CLLocationCoordinate2D(latitude: point.lat, longitude: point.long)
        self.index = index
        super.init()
    }
}

final class MapView: MKMapView {
    fileprivate var points: [DataPoint] = [] {
        didSet {
            resetMap()
            addOverlayPlots()
            addAnnotations()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        showsUserLocation = true
        delegate = self
    }

    func setNewPoints(points: [DataPoint]) {
        self.points = points
    }

    func zoom(at location: CLLocationCoordinate2D) {
        setCenter(location, animated: true)
    }
}

extension MapView {
    func resetMap() {
        removeAnnotations(annotations)
        removeOverlays(overlays)
    }

    fileprivate func addOverlayPlots() {
        let coordinates = points.map {
            return CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
        }
        let rawPointer = UnsafePointer<CLLocationCoordinate2D>(coordinates)
        let line = MKPolyline(coordinates: rawPointer, count: points.count)
        add(line, level: MKOverlayLevel.aboveRoads)
    }

    fileprivate func addAnnotations() {
        let annotations = points.enumerated().map { index, point in
            return MapAnnotation(point: point, index: index)
        }
        addAnnotations(annotations)
    }
}

extension MapView {
    fileprivate func dequeueOrCreateAnnotation(mapView: MKMapView, annotation: MKAnnotation) -> MKAnnotationView {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        if let annotationView = annotationView {
            return annotationView
        }
        return MKAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
    }

    fileprivate func setupAnnotationView(annotationView: MKAnnotationView, annotation: MapAnnotation) {
        let pinView = MapPin(index: annotation.index)
        let frameAnnotation = CGRect(x: 0, y: 0, width: 30, height: 30)
        annotationView.canShowCallout = false
        annotationView.frame = frameAnnotation
        annotationView.addSubview(pinView)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = UIColor.green
        annotationView.detailCalloutAccessoryView = view
        pinView.frame = frameAnnotation
    }

    fileprivate func setupCalloutView(annotation: MapAnnotation, annotationView: MKAnnotationView) {
        let calloutView = CalloutView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30, height: 230))
        setNeedsLayout()
        layoutIfNeeded()
        calloutView.center = CGPoint(x: annotationView.bounds.size.width / 2, y: -calloutView.bounds.size.height)
        annotationView.addSubview(calloutView)
        self.setCenter(annotation.coordinate, animated: true)
        calloutView.setup()
        calloutView.present(parentView: annotationView)
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.black
            renderer.fillColor = UIColor.white
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        guard let annotation = annotation as? MapAnnotation else {
            return nil
        }
        let annotationView = dequeueOrCreateAnnotation(mapView: mapView, annotation: annotation)
        setupAnnotationView(annotationView: annotationView, annotation: annotation)
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MapAnnotation else {
            return
        }
        setupCalloutView(annotation: annotation, annotationView: view)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for subview in view.subviews {
            if let subview = subview as? CalloutView {
                subview.dismiss(parentView: view)
            }
        }
    }
}
