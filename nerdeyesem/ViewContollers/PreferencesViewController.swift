//
//  PreferencesViewController.swift
//  nerdeyesem
//
//  Created by Burhan Cabiroğlu on 4.10.2020.
//

import UIKit
import Firebase

class PreferencesViewController: UIViewController {

    @IBOutlet weak var fingerSwitch: UISwitch!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var nameField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text=singleton.user?.email
        nameField.text=singleton.user?.fullName
        
        let controlSWC:Bool? = UserDefaults.standard.bool(forKey: "fingerPrint")
        
        if(controlSWC != nil ){
          
         fingerSwitch.setOn(controlSWC!, animated: false)
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        print("delete action")
        singleton.usersDatabase?.document(singleton.user!.userId).delete(){
            (Error) in
            if(Error == nil){
                Firebase.Auth.auth().currentUser?.delete(){
                    (err) in
                    if(err == nil ){
                        self.performSegue(withIdentifier:"awkwardSegue" , sender: nil)
                    }
                    else{
                        print("kullanıcı silinemedi")
                    }
                }
                
            }
            else{
                print("kullanıcı silinemedi")
            }
        }
    }
    
  
    @IBAction func signOutAction(_ sender: Any) {
        print("action sign out")
        do{
            let _ = try Firebase.Auth.auth().signOut()
        }
        catch{
            print("ebenin hatası artık ya")
        }
    
        DispatchQueue.main.async {
            self.performSegue(withIdentifier:"awkwardSegue" , sender: nil)
        }
        
        
       
    }
       
   
    @IBAction func fingerSwitchAction(_ sender: Any) {
        print("finger print state \(fingerSwitch.isOn)")
        UserDefaults.standard.set(fingerSwitch.isOn, forKey: "fingerPrint")
    }
}
    
   
