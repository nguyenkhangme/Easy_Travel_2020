//
//  GoogleMapsViewController.swift
//  GoogleLogin
//
//  Created by user on 6/11/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit

import GoogleSignIn
import GoogleMaps
import GooglePlaces

import Realm
import RealmSwift

class GoogleMapsViewController: UIViewController {
    
    var realm = try! Realm()
    
    var cafeView: UIImageView?
    var restaurantView: UIImageView?
    var libraryView: UIImageView?
    var busStationView: UIImageView?
    var GoogleCategory: GoogleCategory = .other
    
     lazy var mainSearchViewController = MainSearchViewController()

    lazy var profile = ProfileTableViewController()
    
    //pass
    
    var annotations = [GMSMarker]()
    var whatIndexOfViewModelInViewModels = 0
    
    //VM and Query
    
    var queryService = MainQueryService(queryServiceAccess: .Google)
    var mapsViewModel = MapsViewModel(modelAccess: .Google)
    var mapsViewModels = [MapsViewModel(modelAccess: .Google)]
    
    //MARK: Apple Core Location Framework
    var locationManager: CLLocationManager!
    
    //MARK: GoogleMap
    
    var currentLocation = CLLocation()
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    //MARK: viewDidLoad
    
    var controlBeginingCameraGoToUserLocation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let queryRecent = RecentQueryy()
//
//        try! realm.write{
//                        queryRecent.setup(query: "", user: "")
//                       realm.add(queryRecent)
//        }
        
      //  print("mnmnm: \(String(describing: User.sharedInstance.email))")
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        mainSearchViewController.searchTable.handleMapSearchDelegate = self
        mainSearchViewController.searchBarSearchButtonClickedDelegate = self
    
       
        
        profile.isMapBox = false
        profile.handleMenuOptionDelegate = self
             
        configureLocationManager()
        configureBarButton()
        
        configureMap()
        configureActivityIndicator()
        
        let cafe = UIImage(named: "icons8-cafe-30")!.withRenderingMode(.automatic)
        let busStation = UIImage(named: "icons8-bus-30")!.withRenderingMode(.automatic)
        let restaurant = UIImage(named: "icons8-restaurant-m.png")!.withRenderingMode(.automatic)
        let library = UIImage(named: "icons8-library-30")!.withRenderingMode(.automatic)
        
        var markerView = UIImageView(image: cafe)
       // markerView.tintColor = .red
        cafeView = markerView
        
        markerView = UIImageView(image: busStation)
        busStationView = markerView
        
        markerView = UIImageView(image: restaurant)
        restaurantView = markerView
        
