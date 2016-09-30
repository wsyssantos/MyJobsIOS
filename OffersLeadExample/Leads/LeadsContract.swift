//
//  LeadsContract.swift
//  OffersLeadExample
//
//  Created by Wesley on 9/4/16.
//  Copyright © 2016 Wesley. All rights reserved.
//

import Foundation

protocol LeadsView : BaseView {
    func leadsListReceived(_ leadsList:NSArray)
    func errorReceived(_ e:NSError)
}

protocol LeadsPresenter : BasePresenter {
    func loadLeadsList()
}
