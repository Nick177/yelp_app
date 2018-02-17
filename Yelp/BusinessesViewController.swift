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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight=120
        
        searchBar.delegate = self
        
        
       /* Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
 */
        loadMoreData()
        /* Example of Yelp search with more search options specified
         */
       /* Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: nil, deals: nil, offset: 0, completion: { (businesses: [Business]!, error: Error!) -> Void in
         self.businesses = businesses
         self.filteredData = businesses
         self.tableView.reloadData()
            
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
        )
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.businesses = searchText.isEmpty ? businesses : businesses.filter { (item: Business) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.name?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
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
        /*Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: nil, deals: nil, offset: 0, completion: { (businesses: [Business]!, error: Error!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
            self.isMoreDataLoading = false
            
        })
        
        */
        
        Business.searchWithTerm(term: "Thai", sort: .distance, categories: nil, deals: nil, offset: self.offset, completion:
        
        //Business.searchWithTerm(term: "Thai", completion:
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
            /*    if (self.offset > 50) {
                    self.offset = 0
                }
 */
            self.isMoreDataLoading = false
            
        }
        )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
