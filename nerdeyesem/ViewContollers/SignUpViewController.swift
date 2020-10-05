//
//  SignUpViewController.swift
//  nerdeyesem
//
//  Created by Burhan Cabiroğlu on 30.09.2020.
//

import UIKit
import Firebase;

class SignUpViewController: UIViewController {

  
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusStack: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    var password:String?;
    var email:String?;
    var fullName:String?;
    
    
    var timer:Timer?=nil;
    var timerCounter:Double=4;
    var contval:String?;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer=Timer();
        pageSetup();
        
        
        

      
    }
    
    func pageSetup(){
        email="";
        password="";
        timer=Timer();
        fullName="";
        statusStack.isHidden=true;
        passwordTextField.isSecureTextEntry=true;
        
    }
    
    
    @IBAction func signUpAction(_ sender: Any) {
        timer?.invalidate();
        
        password=passwordTextField.text;
        email=emailTextField.text;
        fullName=fullNameTextField.text;
    
        contval=signUpContol();
        
       
        timerCounter=3.5;
        
        if(contval==nil){
            singleton.user=AppUser(userId: "", fullName: fullName!, email: email!, password: password!);
            Auth.auth().createUser(withEmail: singleton.user!.email, password: singleton.user!.password){
                (result: AuthDataResult?,err: Error?) in
             
                
                if(err == nil){
                   print("başarılı")
                    singleton.user?.userId=Auth.auth().currentUser!.uid;
                    singleton.usersDatabase?.document(singleton.user!.userId).setData(singleton.user!.toJson() as! [String : Any])
                    self.contval=nil
                    self.timerBey();
                    self.navigationController?.popViewController(animated: true);
                    
                    
                }
                else{
                    self.contval="Account Not Created";
                    self.timerBey();
                }
                
            }
            
        }
        else{
            timerBey()
        }
      
        
        
        
    }
    
    func signUpContol() -> String? {
        statusStack.isHidden=false;
        if(fullName==""||email==""||password==""){
            return "Please fill in all fields"
        }else if(password!.count<6){
            return "Password must consist of at least 6 letters."
        }
        return nil;
    }
    
    
    func timerBey(){
        timer=Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerSelector), userInfo: nil, repeats: true)
    }
    
    @objc func timerSelector(){
       
        if(contval==nil){
      
            statusLabel.text="Sign Up Successfull"
            statusImage.image=UIImage.init(systemName: "checkmark.seal.fill");
            statusImage.tintColor=UIColor.systemGreen
        }else{
           
            statusLabel.text=contval;
            statusImage.image=UIImage.init(systemName: "xmark.octagon.fill");
            statusImage.tintColor=UIColor.systemRed
        }
        timerCounter-=0.2;
        print("counterda")
        if(timerCounter<0){
            statusStack.isHidden=true;
            print("timer biter");
            timer!.invalidate();
        }
        
        
        
    }

   
}
