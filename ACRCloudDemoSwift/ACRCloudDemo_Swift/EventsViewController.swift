//
//  EventsViewController.swift
//  ACRCloudDemo_Swift
//
//  Created by Aprcot on 2/14/19.
//  Copyright © 2019 olym.yin. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//    var events_Images = [String]()
//    var events_names = [String]()
//    var events_dates = [String]()
    
   
    @IBOutlet weak var table_view: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events_names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellllllllllll")

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)as! EventsTableViewCell
        cell.event_name.text = events_names[indexPath.row]
        cell.event_date.text = events_dates[indexPath.row]
        let imgURL = events_Images[indexPath.row]
        if imgURL == ""{
            cell.event_image.image = UIImage(named: "image-1")
        }else{
            let imageURL = NSURL(string: events_Images[indexPath.row])
            
            let data = NSData(contentsOf: (imageURL! as URL))
            cell.event_image.image = UIImage(data: data! as Data)
        }
        
        return cell
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //artist_name = "adele"
        //let event_url = "http://app.ticketoui.com/api/events/"+artist_name
        //request(url: event_url)
        table_view.delegate = self;
        table_view.dataSource = self;
        while(events_names.count == 0){
            print("waiting")
        }
        do_table_refresh()
        // Do any additional setup after loading the view.
    }
    func do_table_refresh(){
        DispatchQueue.main.async {
            
            self.table_view.reloadData()
        }
        
    }
    func request(url: String){
        let request_url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print(request_url)
        guard let url = URL(string: request_url ?? url)else {
            print("hola")
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url){(data,response,error)in
            if error != nil{
                
                print("error")
            }
            else{
                if let content = data{
                    do{
                    let concertInfo = try? JSONDecoder().decode(ConcertInfo.self, from: content)
                    print (concertInfo?.count)
                    if concertInfo?.isEmpty != true{
//                    for concert in concertInfo!{
//                        print(concert.title)
//                        self.events_Images.append(concert.imageURL)
//                        self.events_names.append(concert.title)
//                        self.events_dates.append(concert.startDate)
//                                }
//                        self.do_table_refresh()
//                        for i in self.events_dates{ print(i) }
                       }
                }catch{
                        
                    }
                }
            }
            
        }
        task.resume()

        
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
