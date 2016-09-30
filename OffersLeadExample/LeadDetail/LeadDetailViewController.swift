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

class LeadDetailViewController: UIViewController, LeadDetailView, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var leadDetailLink:String!
    var presenter:LeadDetailPresenter!
    var selectedLead:Lead!
    var locationManager:CLLocationManager!
    var userLocation:CLLocation!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserLocation: UILabel!
    @IBOutlet weak var lblUserDistance: UILabel!
    @IBOutlet weak var lblUserPhone: UILabel!
    @IBOutlet weak var lblUserMail: UILabel!
    @IBOutlet weak var mapUserLocation: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.presenter = LeadDetailPresenterImpl(view: self)
        if leadDetailLink != nil {
            self.presenter.loadLeadDetail(leadDetailLink)
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
        if userLocation == nil && self.selectedLead != nil {
            userLocation = locations[0]
            updateDistanceText()
        }
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
    
    func leadDetailReceived(_ lead: Lead) {
        self.selectedLead = lead
        updateView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        updateMapView()
    }
    
    func updateView() {
        lblUserName.text = self.selectedLead.user.name
        lblUserLocation.text = "\(self.selectedLead.address.neighborhood!) - \(self.selectedLead.address.city!)"
        lblUserPhone.text = self.selectedLead.user.phones.transformInString()
        lblUserMail.text = self.selectedLead.user.email
        self.navigationItem.title = self.selectedLead.title
    }
    
    func updateDistanceText() {
        let loc:CLLocation = CLLocation(latitude: self.selectedLead.address.geolocation.latitude, longitude: self.selectedLead.address.geolocation.longitude)
        let meters:CLLocationDistance = (userLocation.distance(from: loc))/1000
        let meterFormated = NSString(format: "%.2f", meters)
        lblUserDistance.text = "a \(meterFormated) Km de você"
        lblUserDistance.isHidden = false
    }
    
    func updateMapView() {
        let center = CLLocationCoordinate2D(latitude: self.selectedLead.address.geolocation.latitude, longitude: self.selectedLead.address.geolocation.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapUserLocation.setRegion(region, animated: true)
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = self.selectedLead.address.geolocation
        self.mapUserLocation.addAnnotation(dropPin)
    }
    
    func errorReceived(_ e: NSError) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedLead.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
      
        let info = selectedLead.info.object(at: (indexPath as NSIndexPath).row) as! Info
        cell.updateView(info)
        
        return cell
    }
    
    @IBAction func btnCallPhone(_ sender: AnyObject) {
        if let url = URL(string: "tel://\(replacePhone(self.selectedLead.user.phones[0] as! String))") {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func btnCallWhatsapp(_ sender: AnyObject) {
        let urlString = "Olá!"
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let url  = URL(string: "whatsapp://send?text=\(urlStringEncoded!)")
        
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        }
    }
    
    func replacePhone(_ phone:String) -> String {
        var ret:String = phone
        ret = phone.replacingOccurrences(of: "(", with: "")
        ret = ret.replacingOccurrences(of: ")", with: "")
        ret = ret.replacingOccurrences(of: "-", with: "")
        ret = ret.replacingOccurrences(of: " ", with: "")
        return ret
    }
}
