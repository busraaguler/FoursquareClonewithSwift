//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by busraguler on 17.06.2022.
//

import UIKit
import Parse

class PlacesVC: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var placaNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))

        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutClicked))
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromParse()
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
        //segue
    }
    
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                
            }else{
                if objects != nil{
                    
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placaNameArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId {
                                self.placaNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
                
            }
        }
    }
    @objc func logoutClicked(){
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                self.makeAlert(titleInput: "error", messageInput: "logout?")
            }else{
                self.performSegue(withIdentifier: "toSigninVC", sender: nil)
            }
        }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as? DetailViewController
            destinationVC?.chosenPlaceId = selectedPlaceId
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placaNameArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placaNameArray.count;
    }
    
    
    
    @objc func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
