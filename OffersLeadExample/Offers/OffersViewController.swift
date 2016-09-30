//
//  FirstViewController.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//
import UIKit
import MBProgressHUD

class OffersViewController: UITableViewController, OffersView, OfferDetailDelegate {
    var presenter:OffersPresenter!
    var offerList:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = OffersPresenterImpl(view: self)
        self.presenter.loadOfferList()
        
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Carregando...")
        refreshControl!.addTarget(self, action: #selector(OffersViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    func refresh(_ sender:AnyObject) {
        self.presenter.loadOfferList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func showLoading() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Carregando"
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func errorReceived(_ e: NSError) {
        
    }
    
    func offerListReceived(_ offerList: NSArray) {
        self.offerList = offerList
        self.tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OfferLeadTableViewCell

        let event = offerList[(indexPath as NSIndexPath).row]
        cell.updateView(event as! Event)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController:OfferDetailViewController = segue.destination as! OfferDetailViewController
        viewController.delegate = self
        let index = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
        let selectedOffer = offerList[index!] as! Offer
        viewController.offerDetailLink = selectedOffer.detailLink
    }
    
    func offerAccepted(_ link: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController:LeadDetailViewController = storyBoard.instantiateViewController(withIdentifier: "LeadDetailViewController") as! LeadDetailViewController
        nextViewController.leadDetailLink = link
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }
}

