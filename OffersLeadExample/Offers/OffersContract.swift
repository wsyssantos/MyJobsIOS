//
//  OffersContract.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import Foundation

protocol OffersView : BaseView {
    func offerListReceived(_ offerList:NSArray)
    func errorReceived(_ e:NSError)
}

protocol OffersPresenter : BasePresenter {
    func loadOfferList()
}
