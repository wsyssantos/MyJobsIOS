//
//  OfferDetailViewController.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit
import CoreLocation

class OfferDetailViewController: UIViewController, OfferDetailView, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var offerDetailLink:String!
    var presenter:OfferDetailPresenter!
    var selectedOffer:Offer!
    var userLocation:CLLocation!
    var locationManager:CLLocationManager!
    var delegate:OfferDetailDelegate!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblUserDistance: UILabel!
    @IBOutlet weak var mapUserLocation: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.presenter = OfferDetailPresenterImpl(view: self)
        if offerDetailLink != nil {
            self.presenter.loadOfferDetail(offerDetailLink)
        }
        self.tabBarController?.tabBar.isHidden = true
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        lblUserDistance.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if userLocation == nil && self.selectedOffer != nil {
            userLocation = locations[0]
            updateDistanceText()
        }
    }
    
    func updateDistanceText() {
        let loc:CLLocation = CLLocation(latitude: self.selectedOffer.address.geolocation.latitude, longitude: self.selectedOffer.address.geolocation.longitude)
        let meters:CLLocationDistance = (userLocation.distance(from: loc))/1000
        let meterFormated = NSString(format: "%.2f", meters)
        lblUserDistance.text = "a \(meterFormated) Km de você"
        lblUserDistance.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoading() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Carregando"
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func offerDetailReceived(_ offer: Offer) {
        self.selectedOffer = offer
        updateView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        updateMapView()
    }
    
    func updateMapView() {
        let center = CLLocationCoordinate2D(latitude: self.selectedOffer.address.geolocation.latitude, longitude: self.selectedOffer.address.geolocation.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapUserLocation.setRegion(region, animated: true)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = self.selectedOffer.address.geolocation
        self.mapUserLocation.addAnnotation(dropPin)
    }
    
    func errorReceived(_ e: NSError) {
        
    }
    
    func updateView() {
        lblUserName.text = self.selectedOffer.user.name
        lblUserLocation.text = "\(self.selectedOffer.address.neighborhood!) - \(self.selectedOffer.address.city!)"
        self.navigationItem.title = self.selectedOffer.title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedOffer.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
        
        let info = selectedOffer.info.object(at: (indexPath as NSIndexPath).row) as! Info
        cell.updateView(info)
        
        return cell
    }
    
    @IBAction func refuseOffer(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptOffer(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
        delegate.offerAccepted(selectedOffer.acceptLink)
    }
}
