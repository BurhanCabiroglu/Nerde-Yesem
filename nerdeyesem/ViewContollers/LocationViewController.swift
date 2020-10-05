//
//  LocationViewController.swift
//  nerdeyesem
//
//  Created by Burhan Cabiroğlu on 2.10.2020.
//

import UIKit
import CoreLocation
import MapKit


class LocationViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var getNavButton: UIButton!
    var navBool:Bool=true
    @IBOutlet weak var scoreView: UIView!
    
    
    
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var voteCountText: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var scoreText: UILabel!
    
    @IBOutlet weak var nameText: UILabel!
    
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var informationStack: UIStackView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var _location:Coordinate?;
    
    var selectedRestaurant:Place?

    override func viewDidLoad() {
        super.viewDidLoad();
        mapView.delegate=self;
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
        informationStack.layer.shadowPath = UIBezierPath(rect: informationStack.bounds).cgPath
       
        informationStack.layer.shadowOffset = .zero
        informationStack.layer.shadowOpacity = 0.4
        
        informationStack.layer.borderWidth=2
        informationStack.backgroundColor=UIColor.white
        informationStack.layer.cornerRadius=20
        //informationStack.layer.borderColor = UIColor.init(red: 131.00/255.00, green: 70.00/255.00, blue: 85.00/255.0, alpha: 1.00).cgColor
        informationStack.isHidden=true
        mapView.isZoomEnabled=true;
        mapView.isScrollEnabled=true
        
    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _location = Coordinate.init(latitude: "\(locations[0].coordinate.latitude)", longitude: "\(locations[0].coordinate.longitude)")
        
        WebService().getData(_latitute:_location!.latitude, _longitude: _location!.longitude){
            (data) in
            
            DispatchQueue.main.async {
                print("Web service konumu : "+WebService.konum)
                self.locationLabel.text=WebService.konum;
                
                for item in WebService.PlacesData{
                    let annotation=MKPointAnnotation()
                
                    annotation.coordinate=CLLocationCoordinate2D(latitude: Double(item.coordinate.latitude)!, longitude: Double(item.coordinate.longitude)!);
                    
                    annotation.title=item.name;
                    annotation.subtitle=item.type;
                    
                    
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }

            }
            
        }
        
        
        // <-- user location area -->
        
        
        
        let loc=CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude);
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05);
        
        let region=MKCoordinateRegion(center: loc, span: span);
        
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation=true;
        
        // <!-- user Location Area -->
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
     
        setAnnotationToRestaurant(title: view.annotation!.title!!)
      
        navBool = true
        
        if(navBool){
            getNavButton.setTitle("Git", for: UIControl.State.init())
            getNavButton.backgroundColor=UIColor(red: 125/255, green: 85/255, blue: 116/255, alpha: 1.00)
            singleton.user?.removePlace(element:  selectedRestaurant!.name)
            singleton.user?.updateInfo()
            print(selectedRestaurant!.name + " silindi")
        }
        else{
            getNavButton.setTitle("Vazgeç", for: UIControl.State.init())
            getNavButton.backgroundColor=UIColor.gray
            singleton.user!.addPlace(element: selectedRestaurant!.name)
            singleton.user?.updateInfo()
            print(selectedRestaurant!.name + " eklendi")
        }
    }
   
    
    func setAnnotationToRestaurant(title:String){
        for item in WebService.PlacesData {
            if item.name == title{
                selectedRestaurant=item
                informationStack.isHidden=false
                nameText.text=item.name;
                scoreText.text=item.vote;
                typeText.text=item.type;
                voteCountText.text=item.voteCount+" kişi oyladı"
                addressText.text=item.address
                
                
                
                if(Double(item.vote)!>4.0){
                    scoreView.backgroundColor=UIColor.init(red: 108/255, green: 193/255, blue: 79/255, alpha: CGFloat(Double(selectedRestaurant!.vote)!/5) )
                }
                else if(Double(item.vote)!>3.0){
                    scoreView.backgroundColor=UIColor.init(red: 108/255, green: 193/255, blue: 79/255, alpha: CGFloat(Double(selectedRestaurant!.vote)!/5) )
                }
                else if(Double(item.vote)!>2.0){
                    scoreView.backgroundColor=UIColor.init(red: 215/255, green: 155/255, blue: 134/255, alpha: CGFloat(1/Double(selectedRestaurant!.vote)!))
                }
                else if(Double(item.vote)!>1.0){
                    scoreView.backgroundColor=UIColor.init(red: 222/255, green: 94/255, blue: 86/255, alpha: CGFloat(1/Double(selectedRestaurant!.vote)!))
                }
                break
            }
            else{
                selectedRestaurant=nil
            }
        }
        
        
    }
    
    @IBAction func getNavAction(_ sender: Any) {
        navBool = !navBool
        
        if(navBool){
            getNavButton.setTitle("Git", for: UIControl.State.init())
            getNavButton.backgroundColor=UIColor(red: 125/255, green: 85/255, blue: 116/255, alpha: 1.00)
            singleton.user?.removePlace(element:  selectedRestaurant!.name)
            singleton.user?.updateInfo()
            print(selectedRestaurant!.name + " silindi")
            
            
            
            
            
        }
        else{
            getNavButton.setTitle("Vazgeç", for: UIControl.State.init())
            getNavButton.backgroundColor=UIColor.lightGray
            singleton.user!.addPlace(element: selectedRestaurant!.name)
            singleton.user?.updateInfo()
            print(selectedRestaurant!.name + " eklendi")
        }

        
        
        
    }
    @IBAction func refreshAction(_ sender: Any) {
        // refresh all actions
    }

}
