//
//  ViewController.swift
//  nerdeyesem
//
//  Created by Burhan Cabiroğlu on 30.09.2020.
//

import UIKit
import Firebase
import LocalAuthentication

class ViewController: UIViewController {
    
    
    var timer:Timer?=nil;
    var result:String?;
    var counter:Double=4;

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var statusStack: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    var password:String?;
    var email:String?;
    
    var controlFinger:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup();
        controlFinger=UserDefaults.standard.bool(forKey: "fingerPrint")
        if(controlFinger != nil && Firebase.Auth.auth().currentUser != nil){
            if(controlFinger!){
                authenticateUser()
            }
        }
        

        
    }
    
    
    func pageSetup(){
        statusStack.isHidden=true;
        passwordTextField.isSecureTextEntry=true;
    }

    @IBAction func loginAction(_ sender: Any) {
        counter=4;
        result=loginControl();
        timer?.invalidate();
        
        if(result==nil){
            Auth.auth().signIn(withEmail: email!, password: password!){
                (AuthResult,err) in
                
                if(err==nil){
                    self.result=nil
                    self.timerBey()
                    print("başarılı")
                    let docRef=singleton.usersDatabase?.document(Auth.auth().currentUser!.uid)
                    
                    docRef?.getDocument{
                        (document,err) in
                        
                        singleton.user=AppUser.populateFromJson( data: document!.data()!)
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
                    }
                    
                }
                else{
                    self.result="Kullanıcı adı veya şifre hatalı"
                    self.timerBey()
                }
            }
        }
        else{
            timerBey()
        }
        
        
       
        
    }
    
    func timerBey(){
        timer=Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerSelector), userInfo: nil, repeats: true)
    }
    
    @objc func timerSelector(){
    
       
        if(result==nil){
            statusLabel.text="Giriş Başarılı";
            statusStack.isHidden=false;

            statusImage.image=UIImage.init(systemName: "checkmark.seal.fill");
            statusImage.tintColor=UIColor.systemGreen
        }
        else{
             statusLabel.text=result;
            statusStack.isHidden=false;

             statusImage.image=UIImage.init(systemName: "xmark.octagon.fill");
             statusImage.tintColor=UIColor.systemRed
        }
        counter-=0.2;
        print("counterda")
        if(counter<0){
            statusStack.isHidden=true;
            
            print("timer biter");
            timer!.invalidate();
        }
    }
    
    func loginControl() -> String?{
        email=emailTextField.text;
        password=passwordTextField.text;
        
        
        if(email=="" || password==""){
            return "Please fill in all fields";
        }
        
        
        return nil
        
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                (success, authenticationError) in

                DispatchQueue.main.async {
                    if success {
                        print("succesfull face id")
                        
                        let docRef=singleton.usersDatabase?.document(Auth.auth().currentUser!.uid)
                        
                        docRef?.getDocument{
                            (document,err) in
                            
                            singleton.user=AppUser.populateFromJson( data: document!.data()!)
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    
                        }
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    
    
    
}

