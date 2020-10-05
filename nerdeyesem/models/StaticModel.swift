import Firebase

class singleton{
    
    static var user:AppUser?
    static var db=Firestore.firestore();
    static var usersDatabase:CollectionReference?
    
    
    
    init() {
        singleton.db = Firestore.firestore();
        singleton.usersDatabase=singleton.db.collection("users")
    }
    
}
