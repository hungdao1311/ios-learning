//
//  CustomerTableViewDataSource.swift
//  DemoApp
//
//  Created by Hung Dao on 10/21/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import Foundation
import UIKit

class CustomerTableViewDataSource: NSObject, UITableViewDataSource {
    
    var customerList = [Customer]()
    var pagingInfo: PagingInfo?
    
    init(_ customerList: [Customer], _ pagingInfo: PagingInfo?){
        self.customerList = customerList
        self.pagingInfo = pagingInfo
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pagingInfo = pagingInfo else {
            return 0
        }
        return pagingInfo.totalElements
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CustomerTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomerTableViewCell else {
            fatalError("Dequeued cell is not an instance of CustomerTableViewCell")
        }
        
        let customer = customerList[indexPath.row]
        
        cell.nameLabel.text = "\(customer.firstName) \(customer.lastName)"
        
        return cell
    }
    
    
    
}
