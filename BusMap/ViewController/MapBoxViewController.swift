//
//  MapBoxViewController.swift
//  GoogleLogin
//
//  Created by user on 6/11/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit

import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

import GoogleSignIn

protocol HandleMenuOption: class {
    func passDataFromMenu(option: String)
}

class setStack: UIStackView {
    var sizeee: CGSize {
        
        return self.superview!.frame.size
    }
    override var intrinsicContentSize: CGSize {
        return sizeee
    }
}

class MapBoxViewController: UIViewController {
    
    //MARK: PAss data
    

    var annotations = [MGLPointAnnotation()]
    var whatIndexOfViewModelInViewModels = 0
    var spacing: CGFloat = 12.0
    
    //MARK: Apple Core Location Framework
       
    var locationManager: CLLocationManager!
    
    //MARK: VM and Query
    
    var queryService = MainQueryService(queryServiceAccess: .MapBox)
    var mapsViewModel = MapsViewModel(modelAccess: .MapBox)
    var mapsViewModels = [MapsViewModel(modelAccess: .MapBox)]
    
    //
    
    var directionsRoute: Route?
    
     var currentLocation: CLLocation?
    
     lazy var mapView = NavigationMapView(frame: view.bounds)
    
     lazy var profile = ProfileTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        mainSearchViewController.searchTable.handleMapSearchDelegate = self
        mainSearchViewController.searchBarSearchButtonClickedDelegate = self
        
        profile.isMapBox = true
        
        profile.handleMenuOptionDelegate = self
        
        searchTable.handleMapSearchDelegate = self
        
        configureMap()
        
         configureBarButton()
        
         configureActivityIndicator()
        
        configureLocationManager()

