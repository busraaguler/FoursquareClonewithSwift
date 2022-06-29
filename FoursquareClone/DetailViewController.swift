//
//  DetailViewController.swift
//  FoursquareClone
//
//  Created by busraguler on 17.06.2022.
//

import UIKit
import MapKit
import Parse

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var placeImageView: UIImageView!
    
    
    @IBOutlet weak var detailPlaceNameLabel: UILabel!
    
    @IBOutlet weak var detailPlaceTypeLabel: UILabel!
    
    
    @IBOutlet weak var detailPlaceAtmosphereLabel: UILabel!
    
    
    @IBOutlet weak var detailMapKit: MKMapView!
    
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(chosenPlaceId)
        
    
        getDataFromParse()
        detailMapKit.delegate = self
        
        

        
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { (objects, error )in
            if error != nil{
                
            }else{
                if objects != nil {
                    if objects!.count > 0 {
                         let chosenPlaceObject = objects![0]
                        
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String{
                            self.detailPlaceNameLabel.text = placeName
                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type")  as? String{
                            self.detailPlaceTypeLabel.text = placeType
                        }
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.detailPlaceAtmosphereLabel.text = placeAtmosphere
                        }
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude){
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { (data, error) in
                                if error == nil{
                                    if data != nil{
                                    self.placeImageView.image = UIImage(data: data!)
                                    }
                                }
                                    
                            }
                        }
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.detailMapKit.setRegion(region, animated: true)
                        
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailPlaceNameLabel.text!
                        annotation.subtitle = self.detailPlaceTypeLabel.text!
                        self.detailMapKit.addAnnotation(annotation)
                        
                        
                    }
                }
                
            }
    
        }

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{  //kullanıcının yeri ile ilgili birşey yok.
            return nil
        }
        
        let reusedId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusedId)
        
        if pinView == nil {  //pinview daaha önce eklenmemişse
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reusedId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button  //sağ tarafta çıkan button

        }else{
            pinView?.annotation = annotation

        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
        
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks {
                
                if placemark.count > 0 {
                    
                    let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                    let mapItem = MKMapItem(placemark: mkPlaceMark)
                    mapItem.name = self.detailPlaceNameLabel.text
                    
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                    
                    mapItem.openInMaps(launchOptions: launchOptions)
                }
            }
        }
        }
    }
}
