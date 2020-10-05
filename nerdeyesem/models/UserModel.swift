import Foundation

class AppUser{
    var userId:String
    var fullName:String
    var email:String
    var password:String
    var places:Array<String>
    
    
    init(userId:String,fullName:String,email:String,password:String) {
        self.email=email;
        self.fullName=fullName;
        self.userId=userId;
        self.password=password;
        self.places=[];
    }
    
    func addPlace(element:String){
        if(!places.contains(element)){
            places.append(element);
        }
    }
    func removePlace(element:String){
        if(places.contains(element)){
            places.remove(at: places.firstIndex(of: element)!);
        }
        
    }
    
    func toJson() ->  Any {
        return ["UserId":self.userId,"fullName":self.fullName,"email":self.email,"password":self.password,"places":self.places]
    }
    
    static func populateFromJson(data:Dictionary<String, Any> ) -> AppUser{
        let newUser = AppUser(userId: data["UserId"] as! String, fullName: data["fullName"] as! String, email: data["email"] as! String, password: data["password"] as! String);
        
        newUser.places=data["places"] as! Array;
        
        return newUser;
        
    }
    
    func updateInfo(){
        singleton.usersDatabase?.document(singleton.user!.userId).setData(singleton.user!.toJson() as! [String : Any])
    }
    
}