        // Do any additional setup after loading the view.
    }
    
    
    // configureBarButton

    @IBOutlet var hamburgerButton: UIBarButtonItem!
    func configureBarButton(){
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
        
        barButton.tintColor = UIColor.rgb(r: 0, g: 0, b: 0)
//        barButton.setBackgroundImage(UIImage(named: "hamburger-icon"), for: .normal, barMetrics: .default)
        //barButton.image = UIImage(named: "icons8-menu-50")

        self.navigationItem.rightBarButtonItem = barButton


//       self.navigationItem.leftBarButtonItem = hamburgerButton
        
        //Uncomment this follow if you want to programamtically custom button
//
         let smallSquare = CGSize(width: 12, height: 31)

        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: .zero, size: smallSquare)
       //button.setBackgroundImage(UIImage(named: "hamburger-icon"), for: .normal)
        
         button.setImage(UIImage(named: "icons8-menu-50"), for: .normal)
       
        button.addTarget(self, action: #selector(HamburgerButtonSelected), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    //MARK: configureLocationManager
    func configureLocationManager(){
        // Initialize the location manager.
           locationManager = CLLocationManager()
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()
        // Set a movement threshold for new events.
           locationManager.distanceFilter = 30 // meters
           locationManager.startUpdatingLocation()
           locationManager.delegate = self
        
        

    }
    
    //MARK: Search
     lazy var searchTable = SearchTableViewController(nibName: nil, bundle: nil)
    lazy var mainSearchViewController = MainSearchViewController()
    
    @objc func searchPlace(){
        
         
        
        mapsViewModel.userLocation = self.mapView.userLocation!.coordinate

               print("user Location: \(self.mapView.userLocation!.coordinate)")
        mainSearchViewController.searchTable.setQueryService(queryService: queryService)
        //Pass user Location,...
        mainSearchViewController.searchTable.setMapsViewModel(mapsViewModel: mapsViewModel)
        
        //mainSearchViewController.searchController.searchBar.delegate = self
        
    self.navigationController?.pushViewController(mainSearchViewController, animated: true)
        
        
        
//        mapsViewModel.userLocation = self.mapView.userLocation!.coordinate
//
//               print("user Location: \(self.mapView.userLocation!.coordinate)")
//        searchTable.setQueryService(queryService: queryService)
//        //Pass user Location,...
//        searchTable.setMapsViewModel(mapsViewModel: mapsViewModel)
//
//        let searchController = UISearchController(searchResultsController: searchTable)
//
//               //searchController.resignFirstResponder()
//
//               searchController.searchResultsUpdater = searchTable
//
//               searchController.searchBar.delegate = self
//
//        searchController.searchBar.barTintColor = UIColor.rgb(r: 25, g: 51, b: 102)
//        searchController.searchBar.tintColor = UIColor.rgb(r: 0, g: 0, b: 0)
//
//               searchController.searchBar.placeholder = "Search for places"
//
//               searchController.searchBar.resignFirstResponder()
               
               //present(searchController, animated: true, completion: nil)
        
    
    }
    
    @objc func HamburgerButtonSelected(){
        
        self.navigationController?.pushViewController(profile, animated: true)
               
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
               self.view.layoutIfNeeded()
               }) { (animationComplete) in
                print("Animation Completed")
               
            }
    }

    @IBAction func hamburgerButtonClicked(_ sender: UIBarButtonItem) {
        
        self.navigationController?.pushViewController(profile, animated: true)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
        self.view.layoutIfNeeded()
        }) { (animationComplete) in
        print("Animation Completed")
        
        }
        
    }
    
    
    //MARK: configureMap
    
    func configureMap(){
     // Set the map view's delegate
        activityIndicator.startAnimating()
              //definesPresentationContext = true
               
              
       
                
              
        //let url = URL(string: "mapbox://styles/mapbox/streets-v11")


        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
             
             
        view.addSubview(mapView)
            
        mapView.styleURL = MGLStyle.streetsStyleURL
              
         mapView.delegate = self

        // Allow the map view to display the user's location
          
              //mapView.showsUserLocation = true
              
            //  mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        
        // Enable heading tracking mode so that the arrow will appear.
        mapView.userTrackingMode = .followWithHeading
         
        // Enable the permanent heading indicator, which will appear when the tracking mode is not `.followWithHeading`.
        mapView.showsUserHeadingIndicator = true
        
        activityIndicator.stopAnimating()
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
    

    //MARK: Remove All Annotations
        
        func removeAllAnnotations() {
          
          guard let annotations = mapView.annotations else { return print("Annotations Error") }
          
          if annotations.count != 0 {
            for annotation in annotations {
              mapView.removeAnnotation(annotation)
            }
          } else {
            return
          }
        }
        
        //MARK: UpdateViewFromViewModel
        
        var annotation = MGLPointAnnotation()
        
        func UpdateViewFromModel(){
            
            
            mapView.clearsContextBeforeDrawing = true
            //mapView.removeRoutes()
            
    //        self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: (self.mapView.userLocation!.coordinate)) { (route, error) in
    //               if error != nil {
    //                          print("Error calculating route")
    //                          //activityIndicator.stopAnimating()
    //                      }
    //           }
            
            removeAllAnnotations()
            
            
                                                        
            guard let longitude = self.mapsViewModels[whatIndexOfViewModelInViewModels].longitude else {
                return
            }
            guard let latitude = self.mapsViewModels[whatIndexOfViewModelInViewModels].latitude else {
                return
            }
            guard let name = self.mapsViewModels[whatIndexOfViewModelInViewModels].Name else {
                return
            }
            guard let placeName = self.mapsViewModels[whatIndexOfViewModelInViewModels].placeName else {
                return
            }
        
            print("AAAAAA: \(longitude), \(latitude), \(name), \(placeName)")
            
            self.navigationItem.title = name
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                      
            print("annotation coordinate update view from model: \(annotation.coordinate)")
                   
            annotation.title = name
            
            annotation.subtitle = placeName
                   
            activityIndicator.startAnimating()
                   print("star animating...")
                   
            self.mapView.addAnnotation(annotation)
                   
                   
            activityIndicator.stopAnimating()
        }
        
        //MARK: layoutTrait
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

            super.traitCollectionDidChange(previousTraitCollection)

            layoutTrait(traitCollection: traitCollection)
        }
       
        func layoutTrait(traitCollection: UITraitCollection)
        {
            if traitCollection.horizontalSizeClass == .compact, traitCollection.verticalSizeClass == .regular {
                
                spacing = 12
                
            }
            else {
                
                spacing = 24
            }
        }
        
      
        
        // MARK: Add Annotations
        
        func addAnnotations(longitude: CLLocationDegrees, latitude: CLLocationDegrees, name: String, placeName: String) -> MGLPointAnnotation{
            
            
            
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                          
                print("annotation coordinate update view from model: \(annotation.coordinate)")
                       
                annotation.title = name
                
                annotation.subtitle = placeName
                       
              
                //self.mapView.addAnnotation(annotation)
            return annotation
        }

    
    //MARK: Custom UserLocation
  
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
    // Substitute our custom view for the user location annotation. This custom view is defined below.
    if annotation is MGLUserLocation && mapView.userLocation != nil {
    return CustomUserLocationAnnotationView()
    }
    return nil
    }
     
    // Optional: tap the user location annotation to toggle heading tracking mode.
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
    if mapView.userTrackingMode != .followWithHeading {
    mapView.userTrackingMode = .followWithHeading
    } else {
    mapView.resetNorth()
    }
     
    // We're borrowing this method as a gesture recognizer, so reset selection state.
    mapView.deselectAnnotation(annotation, animated: false)
    }
    
}
     
    // Create a subclass of MGLUserLocationAnnotationView.
    class CustomUserLocationAnnotationView: MGLUserLocationAnnotationView {
    let size: CGFloat = 21
    var dot: CALayer!
    var arrow: CAShapeLayer!
     
    // -update is a method inherited from MGLUserLocationAnnotationView. It updates the appearance of the user location annotation when needed. This can be called many times a second, so be careful to keep it lightweight.
    override func update() {
    if frame.isNull {
    frame = CGRect(x: 0, y: 0, width: size, height: size)
    return setNeedsLayout()
    }
     
    // Check whether we have the user’s location yet.
    if CLLocationCoordinate2DIsValid(userLocation!.coordinate) {
    setupLayers()
    updateHeading()
    }
    }
     
    private func updateHeading() {
    // Show the heading arrow, if the heading of the user is available.
    if let heading = userLocation!.heading?.trueHeading {
    arrow.isHidden = false
     
    // Get the difference between the map’s current direction and the user’s heading, then convert it from degrees to radians.
    let rotation: CGFloat = -MGLRadiansFromDegrees(mapView!.direction - heading)
     
    // If the difference would be perceptible, rotate the arrow.
    if abs(rotation) > 0.01 {
    // Disable implicit animations of this rotation, which reduces lag between changes.
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    arrow.setAffineTransform(CGAffineTransform.identity.rotated(by: rotation))
    CATransaction.commit()
    }
    } else {
    arrow.isHidden = true
    }
    }
     
    private func setupLayers() {
    // This dot forms the base of the annotation.
    if dot == nil {
    dot = CALayer()
    dot.bounds = CGRect(x: 0, y: 0, width: size, height: size)
     
    // Use CALayer’s corner radius to turn this layer into a circle.
    dot.cornerRadius = size / 2
    dot.backgroundColor = super.tintColor.cgColor
    dot.borderWidth = 4
    dot.borderColor = UIColor.white.cgColor
    layer.addSublayer(dot)
    }
     
    // This arrow overlays the dot and is rotated with the user’s heading.
    if arrow == nil {
    arrow = CAShapeLayer()
    arrow.path = arrowPath()
    arrow.frame = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
    arrow.position = CGPoint(x: dot.frame.midX, y: dot.frame.midY)
    arrow.fillColor = dot.borderColor
    layer.addSublayer(arrow)
    }
    }
     
    // Calculate the vector path for an arrow, for use in a shape layer.
    private func arrowPath() -> CGPath {
    let max: CGFloat = size / 2
    let pad: CGFloat = 3
     
    let top =    CGPoint(x: max * 0.5, y: 0)
    let left =   CGPoint(x: 0 + pad,   y: max - pad)
    let right =  CGPoint(x: max - pad, y: max - pad)
    let center = CGPoint(x: max * 0.5, y: max * 0.6)
     
    let bezierPath = UIBezierPath()
    bezierPath.move(to: top)
    bezierPath.addLine(to: left)
    bezierPath.addLine(to: center)
    bezierPath.addLine(to: right)
    bezierPath.addLine(to: top)
    bezierPath.close()
     
    return bezierPath.cgPath
    }


}
//MARK: End custom userPoint

