//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var businesses: [Business]! = []
    //var filteredData: [Business]!
    
    var isMoreDataLoading = false
    
    var offset = 0
    
    var searchTerm = "Thai"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight=120
        
        searchBar.delegate = self
        
        loadMoreData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let business = businesses[indexPath.row]
            let mapViewController = segue.destination as! MapViewController
            mapViewController.business = business
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.businesses != nil {
            return self.businesses!.count
        }else{
            return 0
        }
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
        loadNewData()
        //tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = self.businesses[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollViewOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
        
    }
    
    func loadMoreData() {
        Business.searchWithTerm(term: self.searchTerm, sort: .distance, categories: nil, deals: nil, offset: self.offset, completion:
            { (businesses: [Business]?, error: Error?) -> Void in
            
            if let businesses = businesses {
                //self.businesses = businesses
                self.businesses = self.businesses + businesses
                self.tableView.reloadData()
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            self.offset += 5
            
            self.isMoreDataLoading = false
            
        }
        )
    }
    
    
    func loadNewData() {
        Business.searchWithTerm(term: self.searchTerm, sort: .distance, categories: nil, deals: nil, offset: self.offset, completion:
            { (businesses: [Business]?, error: Error?) -> Void in
                
                if let businesses = businesses {
                    //self.businesses = businesses
                    self.businesses = businesses
                    self.tableView.reloadData()
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
                
                self.isMoreDataLoading = false
                
        }
        )
    }

    
    
    
    
}
