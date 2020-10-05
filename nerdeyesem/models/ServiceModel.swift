//
//  ServiceModel.swift
//  nerdeyesem
//
//  Created by Burhan Cabiroğlu on 1.10.2020.
//

struct Place  {
    let name:String
    let coordinate:Coordinate
    let vote:String
    let img:String
    let type:String
    let voteText:String
    let voteCount:String
    let address:String
}

struct Coordinate  {
    let latitude:String // enlem
    let longitude:String // boylam
    
}

/*
print(rest[1]["restaurant"]['cuisines'])
print(rest[1]["restaurant"]['photos_url'])
print(rest[1]["restaurant"]['name'])
print(rest[1]["restaurant"]["location"]['address'])
print(rest[1]["restaurant"]["user_rating"]['votes'])
print(rest[1]["restaurant"]["user_rating"]['rating_text'])
print(rest[1]["restaurant"]['user_rating']["aggregate_rating"])
*/