//MARK: UISearchBarDelegate

extension MapBoxViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        
    }
}

extension MapBoxViewController: MGLMapViewDelegate {
    
    //Show annotation information
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
         return true
     }

    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
    
        let smallSquare = CGSize(width: 30, height: 30)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: .zero, size: smallSquare)
        button.setBackgroundImage(UIImage(named: "BackButton"), for: .normal)
        //button.addTarget(self, action: #selector(getDirectionss), for: .touchUpInside)
       
        return button
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
    // Hide the callout view.
    mapView.deselectAnnotation(annotation, animated: false)
     
    
    
     
    }
     
//    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
//        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, altitude: 4500, pitch: 15, heading: 180)
//    mapView.fly(to: camera, withDuration: 4,
//    peakAltitude: 1000, completionHandler: nil)
//    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
     
    // Create point to represent where the symbol should be placed
    let point = MGLPointAnnotation()
    point.coordinate = mapView.centerCoordinate
     
    // Create a data source to hold the point data
    let shapeSource = MGLShapeSource(identifier: "marker-source", shape: point, options: nil)
     
    // Create a style layer for the symbol
    let shapeLayer = MGLSymbolStyleLayer(identifier: "marker-style", source: shapeSource)
     
    // Add the image to the style's sprite
    if let image = UIImage(named: "house-icon") {
    style.setImage(image, forName: "home-symbol")
    }
     
    // Tell the layer to use the image in the sprite
    shapeLayer.iconImageName = NSExpression(forConstantValue: "home-symbol")
     
    // Add the source and style layer to the map
    style.addSource(shapeSource)
    style.addLayer(shapeLayer)
    }
}

