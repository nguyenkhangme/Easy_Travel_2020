//
//  MainSearchViewController.swift
//  GoogleLogin
//
//  Created by user on 6/17/20.
//  Copyright © 2020 vinova. All rights reserved.
//
import UIKit
import RealmSwift
import Realm

import CoreLocation


class MainSearchViewController: UITableViewController {
    
    var notClicked = false
    var isDatabaseHaveThatQueryControl = false
    var placemarks = [PlaceMarkForAllMap]()
    
    var category: GoogleCategory = .other
    var realm = try! Realm()
    var test = ["ttt"]
    let sections = ["Categories","Recent Search"]
    let categories : [GoogleCategory] = [.bus_station,.restaurant,.cafe,.library]
    let imageForCollectionView = ["icons8-bus-100","icons8-restaurant-100","icons8-cafe-100","icons8-library-100"]
    
 
    //MARK: Delegate
    weak var searchBarSearchButtonClickedDelegate: searchBarSearchButtonClicked? = nil
    
    weak var updateSearchResultDelegate: updateSearchResultDelegate? = nil
    
    // MARK: - Properties
    
    /// Search controller to help us with filtering.
    var searchController: CustomSearchController!
       
    lazy var searchTable = SearchTableViewController(nibName: nil, bundle: nil)

    
    fileprivate var recent: Results<RecentQuery> { //
        get {
            return realm.objects(RecentQuery.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        searchTable.resultClickedDelegate = self


        
        self.navigationItem.setHidesBackButton(true, animated: true)

        
        
        searchController = CustomSearchController(searchResultsController: searchTable)
        searchController.searchResultsUpdater = searchTable
        searchController.searchBar.autocapitalizationType = .none
           //searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Enter a search term", comment: "")
        searchController.searchBar.returnKeyType = .done

        
          
        
        
               
           // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
           // Monitor when the search controller is presented and dismissed.
          // searchController.delegate = self
           // Monitor when the search button is tapped, and start/end editing.
           searchController.searchBar.delegate = self
           
           /** Specify that this view controller determines how the search controller is presented.
               The search controller should be presented modally and match the physical size of this view controller.
           */
        
         

        searchController.searchBar.barTintColor = UIColor.rgb(r: 25, g: 51, b: 102)
        searchController.searchBar.tintColor = UIColor.rgb(r: 0, g: 0, b: 0)
                      
              searchController.searchBar.placeholder = "Search for places"
    
               searchController.searchBar.resignFirstResponder()
        
       
         
        // Place the search bar in the navigation bar.
        navigationItem.titleView = searchController.searchBar
      
        let smallSquare = CGSize(width: 12, height: 31)
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: .zero, size: smallSquare)
        button.setBackgroundImage(UIImage(named: "icons8-back-30"), for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
           definesPresentationContext = true
   
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        
    }
    
    func writeDatabase(){
        var placeMarkRealmTemps = [POI]()
                //placeMarkRealmTemps.reserveCapacity(PlaceMarkForAllMap.shared.count)
                //placeMarkRealmTemps.reserveCapacity(20)
               
                let placeMarkRealmTemp = POI()
                let placeMarkRealmTemp1 = POI()
                let placeMarkRealmTemp2 = POI()
                let placeMarkRealmTemp3 = POI()
                let placeMarkRealmTemp4 = POI()
                let placeMarkRealmTemp5 = POI()
                let placeMarkRealmTemp6 = POI()
                let placeMarkRealmTemp7 = POI()
                let placeMarkRealmTemp8 = POI()
                let placeMarkRealmTemp9 = POI()
                let placeMarkRealmTemp10 = POI()
                let placeMarkRealmTemp11 = POI()
                let placeMarkRealmTemp12 = POI()
                let placeMarkRealmTemp13 = POI()
                let placeMarkRealmTemp14 = POI()
                let placeMarkRealmTemp15 = POI()
                let placeMarkRealmTemp16 = POI()
                let placeMarkRealmTemp17 = POI()
                let placeMarkRealmTemp18 = POI()
                let placeMarkRealmTemp19 = POI()
                
                   
                placeMarkRealmTemps.append(placeMarkRealmTemp)
                 placeMarkRealmTemps.append(placeMarkRealmTemp1)
                 placeMarkRealmTemps.append(placeMarkRealmTemp2)
                 placeMarkRealmTemps.append(placeMarkRealmTemp3)
                 placeMarkRealmTemps.append(placeMarkRealmTemp4)
                 placeMarkRealmTemps.append(placeMarkRealmTemp5)
                 placeMarkRealmTemps.append(placeMarkRealmTemp6)
                 placeMarkRealmTemps.append(placeMarkRealmTemp7)
                 placeMarkRealmTemps.append(placeMarkRealmTemp8)
                 placeMarkRealmTemps.append(placeMarkRealmTemp9)
                 placeMarkRealmTemps.append(placeMarkRealmTemp10)
                 placeMarkRealmTemps.append(placeMarkRealmTemp11)
                 placeMarkRealmTemps.append(placeMarkRealmTemp12)
                 placeMarkRealmTemps.append(placeMarkRealmTemp13)
                 placeMarkRealmTemps.append(placeMarkRealmTemp14)
                 placeMarkRealmTemps.append(placeMarkRealmTemp15)
                 placeMarkRealmTemps.append(placeMarkRealmTemp16)
                placeMarkRealmTemps.append(placeMarkRealmTemp17)
                 placeMarkRealmTemps.append(placeMarkRealmTemp18)
                 placeMarkRealmTemps.append(placeMarkRealmTemp19)
                
                let POIControlTemp = POIControl()
//        let compoundKey = "\(POIControlTemp.category)-\(POIControlTemp.longitude)-\(POIControlTemp.latitude)"
//        let POIControls = realm.objects(POIControl.self).filter("compoundKey == '\(compoundKey)'")
//        if(POIControls.count == 0){
//            try! realm.write{
//                POIControlTemp.setup(query: self.category, latitude: searchTable.mapsViewModel.userLocation.latitude, longitude: searchTable.mapsViewModel.userLocation.longitude)
//
//                realm.add(POIControlTemp)
//            }
//        }else{
//            try! realm.write{
//                POIControlTemp.setup(query: self.category, latitude: searchTable.mapsViewModel.userLocation.latitude, longitude: searchTable.mapsViewModel.userLocation.longitude)
//
//                //realm.add(POIControlTemp)
//            }
//        }
        
        try! realm.write{
            POIControlTemp.setup(query: self.category, latitude: searchTable.mapsViewModel.userLocation.latitude, longitude: searchTable.mapsViewModel.userLocation.longitude)
            
            realm.add(POIControlTemp, update: .modified)
        }
                
                
                for i in PlaceMarkForAllMap.shared.indices {
                    try! realm.write {
                        print("Write REalm: \(i)")
                        let placemarks = realm.objects(POI.self).filter("place_id == '\(PlaceMarkForAllMap.shared[i].place_id ?? "")'")
                        if(placemarks.count == 0){
                            placeMarkRealmTemps[i].setup(Name: PlaceMarkForAllMap.shared[i].Name, placeName: PlaceMarkForAllMap.shared[i].placeName, latitude: PlaceMarkForAllMap.shared[i].latitude!, longitude: PlaceMarkForAllMap.shared[i].longitude!, placeId: PlaceMarkForAllMap.shared[i].place_id)
                            
                            //placeMarkRealmTemps.append(placeMarkRealmTemp)
                            
                            realm.add(placeMarkRealmTemps[i], update: .modified)
                            //realm.add(placeMarkRealmTemps[i])
                            POIControlTemp.addPOI(POI: placeMarkRealmTemps[i])
                            placeMarkRealmTemps[i].addPOIControl(POIControl: POIControlTemp)
                        }else{
                            POIControlTemp.addPOI(POI: placemarks[0])
                            placemarks[0].addPOIControl(POIControl: POIControlTemp)
                        }
                        
                        
        //                print("placemarks count: \(placemarks.count)")
        //                for j in placemarks.indices {
        //                    print("\(j): \(placemarks[j].placeName)")
        //                    placemarks[j].addQueryControl(queryControl: queryControlTemp)
        //                }
                      
                        
                    }
                               
                }
    }

//MARK: fetchPOISDatabase
    func fetchPOISDatabase(category: GoogleCategory) {
                  
        var querySearch = ""
        
        switch category {
        case .bus_station:
            querySearch = "bus_station"
        case .cafe:
            querySearch = "cafe"
        case .car_repair:
            querySearch = "car_repair"
        case .library:
            querySearch = "library"
        case .restaurant:
            querySearch = "restaurant"
        case .other:
            querySearch = ""
        }
    
        //MARK: Handle Realm Is have data?
                 
        let placemarks1 = realm.objects(POIControl.self).filter("category == '\(querySearch)'")
        if(placemarks1.count == 0){
            print("If data not in Realm database yet\n")
                  
            searchTable.queryService._queryServiceAccess?.fetchPOIs(query: category, latitude: searchTable.mapsViewModel.userLocation.latitude, longitude: searchTable.mapsViewModel.userLocation.longitude)
            
            searchTable.queryService._queryServiceAccess?.parseDataDelegate = self
            
            
                 
            self.navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
                             
                              
                          
        }else{
            var count = 0
            var count1 = 0
            print("Realm Database!!!\n")
            PlaceMarkForAllMap.shared.removeAll()
            for i in placemarks1.indices {
                print("placemarks1 \(i): \(placemarks1[i].query)")
 
                if(CLLocationCoordinate2D(latitude: placemarks1[i].latitude, longitude: placemarks1[i].longitude).distance(to: searchTable.mapsViewModel.userLocation) <= 2*10000){
                        count += 1
                    
                    if(CLLocationCoordinate2D(latitude: placemarks1[i].latitude, longitude: placemarks1[i].longitude) == searchTable.mapsViewModel.userLocation){
                        count1 += 1
                        isDatabaseHaveThatQueryControl = true
                    }
                        // MARK: Read all Placemark
                        var tempp1 = PlaceMarkForAllMap()
                        for j in placemarks1[i].placemarks.indices {
                            print("\(j)")
                                
                            tempp1.Name = placemarks1[i].placemarks[j].Name
                            tempp1.placeName = placemarks1[i].placemarks[j].placeName
                            tempp1.longitude = placemarks1[i].placemarks[j].longitude
                            tempp1.latitude = placemarks1[i].placemarks[j].latitude
                            //MARK: Kha nang cao gay ra trung lap
                            //Giai quyet: one to many. Chi doc vong tron cha. 1 cha nhieu con, 1 con 1 cha.
                            //Se do trung lap hon.
                            PlaceMarkForAllMap.shared.append(tempp1)
                                  
                        }
                              
                              //MARK: End Read All
                }
            }
            
            if count1 == 0 {
                isDatabaseHaveThatQueryControl = false
            }else{
                isDatabaseHaveThatQueryControl = true
            }
            if(count > 0){
                print("Ok data in databse and near user!")
                
                if(isDatabaseHaveThatQueryControl == false){
                                           
                print("isDatabaseHaveThatQueryControl in read database: \(isDatabaseHaveThatQueryControl)")
                for i in PlaceMarkForAllMap.shared.indices{
                    placemarks.append(PlaceMarkForAllMap.shared[i])
                }
                searchTable.queryService._queryServiceAccess?.fetchPOIs(query: category, latitude: searchTable.mapsViewModel.userLocation.latitude, longitude: searchTable.mapsViewModel.userLocation.longitude)
                
                    notClicked = true
                searchTable.queryService._queryServiceAccess?.parseDataDelegate = self
                //self.queryService.getData(query: querySearch, latitude:mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude)
                print("HIHJJKJKJKJKJKKJKJKJK")
                PlaceMarkForAllMap.shared.removeAll()
                for i in placemarks.indices{
                        PlaceMarkForAllMap.shared.append(placemarks[i])
                }
                
               
              searchBarSearchButtonClickedDelegate?.Clicked(category: category)
                
                self.navigationController?.popViewController(animated: true)
                 dismiss(animated: true, completion: nil)
                        
                }else{
                    print("isDatabaseHaveThatQueryControl in read database: \(isDatabaseHaveThatQueryControl)")
                   
                    searchTable.queryService._queryServiceAccess?.parseDataDelegate = self
                    self.navigationController?.popViewController(animated: true)
                    dismiss(animated: true, completion: nil)
                }
            }else {
                print("Database have queryControl hold that query but not near user!!!")
                searchTable.queryService._queryServiceAccess?.fetchPOIs(query: category, latitude: searchTable.mapsViewModel.userLocation.latitude, longitude: searchTable.mapsViewModel.userLocation.longitude)
                           
                searchTable.queryService._queryServiceAccess?.parseDataDelegate = self
                
                                
                self.navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }
                      
                      
        }
         
    }
    
    @objc func back(){
    
         self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       switch (section) {
            case 0:
                return "Categories"
            case 1:
                return "Recent"
            default:
                return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let recent = realm.objects(RecentQuery.self).sorted(byKeyPath: "timestamp", ascending: false)
            .distinct(by: ["query"])
            .filter("user == '\(String(describing: User.sharedInstance.email))'")
        switch (section) {
            case 0:
                return 1
            case 1:
                return recent.count
            default:
                return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let identifier = "searchInterfaceCell"

        let recents = realm.objects(RecentQuery.self).sorted(byKeyPath: "timestamp", ascending: false)
            .distinct(by: ["query"])
            .filter("user == '\(String(describing: User.sharedInstance.email))'")
    
       
        
        var myCell: SearchInterfaceTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchInterfaceTableViewCell

          if myCell == nil {
            tableView.register(UINib(nibName: "SearchInterfaceTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            myCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchInterfaceTableViewCell
            }
        switch indexPath.section {
        case 0:
            break
        case 1:
            
            if recents.count <= 12 {
                myCell.textLabel?.text = recents[indexPath.row].query

                myCell.detailTextLabel?.text = recents[indexPath.row].query
            }else{
                if indexPath.row <= 11{
                    myCell.textLabel?.text = recents[indexPath.row].query

                    myCell.detailTextLabel?.text = recents[indexPath.row].query
                }
            }
            
            
            // Configure the cell...
            
        default:
            break
        }
        
        return myCell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            guard let tableViewCell = cell as? SearchInterfaceTableViewCell else { return }

            tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        case 1: break
            
        default: break
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        
    
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            print("didSelectRecent")
            searchTable.updateSearchResult(searchBarText: recent[indexPath.row].query)
            //searchController.searchBar.value(forKey: recent[indexPath.row].query)
            //present(searchTable, animated: true, completion: nil)
            self.navigationController?.pushViewController(searchTable, animated: true)
            //self.updateSearchResultDelegate?.updateSearchResult(searchBarText: recent[indexPath.row].query)
            break
        default:
            break
        }
    }



}


extension MainSearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBarSearchButtonClickedDelegate?.Clicked(category: .other)
        self.navigationController?.popViewController(animated: true)
        searchController.dismiss(animated: true, completion: nil)
    }
}

extension MainSearchViewController: ResultClicked {
    var isClicked: Bool {
        get {
            return false
        }
        
        set {
             self.navigationController?.popViewController(animated: true)
        
        }
        
    }
    

}

extension MainSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "categoryCollectionViewCell"

        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        let myCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell
        
//        var myCollectionCell: CategoryCollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell
//
//        if myCollectionCell == nil {
//            collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
//            myCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell
//            }
        
        
        myCollectionCell?.image.image = UIImage(named: imageForCollectionView[indexPath.item])


        return myCollectionCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        category = categories[indexPath.item]
        fetchPOISDatabase(category: category)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {

        return imageForCollectionView.count
    }

 
}

extension MainSearchViewController : ParseDataFromSearch {
    func parseData(data: [PlaceMarkForAllMap]) {
        writeDatabase()
        print("PAsse Data!!!")
        if notClicked == false{
              searchBarSearchButtonClickedDelegate?.Clicked(category: category)
        
        }else{
            notClicked = false
        }
    }
}


