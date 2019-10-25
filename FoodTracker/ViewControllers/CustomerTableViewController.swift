//
//  CustomerTableViewController.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/15/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import UIKit

class CustomerTableViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var customerList = [Customer]()
    var pagingInfo: PagingInfo?
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: UITableViewDataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestCustomer()
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.placeholder = "Search Customer"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CustomerDetailsViewController {
            let selectedRow = tableView.indexPathForSelectedRow!.row
            vc.customer = customerList[selectedRow]
        }
    }
    
    func searchCustomer(_ searchText: String) {
        requestCustomer(pattern: searchText)
        //
    }
    
    func requestCustomer(pattern: String = "") {
        let url = URL(string: "https://services.qa.4tellus.net/recipients/search?projection=recipientFullNameProjection&sort=firstName,lastName")!
        DataService(url:url)
            .setMethod(method: .post)
            .setBody(body: JsonBody(["pattern" : pattern]))
            .setAccessToken(token: Settings.shared.accessToken!)
            .getObject() { [weak self](result: CustomerResponse?, error) in
                guard let self = self else {
                    return
                }  
                if let error = error {
                    let status = ErrorResponse(exception: error)
                    let alertMessage: String
                    if (status.isUnauthorized) {
                        alertMessage = "Invalid token"
                    } else {
                        alertMessage = status.errorDescription
                    }
                    let alert = UIAlertController(title: "Error", message: "\(alertMessage) \n Showing cached result", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    do {
                        self.customerList = try DataContext.shared.customerCaching.load(queryString: pattern)
                        self.dataSource = CustomerTableViewDataSource(self.customerList)
                        self.tableView.dataSource = self.dataSource
                        self.tableView.reloadData()
                    } catch {
                        let cachingAlert = UIAlertController(title: "Cache error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        cachingAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(cachingAlert, animated: true, completion: nil)
                    }
                }
                if let response = result {
                    self.customerList = response.data
                    self.pagingInfo = response.pagingInfo
                    self.dataSource = CustomerTableViewDataSource(self.customerList, self.pagingInfo)
                    self.tableView.dataSource = self.dataSource
                    self.tableView.reloadData()
                    try! DataContext.shared.customerCaching.save(data: response.data)
                }
        }
    }
}

extension CustomerTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        searchCustomer(searchText)
    }
}


