//
//  LocationSearchTableViewController.swift
//  mapApp
//
//  Created by Vinova on 4/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit
import RealmSwift

import CoreLocation

//Recent: tung user khac nhau

class SearchTableViewController: UITableViewController {
    
    var isDatabaseHaveThatQueryControl = false
    var placemarks = [PlaceMarkForAllMap]()
    
   // var modelAccess: ViewModel.Type
    lazy var queryService = MainQueryService(queryServiceAccess: .MapBox)
    //Is this make a memory cycle? No
    var mapsViewModel = MapsViewModel(modelAccess: .MapBox)
    
    var querySearch: String = ""
    
    weak var resultClickedDelegate: ResultClicked? = nil
    
    //Realm
//    lazy var realm: Realm = {
//        return try! Realm()
//    }()
   var realm = try! Realm() //
    
//    fileprivate var placemarks: Results<PlaceMarkRealm> { //
//        get {
//            return realm.objects(PlaceMarkRealm.self)
//        }
//    }
    //End Realm
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
    print("SyncUser.current: \(SyncUser.current)")
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
           //self.realm = try! Realm(configuration: config!)
            super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         self.queryService._queryServiceAccess?.parseDataDelegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       // self.tableView.register(SearchTableViewCellTableViewCell.self, forCellReuseIdentifier: "searchCell")
        mapsViewModels.removeAll()
        configureActivityIndicator()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
       
        
    }
        
    func setQueryService(queryService: MainQueryService){
        self.queryService = queryService
    }
    
    func setMapsViewModel(mapsViewModel: MapsViewModel){
        self.mapsViewModel = mapsViewModel

    }

    
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    
    //MARK: Change this from PlaceMarkForAllMap to MapsViewModel
    //Change in: ParseDataFromSearch, reuse cell, number of rows
    //var matchingItems : [PlaceMarkForAllMap] = []
    var mapsViewModels = [MapsViewModel]()
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return matchingItems.count
        return mapsViewModels.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let identifier = "searchCell"

        var myCell: SearchTableViewCellTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableViewCellTableViewCell

          if myCell == nil {
            tableView.register(UINib(nibName: "SearchTableViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            myCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableViewCellTableViewCell
            }
        if(mapsViewModels.count>0){
            
            if indexPath.row < mapsViewModels.count {
                let mapsViewModel = mapsViewModels[indexPath.row]
                myCell.mapsViewModel = mapsViewModel
            }else{
                
            }
        }

        
        return myCell
    }
    
    //MARK: didSelectRowAt
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //API
        //let selectedItem = matchingItems
        //handleMapSearchDelegate?.addAnnotationFromSearch(placeMarks: selectedItem, row: indexPath.row)
        
        let selectedItem = mapsViewModels
        handleMapSearchDelegate?.parseDataFromSearch(viewModel: selectedItem, row: indexPath.row)
        
        resultClickedDelegate?.isClicked = true
        
       // self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    

        //MARK: - Declare and configureActivityIndicator
        let activityIndicator = UIActivityIndicatorView()
        
        func configureActivityIndicator(){
            activityIndicator.style = UIActivityIndicatorView.Style.medium

            activityIndicator.center = self.view.center

            activityIndicator.hidesWhenStopped = true

            self.view.addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    //        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    //        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        }

}

extension SearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchBarText = searchController.searchBar.text{
        if(searchBarText != ""){
            
            updateSearchResult(searchBarText: searchBarText)
        }
    }
        
        
        
        // MARK: Uncomment this if want to use Closures instead of Delegate (Only MapBox)
//        if let placeMarkx = self.queryService._queryServiceAccess?.fetchData1(query: searchController.searchBar.text ?? "", latitude: mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude, completion: { [weak self] result in
//           var temp = MapsViewModel(modelAccess: .Google)
//            self?.mapsViewModels = result.map({ return temp.setMapsModel(mapsModelAccess: $0)})
//
//                self?.tableView.reloadData()
//                self?.activityIndicator.stopAnimating()
//
//
//        }) {
//
//        } else{
//            return
//        }
        

      
    }

}

