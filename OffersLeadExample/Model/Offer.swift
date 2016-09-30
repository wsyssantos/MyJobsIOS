//
//  Offer.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//
import Foundation

class Offer : Event {
    var acceptLink:String!
    var rejectLink:String!
    var state:String!
    
    init(dict:NSDictionary, detail:Bool) {
        super.init()
        if detail {
            initDetail(dict)
        } else {
            initList(dict)
        }
    }
    
    func initDetail(_ dict:NSDictionary) {
        if let distance = dict["distance"] as? NSInteger {
            self.distance = distance;
        }
        if let lead_price = dict["lead_price"] as? NSInteger {
            self.leadPrice = lead_price;
        }
        if let title = dict["title"] as? String {
            self.title = title
        }
        if let _embedded = dict["_embedded"] as? [String: AnyObject] {
            if let info = _embedded["info"]! as? NSArray {
                self.info = NSMutableArray()
                for nfo in info {
                    let inInfo = Info(dict: nfo as! NSDictionary)
                    self.info.add(inInfo)
                }
            }
            if let user = _embedded["user"]! as? NSDictionary {
                self.user = User(dict: user);
            }
            if let address = _embedded["address"]! as? NSDictionary {
                self.address = Address(dict: address);
            }
        }
        if let _links = dict["_links"] as? [String: NSDictionary] {
            let acceptDict = _links["accept"];
            self.acceptLink = acceptDict!["href"] as! String
            let rejectDict = _links["reject"];
            self.rejectLink = rejectDict!["href"] as! String
        }
    }
    
    func initList(_ dict:NSDictionary) {
        if let state = dict["state"] as? String {
            self.state = state;
        }
        if let _embedded = dict["_embedded"] as? [String: AnyObject] {
            if let request = _embedded["request"] as? [String : AnyObject] {
                if let created_at = request["created_at"] as? String {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
                    self.creation = dateFormatter.date(from: created_at)
                }
                if let title = request["title"] as? String {
                    self.title = title
                }
                
                if let reqEmbedded = request["_embedded"] as? [String : AnyObject] {
                    if let user = reqEmbedded["user"]! as? NSDictionary {
                        self.user = User(dict: user);
                    }
                    if let address = reqEmbedded["address"]! as? NSDictionary {
                        self.address = Address(dict: address);
                    }
                }
            }
        }
        if let _links = dict["_links"] as? [String: NSDictionary] {
            let selfDict = _links["self"];
            self.detailLink = selfDict!["href"] as! String
        }
    }
}
