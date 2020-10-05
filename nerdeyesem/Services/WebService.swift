import Foundation

class WebService{
    
    static var PlacesData:Array<Place> = []
    static var konum:String=""
    
    
    func getData(_latitute:String, _longitude:String, completion: @escaping(Any?) -> () ){
        WebService.PlacesData.removeAll()
        
        let _urlString:String="https://developers.zomato.com/api/v2.1/geocode?lat="+_latitute+"&lon="+_longitude
        
        let url=URL(string: _urlString)!
        var request = URLRequest(url: url)
        print("url bu:"+_urlString)
        request.addValue("8d98d5ccb7f7764fd7f2f93dd63c0333", forHTTPHeaderField: "user-key")
        
        URLSession.shared.dataTask(with: request){
            (data,response,error) in
                
            if (error != nil){
                print("veri alınırken hata alındı")
                completion(nil)
            }
            else if(data != nil){
                let jsonResponse = try? (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any>)
                
                
                /*DispatchQueue.main.async {
                    print(jsonResponse)
                }*/
            
                //print(jsonResponse!)
                
               // var geciciArray:Dictionary<String,Any>
                
                
                let locationDicto=(jsonResponse?["location"] as! Dictionary<String,Any>)
                let popularityDicto=(jsonResponse?["popularity"] as! Dictionary<String,Any>)
                
                let loc:String = locationDicto["title"] as! String;
                let sts:String = popularityDicto["subzone"] as! String;
                
                WebService.konum=loc+", "+sts
                completion(WebService.konum)
                
                let nearby_restaurant=(jsonResponse?["nearby_restaurants"] as! Array<Dictionary<String,Any>>)
                
                print("\(nearby_restaurant.count) restaurant bulundu" )
                
                for i in 0...nearby_restaurant.count-1{
                    
                    let muhtarinYeri=(nearby_restaurant[i]["restaurant"]) as! Dictionary<String,Any>
                    let name=muhtarinYeri["name"] as! String
                    let cuisines=muhtarinYeri["cuisines"] as! String
                    let photos_url=muhtarinYeri["photos_url"] as! String
                    let locationDict=(muhtarinYeri["location"] as! Dictionary<String,Any>)
                    let user_rating=(muhtarinYeri["user_rating"] as! Dictionary<String,Any>)
                    let votesCount=user_rating["votes"] as! Int
                    let votes=user_rating["aggregate_rating"]
                    let votesText=user_rating["rating_text"] as! String
                    let address=locationDict["address"] as! String
                    let _latitude=locationDict["latitude"] as! String
                    let _longitude=locationDict["longitude"] as! String
                    
                    let locationStruct=Coordinate.init(latitude: _latitude, longitude: _longitude)
                    
                    let demoPlace=Place.init(name: name, coordinate: locationStruct, vote: "\(votes!)", img: photos_url, type: cuisines, voteText: votesText, voteCount: "\(votesCount)", address: address)
                    
                
                
                    WebService.PlacesData.append(demoPlace)
                    
                    
                    
                }
                          
                
                
                
            }
          
            
            
            
            
        }.resume()
        
    }
}
