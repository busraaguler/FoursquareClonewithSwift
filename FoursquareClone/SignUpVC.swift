//
//  ViewController.swift
//  FoursquareClone
//
//  Created by busraguler on 16.06.2022.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.current() //kayıtlı kullanıcıyı gösterir
        
        print(currentUser?.username)
        if currentUser != nil {
            performSegue(withIdentifier: "toPlacesVC", sender: nil)
        }
        
        
        
        /*let parseObject = PFObject(className: "Fruits")
        parseObject["name"] = "Banana"
        parseObject["caloires"] = 200
        parseObject.saveInBackground { (success, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                print("uploaded")
            
            }
        }*/
        
        /*let query = PFQuery(className: "Fruits")
        //query.whereKey("name", equalTo: "Apple") name'i apple olanları getir
        query.whereKey("calories", greaterThan: 100) //kalorisi 100'den büyük olanları getir
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                print(objects)
            }
        }*/
    }

    @IBAction func signinButton(_ sender: Any) {
        
        if usernameTextField.text != "" && passwordTextField.text != ""{
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!)
            self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                
        }else{
            makeAlert(titleInput: "hata", messageInput: "username/password")
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        
        if usernameTextField.text != "" && passwordTextField.text != ""{
            
            let user = PFUser()
            user.username = usernameTextField.text!
            user.password = passwordTextField.text!
            
            user.signUpInBackground { (success,error) in
                if error != nil {
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error" )
                }else{
                    //segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(titleInput: "error", messageInput: "Username/password")
        }
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

