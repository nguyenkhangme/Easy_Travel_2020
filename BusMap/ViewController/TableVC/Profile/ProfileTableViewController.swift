//
//  ProfileTableViewController.swift
//  GoogleLogin
//
//  Created by user on 6/11/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
        
    var data = ["Sign Out","Google Maps", "MapBox"]
    
    var optionViewModels = [OptionViewModel]()
    
    var isMapBox: Bool = true
    
    var handleMenuOptionDelegate:HandleMenuOption? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        creatOption()
    }

    // MARK: - Table view data source

    func creatOption(){
        let signOut = Option(title: "Sign Out")
        //let GoogleMaps = Option(title: "Google Map", isMapBox: true)
        let MapBox = Option(title: "Map Box", isMapBox: self.isMapBox)
        let optionViewModel1 = OptionViewModel(Option: signOut)
        //let optionViewModel2 = OptionViewModel(Option: GoogleMaps)

        let optionViewModel3 = OptionViewModel(Option: MapBox)

        optionViewModels.append(optionViewModel1)
        //optionViewModels.append(optionViewModel2)
        optionViewModels.append(optionViewModel3)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return optionViewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ProfileCell"

        var myCell: ProfileTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ProfileTableViewCell

        if myCell == nil {
            tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            myCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ProfileTableViewCell
        }
        

        
        myCell.optionViewModel = optionViewModels[indexPath.row]
        
                
                

                
                return myCell
    }
    
    //MARK: didSelectRowAt
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        handleMenuOptionDelegate?.passDataFromMenu(option: optionViewModels[indexPath.row].title)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
