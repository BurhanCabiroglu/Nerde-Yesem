//
//  HomeViewController.swift
//  nerdeyesem
//
//  Created by Burhan Cabiroğlu on 1.10.2020.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        singleton.usersDatabase?.document(singleton.user!.userId).setData(singleton.user!.toJson() as! [String : Any])
        
        tableView.delegate=self;
        tableView.dataSource=self
       
       
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singleton.user!.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=UITableViewCell()
        
        if(!singleton.user!.places.isEmpty){
            cell.textLabel?.text=singleton.user?.places[indexPath.row]
        }
        
        return cell;
    }
  

}