        markerView = UIImageView(image: library)
        libraryView = markerView
        
        
        // Do any additional setup after loading the view.
    }
    
 
    
    //MARK: configureLocationManager
    func configureLocationManager(){
        // Initialize the location manager.
           locationManager = CLLocationManager()
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()
        // Set a movement threshold for new events.
           locationManager.distanceFilter = 0 // meters
           locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 30
           locationManager.delegate = self
        
        

           placesClient = GMSPlacesClient.shared()

    }

    //MARK: configureBarButton
    
      func configureBarButton(){
            
            let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
    
        barButton.tintColor = UIColor.rgb(r: 0, g: 0, b: 0)

           self.navigationItem.rightBarButtonItem = barButton


           //self.navigationItem.leftBarButtonItem = hamburgerButton
            
//            Uncomment this follow if you want to programamtically custom button
    
             let smallSquare = CGSize(width: 12, height: 31)
    
            let button = UIButton(type: .custom)
            button.frame = CGRect(origin: .zero, size: smallSquare)
           //button.setBackgroundImage(UIImage(named: "hamburger-icon"), for: .normal)
    
             button.setImage(UIImage(named: "icons8-menu-50"), for: .normal)
            button.tintColor = .orange
      
            button.addTarget(self, action: #selector(hamburgerButtonClicked), for: .touchUpInside)
    
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        }

    //MARK: hamburgerButtonClicked
    
   @objc func hamburgerButtonClicked(_ sender: UIBarButtonItem) {
        
        self.navigationController?.pushViewController(profile, animated: true)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
        self.view.layoutIfNeeded()
        }) { (animationComplete) in
        print("Animation Completed")
        
        }
        
    }
    
    //MARK: Search
    lazy var searchTable = SearchTableViewController(nibName: nil, bundle: nil)
    
    lazy var searchController = UISearchController(searchResultsController: searchTable)
    
    @objc func searchPlace(){
        
        mapsViewModel.userLocation = currentLocation.coordinate

        mainSearchViewController.searchTable.setQueryService(queryService: queryService)
              //Pass user Location,...
        mainSearchViewController.searchTable.setMapsViewModel(mapsViewModel: mapsViewModel)
              
        
              
          self.navigationController?.pushViewController(mainSearchViewController, animated: true)
        
//        
    
    }
    
    //MARK: Configure Map

      func configureMap(){
        
        
          
          
           // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude,
                                                   zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self

             // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
          
        mapView.translatesAutoresizingMaskIntoConstraints = false
          
        let viewsDictionary: [String:Any] = ["GoogleMapView": mapView!]
          
        let GoogleMapView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[GoogleMapView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
          
        let GoogleMapView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[GoogleMapView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
          
        view.addConstraints(GoogleMapView_H)
        view.addConstraints(GoogleMapView_V)
        
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
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
        //MARK: UpdateViewFromViewModel
        
        let marker = GMSMarker()
        
        func UpdateViewFromModel(){
            
            GoogleCategory = .other
            
            for j in annotations.indices{
                annotations[j].map = nil
            }
            
            marker.map = nil
            
            mapView.clearsContextBeforeDrawing = true
            //mapView.removeRoutes()
            //removeAllAnnotations()
                   
            
                                                        
            guard let longitude = self.mapsViewModel.longitude else {
                       return
                   }
            guard let latitude = self.mapsViewModel.latitude else {
                       return
                   }
            guard let name = self.mapsViewModel.Name else {
                       return
                   }
            guard let placeName = self.mapsViewModel.placeName else {
                       return
                   }
            
            
            self.navigationItem.title = name
            
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                      
            
                   
            marker.title = name
            
            marker.snippet = placeName
                   
    //        activityIndicator.startAnimating()
    //               print("star animating...")
                   
            marker.map = mapView
            
            ///
            
//            var spanData = CLLocationDegrees()
//            if (2*abs(currentLocation.coordinate.latitude-marker.position.latitude) > 2*abs(currentLocation.coordinate.longitude-marker.position.longitude)) {
//
//                       spanData = (2*abs(currentLocation.coordinate.latitude-marker.position.latitude) + 0.01)
//            } else {
//                       spanData = (2*abs(currentLocation.coordinate.longitude-marker.position.longitude) + 0.01)
//            }
            
//            let region = GMSVisibleRegion(nearLeft: <#T##CLLocationCoordinate2D#>, nearRight: <#T##CLLocationCoordinate2D#>, farLeft: <#T##CLLocationCoordinate2D#>, farRight: <#T##CLLocationCoordinate2D#>)
//            let coordinateBounds = GMSCoordinateBounds(region: <#T##GMSVisibleRegion#>)
//
//            let cameraUPdate = GMSCameraUpdate.fit(<#T##bounds: GMSCoordinateBounds##GMSCoordinateBounds#>)

            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude ,
                                                  longitude: currentLocation.coordinate.longitude ,
                                                  zoom: 12)
            mapView.animate(to: camera)
            
            //
            
//
//
//            let span = MKCoordinateSpan(latitudeDelta: spanData, longitudeDelta: spanData)
//            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
//
//                   //selectedPin = .init(coordinate: annotation.coordinate)
//
//
//            AppleMapView.setRegion(region, animated: true)
            ///
                   
                   
        }
    
//    override func loadView() {
//      let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
//      let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
//      self.view = mapView
//    }

    
}

extension GoogleMapsViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
       UIView.animate(withDuration: 5.0, animations: { () -> Void in
         //self.cafeView?.tintColor = .blue
         }, completion: {(finished) in
           // Stop tracking view changes to allow CPU to idle.
            for i in self.annotations.indices{
                self.annotations[i].tracksViewChanges = false
            }
       })
     }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        //https://developers.google.com/maps/documentation/ios-sdk/reference/protocol_g_m_s_map_view_delegate-p#ad925926feb3cec4fbccfd05935876281


        return nil
    }
//
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        
        
        let infoWindow = MarkerInforWindow(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        //let restaurantPreviewView=RestaurantPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
       
        let cafeIcon = cafeView
        let busIcon = busStationView
        let restaurantIcon = restaurantView
        let libraryIcon = libraryView
        switch GoogleCategory {
            case .cafe:
                print("markerInfoContents: Cafe")
                infoWindow.addSubview(cafeIcon!)
                cafeIcon!.lx.fill(top: 0, left: 0, bottom: 60, right: 0)
                break;
            case .bus_station:
                //infoWindow.imageView = busIcon!
                 infoWindow.addSubview(busIcon!)
                 busIcon!.lx.fill(top: 0, left: 0, bottom: 60, right: 0)
                 break;
            case .restaurant:
                 infoWindow.addSubview(restaurantIcon!)
                 restaurantIcon!.lx.fill(top: 0, left: 0, bottom: 60, right: 0)
                 break;
            case .library:
                 infoWindow.addSubview(libraryIcon!)
                 libraryIcon!.lx.fill(top: 0, left: 0, bottom: 60, right: 0)
                 break;
            case .other:
                print("markerInfoContents: Other")
                break;
            case .car_repair:
                break;
        }
      

        let title = UILabel()
        title.text = marker.title
        print(title.text ?? "wewewqesda")
        infoWindow.addSubview(title)
        title.lx.sizeToFit()
                .alignBottom(39)
                .hcenter()
        
        let subTitle = UILabel()
        subTitle.text = marker.snippet
               print(subTitle.text ?? "wewewqesda")
               infoWindow.addSubview(subTitle)
               subTitle.lx.sizeToFit()
                       .alignBottom(15)
                       .hcenter()
        
        return infoWindow
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
//        let imgName = customMarkerView.imageName
//        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), imageName: imgName, borderColor: secondaryColor, tag: customMarkerView.tag)
//        marker.iconView = customMarker
//        return false
//    }
    
//    func getEstimatedWidthForMarker(_ place: SSPlace, padding: CGFloat) -> CGFloat {
//        var estimatedWidth: CGFloat = 0
//        let infoWindow = CustomMarkerInfoWindow()
//        let maxWidth = (UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.7 : UIScreen.main.bounds.width * 0.8) - padding
//        let titleWidth = (place.name ?? "").width(withConstrainedHeight: infoWindow.txtLabel.frame.height, font: infoWindow.txtLabel.font)
//        let subtitleWidth = (place.address ?? "").width(withConstrainedHeight: infoWindow.subtitleLabel.frame.height, font: infoWindow.subtitleLabel.font)
//        estimatedWidth = min(maxWidth, max(titleWidth, subtitleWidth))
//        return estimatedWidth
//    }

}
//MARK: UISearchBarDelegate

