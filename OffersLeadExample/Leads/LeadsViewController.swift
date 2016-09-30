//
//  SecondViewController.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import UIKit
import MBProgressHUD

class LeadsViewController: UITableViewController, LeadsView {

    var presenter:LeadsPresenter!
    var leadList:NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = LeadsPresenterImpl(view: self)
        self.presenter.loadLeadsList()
        
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
        self.presenter.loadLeadsList()
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
    
    func leadsListReceived(_ leadsList: NSArray) {
        self.leadList = leadsList
        self.tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    func errorReceived(_ e: NSError) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leadList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OfferLeadTableViewCell
        
        let event = leadList[(indexPath as NSIndexPath).row]
        cell.updateView(event as! Event)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController:LeadDetailViewController = segue.destination as! LeadDetailViewController
        let index = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
        let selectedLead = leadList[index!] as! Lead
        viewController.leadDetailLink = selectedLead.detailLink
    }
}

