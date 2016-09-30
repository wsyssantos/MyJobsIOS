//
//  OfferDetailContract.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import Foundation

protocol OfferDetailView : BaseView {
    func offerDetailReceived(_ offer: Offer)
    func errorReceived(_ e:NSError)
}

protocol OfferDetailPresenter : BasePresenter {
    func loadOfferDetail(_ offerDetailLink: String)
}

protocol OfferDetailDelegate {
    func offerAccepted(_ link : String)
}