extension GoogleMapsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}

extension GoogleMapsViewController: HandleMenuOption {
    func passDataFromMenu(option: String) {
        if(option == "Sign Out"){
            GIDSignIn.sharedInstance().signOut()
             self.navigationController?.popViewController(animated: true)
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
        if(option == "Map Box"){
             locationManager.stopUpdatingLocation()
             self.navigationController?.pushViewController(MapBoxViewController(), animated: true)
        }
    }
}


//CLLocationManagerDelegate

extension GoogleMapsViewController: CLLocationManagerDelegate {

 //  Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    currentLocation = locations.last!
    
    let location: CLLocation = locations.last!
    print("Location: \(location)")
    
    if(controlBeginingCameraGoToUserLocation == 0 ) {
        controlBeginingCameraGoToUserLocation += 1
        
         let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)

            if mapView.isHidden {
              mapView.isHidden = false
              mapView.camera = camera
            } else {
              mapView.animate(to: camera)
            }
    }else{
        
    }

   

    //listLikelyPlaces()
  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}

extension GoogleMapsViewController: HandleMapSearch {
    func parseDataFromSearch(viewModel: [MapsViewModel], row: Int) {
        
        mapsViewModel = viewModel[row]
        
        UpdateViewFromModel()

    }
    
    
}

extension GoogleMapsViewController: searchBarSearchButtonClicked {
    func Clicked(category :GoogleCategory) {
        
        GoogleCategory = category
        
        for j in annotations.indices{
            annotations[j].map = nil
        }
        annotations.removeAll()
        //print("SDASJJKNDKIEKK")
        activityIndicator.startAnimating()
        
        var temp = MapsViewModel(modelAccess: .MapBox)
        
        mapsViewModels = PlaceMarkForAllMap.shared.map({ return temp.setMapsModel(mapsModelAccess: $0)})
        
        for i in mapsViewModels.indices{
            print("i:\(i)\n")
        guard let longitude = self.mapsViewModels[i].longitude else {
                   return
               }
               guard let latitude = self.mapsViewModels[i].latitude else {
                   return
               }
               guard let name = self.mapsViewModels[i].Name else {
                   return
               }
               guard let placeName = self.mapsViewModels[i].placeName else {
                   return
               }
            
            let temp = GMSMarker()
           
            temp.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            temp.title = name
            temp.snippet = placeName

            //Why it's not work exactly if we use this function? (Test: Print annotations exactly but can not show it in the map!)
            //let temp = addAnnotations(longitude: longitude, latitude: latitude, name: name, placeName: placeName)
            
            ///
            
            let customMarkerWidth: Int = 50
            let customMarkerHeight: Int = 70
            
            var img : UIImage?
            
            switch category {
            case .cafe:
                img = cafeView?.image
            case .bus_station:
                img = busStationView?.image
            case .restaurant:
                img = restaurantView?.image
            case .library:
                img = libraryView?.image
            default:
                break;
            }
            
            
           
            ///
            
            annotations.append(temp)
            
           // guard let customMarkerView = annotations[i].iconView as? CustomMarkerView else { return }
                      // let img = customMarkerView.img!
            if img != nil {
                let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img!, borderColor: UIColor.white, tag: i)
            
                annotations[i].iconView = customMarker
                
            }
//            switch category {
//            case .cafe:
//                annotations[i].iconView = cafeView
//            case .bus_station:
//                annotations[i].iconView = busStationView
//            case .restaurant:
//                annotations[i].iconView = restaurantView
//            case .library:
//                annotations[i].iconView = libraryView
//            default:
//                break;
//            }
            
            annotations[i].tracksViewChanges = true
            annotations[i].map = mapView
            
        }

        
        activityIndicator.stopAnimating()
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude ,
                                              longitude: currentLocation.coordinate.longitude ,
        zoom: 12)
        mapView.animate(to: camera)
    }
}

extension GMSMarker{
    //markerX.icon = self.markerImage(with: .black)
}
