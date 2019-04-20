//
//  RestaurantSearchViewController.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import MapKit
import Reachability
import UIKit

/// レストラン検索画面
final class RestaurantSearchViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView! {
        didSet {
            detailView.isHidden = true
        }
    }
    @IBOutlet private weak var shopNameLabel: UILabel!
    @IBOutlet private weak var openingLabel: UILabel!
    @IBOutlet private weak var accessLabel: UILabel!
    
    private var genre: Genre?
    private var shops = [Shop]()
    private var selectedShop: Shop?
    
    lazy var presenter: RestaurantSearchPresenter = RestaurantSearchPresenterImpl(view: self)
    private let locationService = LocationService.shared
    private var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.requestGenre()
    }
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        hideNavigationBarBackTitle()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationService.tearDownLocationManager()
    }
}

// MARK: - Actions
extension RestaurantSearchViewController {
    
    @IBAction func didTapSearch(_ sender: UIButton) {
        guard let genre = self.genre else {
            return
        }
        presenter.requestGourmetSearch(
            genre: genre,
            currentLat: mapView.userLocation.coordinate.latitude,
            currentLng: mapView.userLocation.coordinate.longitude
        )
    }
    
    @IBAction func didTapToCurrent(_ sender: UIButton) {
        var region = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        region.center = mapView.userLocation.coordinate
        
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func didTapShopName(_ sender: UITapGestureRecognizer) {
        guard let urlString = selectedShop?.urls.pc else {
            return
        }
        let name = selectedShop?.name ?? ""
        let vc = RestaurantDetailViewController.instance(name: name, baseURL: urlString)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RestaurantSearchViewController {
    private func setup() {
        setupReachability()
        setupLocationService()
        setupMapView()
    }
    
    private func setupReachability() {
        reachability = Reachability()
        reachability?.whenUnreachable = { [weak self] _ in
            self?.searchButton.isEnabled = false
        }
        
        reachability?.whenReachable = { [weak self] _ in
            self?.searchButton.isEnabled = true
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print(debug: "Unable to start notifier")
        }
    }
    
    private func setupLocationService() {
        LocationService.lastUpdatedDate = nil
        locationService.delegate = self
        locationService.setupLocationManager()
    }
    
    private func setupMapView() {
        var region = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
    }
}

// MARK: - RestaurantSearchView
extension RestaurantSearchViewController: RestaurantSearchView {
    
    func didFinishGettingShops(shops: [Shop]) {
        
        self.shops = shops
        setShopLocation()
        
        if shops.isEmpty {
            showAlert()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "",
                                      message: NSLocalizedString("NO_STORE_MSG", comment: ""),
                                      preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func setShopLocation() {
        detailView.isHidden = true
        selectedShop = nil
        
        mapView.removeAnnotations(mapView.annotations)
        
        for shop in self.shops {
            
            guard let lat = Double(shop.lat), let lng = Double(shop.lng) else {
                continue
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
            annotation.title = shop.name
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - GenreListDelegate
extension RestaurantSearchViewController: GenreListDelegate {
    func selected(genre: Genre) {
        print(debug: "\(genre)")
        self.genre = genre
        searchField.text = genre.name
    }
}

// MARK: - LocationServiceDelegate
extension RestaurantSearchViewController: LocationServiceDelegate {
    
    /// 位置情報が許可されていない場合のアラート表示
    func showAppSettingAlert() {
        self.openAppSettingAlert()
    }
    
    /// 位置情報更新
    func update(coordinate: CLLocationCoordinate2D) {
        print(debug: "\(coordinate)")
        mapView.setCenter(coordinate, animated: false)
        
        mapView.removeOverlays(mapView.overlays)
        let circle = MKCircle(center: mapView.centerCoordinate, radius: 500)
        mapView.addOverlay(circle)
    }
}

// MARK: - UITextFieldDelegate
extension RestaurantSearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = GenreSelectViewController.instance(delegate: self)
        navigationController?.pushViewController(vc, animated: true)
        return false
    }
}

// MARK: - MKMapViewDelegate
extension RestaurantSearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let title = view.annotation?.title ?? ""
        selectedShop = shops.filter{ $0.name == title }.first
        
        guard let selectedShop = selectedShop else {
            detailView.isHidden = true
            return
        }
        setShopDetail(shop: selectedShop)
        detailView.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        detailView.isHidden = true
        selectedShop = nil
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        let annotation = mapView.selectedAnnotations.first
        mapView.deselectAnnotation(annotation, animated: false)
        detailView.isHidden = true
        selectedShop = nil
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation === mapView.userLocation {
            (annotation as? MKUserLocation)?.title = nil
            return nil
        }
        return nil
    }
    
    private func setShopDetail(shop: Shop) {
        shopNameLabel.text = shop.name
        // TODO: - 徒歩の時間をセットする
        accessLabel.text = ""
        openingLabel.text = shop.mobileAccess
    }
}