extension SearchTableViewController: updateSearchResultDelegate{
    func updateSearchResult(searchBarText: String) {
                
                 self.querySearch = searchBarText
                
                let queryRecent = RecentQuery()
                
                 try! realm.write{
                    queryRecent.setup(query: querySearch, user: """
                        \(String(describing: User.sharedInstance.email))
                        """)
                    realm.add(queryRecent)
                    
                }
            
               
                activityIndicator.startAnimating()
                
               
                
                //MARK: Handle Realm Is have data?
                print("111 \(mapsViewModel.userLocation.longitude)")
     
               
            
                
               // let query = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "compoundKey = %@",primaryKey)])

                //MSSQL:
                //Pseudo code
                ///CREATE FUNCTION fGetIxy(@a Double, @b double)
                ///RETURNS [QueryControl]
                ///DECLARE @IxyLong Double
                ///DECLARE @IxyLat Double
                ///DECALRE @IxyS [QueryControl]
                ///SELECT @IxyLong = Ixy.long, @IxyLat = Ixy.lat, Ixy.r
                ///FROM QueryControl Ixy
                ///WHERE (Ixy.long - a) ^ 2 - (Ixy.lat - b) ^2 <= 4 * 10000 ^2
                ///
                ///
                
                //http://www.movable-type.co.uk/scripts/latlong.html
                //http://www.geomidpoint.com/destination/calculation.html
                //https://stackoverflow.com/questions/26490313/calculate-lat-long-coords-a-specific-distance-away-from-another-pair-of-lat-long
                //2 way:  1. (x-a)^2+(y-b)^2 <= 4R^2: (I(a,b)) in (Iu(x,y),2Rmax). We need to calculate a lot when use this because a,b,x,y is CLLocation degree but R is meters.
                //2. I.distance(from: Iu) <= 2Rmax
              //  let compareR: Double = 4 * 1000 * 1000 / 111.2 / 111.2
        //Neu de contains se bi loi 'Index 1 is out of bounds (must be less than 1)' Tai sao?
        //Loi o 2 dong code duoi
        //for j in placemarks[i].placemarks.indices {
        //print("\(j)")
        
                let placemarks1 = realm.objects(queryControl.self).filter("query == '\(querySearch)'")
                if(placemarks1.count == 0){
                    print("If data not in Realm database yet\n")
                
                            
                    self.queryService.getData(query: querySearch, latitude:mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude)
                           
                            
                        
                }else{
                    var count = 0
                    var count1 = 0
                    
                    print("Realm Database!!!\n")
                    PlaceMarkForAllMap.shared.removeAll()
                    for i in placemarks1.indices {
                        print("placemarks1 \(i): \(placemarks1[i].query)")
    //                    try! realm.write{
    //                    placemarks1[i].calculateCompare(a: mapsViewModel.userLocation.latitude, b: mapsViewModel.userLocation.longitude)
    //                    }
                        if(CLLocationCoordinate2D(latitude: placemarks1[i].latitude, longitude: placemarks1[i].longitude).distance(to: mapsViewModel.userLocation) <= 2*10000){
                            
                            count += 1
                            
                            if(CLLocationCoordinate2D(latitude: placemarks1[i].latitude, longitude: placemarks1[i].longitude) == mapsViewModel.userLocation){
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
                                //Link to itself.
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
                            self.queryService.getData(query: querySearch, latitude:mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude)
                            print("HIHJJKJKJKJKJKKJKJKJK")
                            PlaceMarkForAllMap.shared.removeAll()
                            for i in placemarks.indices{
                                PlaceMarkForAllMap.shared.append(placemarks[i])
                            }
                            
                            var temp = MapsViewModel(modelAccess: .Google)
                            mapsViewModels =  PlaceMarkForAllMap.shared.map({ return temp.setMapsModel(mapsModelAccess: $0)})
                            
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }else{
                            print("isDatabaseHaveThatQueryControl in read database: \(isDatabaseHaveThatQueryControl)")
                            var temp = MapsViewModel(modelAccess: .Google)
                            mapsViewModels = PlaceMarkForAllMap.shared.map({ return temp.setMapsModel(mapsModelAccess: $0)})
                            
                            self.tableView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                       
                        
                    }else {
                        print("Database have queryControl hold that query but not near user!!!")
                        self.queryService.getData(query: querySearch, latitude:mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude)
                    }
                    
                    
                }
       
            }
    
    
}

extension SearchTableViewController : ParseDataFromSearch {
    func parseData(data: [PlaceMarkForAllMap]) {
        
       // matchingItems = PlaceMarkForAllMap.shared

        var temp = MapsViewModel(modelAccess: .Google)
        mapsViewModels = data.map({ return temp.setMapsModel(mapsModelAccess: $0)})
//        try! realm.write {
//            realm.add()
//        }
        
        var placeMarkRealmTemps = [PlaceMarkRealm]()
        //placeMarkRealmTemps.reserveCapacity(PlaceMarkForAllMap.shared.count)
        //placeMarkRealmTemps.reserveCapacity(20)
       
        let placeMarkRealmTemp = PlaceMarkRealm()
        let placeMarkRealmTemp1 = PlaceMarkRealm()
        let placeMarkRealmTemp2 = PlaceMarkRealm()
        let placeMarkRealmTemp3 = PlaceMarkRealm()
        let placeMarkRealmTemp4 = PlaceMarkRealm()
        let placeMarkRealmTemp5 = PlaceMarkRealm()
        let placeMarkRealmTemp6 = PlaceMarkRealm()
        let placeMarkRealmTemp7 = PlaceMarkRealm()
        let placeMarkRealmTemp8 = PlaceMarkRealm()
        let placeMarkRealmTemp9 = PlaceMarkRealm()
        let placeMarkRealmTemp10 = PlaceMarkRealm()
        let placeMarkRealmTemp11 = PlaceMarkRealm()
        let placeMarkRealmTemp12 = PlaceMarkRealm()
        let placeMarkRealmTemp13 = PlaceMarkRealm()
        let placeMarkRealmTemp14 = PlaceMarkRealm()
        let placeMarkRealmTemp15 = PlaceMarkRealm()
        let placeMarkRealmTemp16 = PlaceMarkRealm()
        let placeMarkRealmTemp17 = PlaceMarkRealm()
        let placeMarkRealmTemp18 = PlaceMarkRealm()
        let placeMarkRealmTemp19 = PlaceMarkRealm()
        
           
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
        
        let queryControlTemp = queryControl()
        try! realm.write{
            queryControlTemp.setup(query: querySearch, latitude: mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude)
            
            realm.add(queryControlTemp, update: .modified)
        }
        
        for i in PlaceMarkForAllMap.shared.indices {
            try! realm.write {
                print("Write REalm: \(i)")
                let placemarks = realm.objects(PlaceMarkRealm.self).filter("place_id == '\(PlaceMarkForAllMap.shared[i].place_id ?? "")'")
                if(placemarks.count == 0){
                    placeMarkRealmTemps[i].setup(Name: PlaceMarkForAllMap.shared[i].Name, placeName: PlaceMarkForAllMap.shared[i].placeName, latitude: PlaceMarkForAllMap.shared[i].latitude!, longitude: PlaceMarkForAllMap.shared[i].longitude!, placeId: PlaceMarkForAllMap.shared[i].place_id)
                    
                    //placeMarkRealmTemps.append(placeMarkRealmTemp)
                    
                    realm.add(placeMarkRealmTemps[i], update: .modified)
                    //realm.add(placeMarkRealmTemps[i])
                    queryControlTemp.addPlaceMark(placeMark: placeMarkRealmTemps[i])
                    placeMarkRealmTemps[i].addQueryControl(queryControl: queryControlTemp)
                }else{
                    queryControlTemp.addPlaceMark(placeMark: placemarks[0])
                    placemarks[0].addQueryControl(queryControl: queryControlTemp)
                }
                
                
//                print("placemarks count: \(placemarks.count)")
//                for j in placemarks.indices {
//                    print("\(j): \(placemarks[j].placeName)")
//                    placemarks[j].addQueryControl(queryControl: queryControlTemp)
//                }
              
                
            }
                       
        }
        
        if(isDatabaseHaveThatQueryControl == false){
            print("isDatabaseHaveThatQueryControl in write database: \(isDatabaseHaveThatQueryControl)")
            for i in PlaceMarkForAllMap.shared.indices{
                placemarks.append(PlaceMarkForAllMap.shared[i])
            }
            isDatabaseHaveThatQueryControl = false
        }else{
            print("isDatabaseHaveThatQueryControl in write database: \(isDatabaseHaveThatQueryControl)")
            
            DispatchQueue.main.async{
            //  print("\nbbbbbbb\n\(self.mapsViewModels)")
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            }
        }
        //print("\naaaaa\n\(mapsViewModels)")
      
    }
    
    
}
