//
//  AddPlaceViewController.swift
//  FoursquareClone
//
//  Created by busraguler on 17.06.2022.
//

import UIKit


//var globalName = ""
//var globalPlace = ""
//var globalAtmosphere = ""
class AddPlaceViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeAtmosphere: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosenImg))
        imageView.addGestureRecognizer(gestureRecognizer)


        // Do any additional setup after loading the view.
    }
    

    @IBAction func navigationButton(_ sender: Any) {
        let placeModel = PlaceModel.sharedInstance
        
        if placeTextField.text != "" && placeType.text != "" && placeAtmosphere.text != ""{
            if let chooseImage = imageView.image{
                
                placeModel.placeName = placeTextField.text!
                placeModel.placeType = placeType.text!
                placeModel.placeAtmosphere = placeAtmosphere.text!
                placeModel.placeImage = chooseImage
                
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "placename/placeAtmospher/placeType", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
       
    }
        
        
    @objc func choosenImg() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    

}