extension MapBoxViewController: HandleMenuOption {
    func passDataFromMenu(option: String) {
        if(option == "Sign Out"){
            GIDSignIn.sharedInstance().signOut()
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
        if(option == "Google Maps"){
            locationManager.stopUpdatingLocation()
            self.navigationController?.pushViewController(GoogleMapsViewController(), animated: true)
        }
    }
}

extension MapBoxViewController: HandleMapSearch {
    func parseDataFromSearch(viewModel: [MapsViewModel], row: Int) {
        //mapsViewModel = viewModel[row]
        
        //Way 2
        mapsViewModels = viewModel
        whatIndexOfViewModelInViewModels = row
        UpdateViewFromModel()
    }
 
    
    
}

extension MapBoxViewController : ParseDataFromSearch {
    func parseData(data: [PlaceMarkForAllMap]) {
        
       // matchingItems = PlaceMarkForAllMap.shared

        var temp = MapsViewModel(modelAccess: .Google)
        mapsViewModels = data.map({ return temp.setMapsModel(mapsModelAccess: $0)})
       
    }
    
    
}

extension MapBoxViewController: CLLocationManagerDelegate {

 //  Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    currentLocation = locations.last!
    
    let location: CLLocation = locations.last!
    print("MapBox User Location: \(location)")

//    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                          longitude: location.coordinate.longitude,
//                                          zoom: zoomLevel)

    if mapView.isHidden {
      mapView.isHidden = false
     // mapView.camera = camera
    } else {
     // mapView.animate(to: camera)
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

extension MapBoxViewController: searchBarSearchButtonClicked {
    func Clicked(category: GoogleCategory) {
          mapView.clearsContextBeforeDrawing = true
            mapView.removeRoutes()
              removeAllAnnotations()

              annotations.removeAll()
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
                  
                  let temp = MGLPointAnnotation()
                 
                  temp.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                            
                  print("annotation coordinate update view from model: \(annotation.coordinate)")
                         
                  temp.title = name
                  
                  temp.subtitle = placeName

                  //Why it's not work exactly if we use this function? (Test: Print annotations exactly but can not show it in the map!)
                  //let temp = addAnnotations(longitude: longitude, latitude: latitude, name: name, placeName: placeName)
                  
                  
                  annotations.append(temp)
                  self.mapView.addAnnotation(annotations[i])
                  
              }

              
              activityIndicator.stopAnimating()
    }
    
    
}
