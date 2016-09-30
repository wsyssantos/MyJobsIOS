//
//  OfferDetailContract.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import Foundation

protocol LeadDetailView : BaseView {
    func leadDetailReceived(_ lead: Lead)
    func errorReceived(_ e:NSError)
}

protocol LeadDetailPresenter : BasePresenter {
    func loadLeadDetail(_ leadDetailLink: String)
}
