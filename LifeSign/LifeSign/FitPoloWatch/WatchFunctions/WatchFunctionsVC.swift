//
//  WatchFunctionsVC.swift
//  Core Flow
//
//  Created by Apple on 16/02/2021.
//

import UIKit

class WatchFunctionsVC: UITableViewController {

    let actionArray = [
        "READ PALM BRIGHT", "HEART RATE COLLECTION INTERVAL", "READ SENDETRY REMINDER", "READ USER STEP COUNT", "READ USER SLEEP INTERVALS", "READ USER HEART RATES", "READ USER DATA","READ USER SPORTS DATA" ,"READ USER SPORTS HEART RATE DATA","READ STEPS Interval Data", "READ BATTERY STATE", "READ FIRM VERION STATE", "READ HARDWARE PARAMERTER", "READ LAST CHARGING TIME", "READ UNIT", " READ ANCS CONNECTION STATUS", "READ ANCS OPTION STATUS", "REMIND LAST SCREEN DISPLAY", "READ DIAL STYLE", "READ CUSTOM SCREEN DISPLAY", "READ TIME FORMAT", "READ DATE FORMAT"
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actionArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = actionArray[indexPath.row]
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            MKReadInterface.readPalmingBrighScreen { (data) in
                print("Palm Data Read Successfully")
                if let resp = data as? [String: Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 1:
            MKReadInterface.readHeartBeatAccquisionInterval { (data) in
                print("readHeartBeatAccquisionInterval Data Read Successfully")
                if let resp = data as? [String: Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 2:
            MKReadInterface.readSendatryReminder{ (data) in
                print("readSendatryReminder Data Read Successfully")
                if let resp = data as? [String: Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 3:
            MKReadInterface.readStepData { (data) in
                print("readStepData Data Read Successfully")
                if let resp = data as? [Any] {
                    // print("response: \(resp)")
                    for val in resp {
                        if let v = val as? [String: Any] {
                            print("v: \(v)")
                        }
                    }
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 4:
            MKReadInterface.readSleepData { (data) in
                print("readSleepData Data Read Successfully")
                if let resp = data as? [Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 5:
            MKReadInterface.readHeartData { (data) in
                print("readHeartData Data Read Successfully")
                if let resp = data as? [String: Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 6:
            MKReadInterface.readUserData { (data) in
                print("readUserData Data Read Successfully")
                if let resp = data as? [String: Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 7:
            MKReadInterface.readUserSportsData { (data) in
                print("readUserSportsData Data Read Successfully")
                if let resp = data as? [String: Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        case 8:
            MKReadInterface.readUserSportsHeartRateData { (data) in
                print("readUserSportsHeartRateData Data Read Successfully")
                if let resp = data as? [String: Any] {
                    print("response: \(resp)")
                }
            } failure: { (err) in
                print("*** Faile To read \(err)")
            }
        default:
            return
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
