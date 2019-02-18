//
//  ResultViewController.swift
//  ACRCloudDemo_Swift
//
//  Created by Aprcot on 1/20/19.
//  Copyright © 2019 olym.yin. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var events_label: UILabel!
    @IBOutlet weak var more_button: UIButton!
    @IBAction func more_button(_ sender: Any) {
        performSegue(withIdentifier: "segue3", sender: UIButton.self)
        
    }
    
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var song_label: UILabel!
    @IBOutlet weak var artist_label: UILabel!
    @IBOutlet weak var image_bg: UIImageView!
    @IBOutlet weak var play_button: UIButton!
    
    @IBOutlet weak var image_front: UIImageView!
    
//    var events_Images = [String]()
//    var events_names = [String]()
//    var events_dates = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if events_names.count > 0{
            return 1}
        else{
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as! ResultTableViewCell
        if events_names.count > 0 {
        cell.event_name.text = events_names[0]
        cell.event_date.text = events_dates[0]
        let imgURL = events_Images[0]
        if imgURL == ""{
            cell.event_image.image = UIImage(named: "image-1")
        }else{
            let imageURL = NSURL(string: events_Images[indexPath.row])

            let data = NSData(contentsOf: (imageURL! as URL))
            cell.event_image.image = UIImage(data: data! as Data)
        }
        }
        return cell
    }
    func circle_button(){
        
        play_button.layer.cornerRadius = 0.5 * play_button.bounds.size.width
        play_button.clipsToBounds = true
    }
    func blur_bg(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = image_bg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        image_bg.addSubview(blurEffectView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //artist_name = "Nolwenn Leroy "
        let artist_url = "http://app.ticketoui.com/api/search_artist/"+artist_name
        let event_url = "http://app.ticketoui.com/api/events/"+artist_name
        artist_label.text = artist_name
        song_label.text = song_title
        blur_bg()
        circle_button()
        let start = CACurrentMediaTime()
        var flag1 = true;
        while(image_url==""){
            let end = CACurrentMediaTime()
            
            let difference = end - start
            if difference > 10{
                print(difference)

                flag1 = false
                break;
            }
            
            print("waiting")
        }
        
        let img_url = URL(string: image_url)
        if flag1 == true{
        downloadImage(from: img_url!)
            
        }
        else{
            image_bg.image=UIImage(named: "image-1")
            image_front.image=UIImage(named: "image-1")
        }
        
        let start2 = CACurrentMediaTime()
        var flag2 = true;
        while(events_names.count==0){
            print("waiting22")
            let end2 = CACurrentMediaTime()
            let difference2 = end2-start2
            if(difference2 > 10)
            {
                print(difference2)
                flag2 = false
                break;
            }
        }
        
        
        
        if flag2 == true{
            print("hihihi")
            table_view.isHidden = false;
            more_button.isHidden = false;
            events_label.isHidden = false;
            
            do_table_refresh()}
        else{
            table_view.isHidden = true;
            more_button.isHidden = true;
            events_label.isHidden = true;
            
        }
       // request_artist()
        //request(url: artist_url,request_type: "artist")

        //request(url: event_url,request_type: "concert")
        
       
        
    }
    func do_table_refresh(){
        DispatchQueue.main.async {
        self.table_view.reloadData()
        }

    }
    func request(url: String ,request_type: String){
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
                    
                        
                        print("myJson")
                        if request_type == "artist"{
                        let artistInfo = try? JSONDecoder().decode(ArtistInfo.self, from: content)
                        
                    
                        if artistInfo?.isEmpty != true{
                            if let my_url = artistInfo?[0].images[0].url{
                                if let url = URL(string: my_url) {
                                    self.image_bg.contentMode = .scaleToFill
                                    self.image_front.contentMode = .scaleToFill
                                    self.downloadImage(from: url)
                                }
                            }
                            else {
                                print("no url")
                            }
                        }else{
                            print("empty")
                        }
                        }
                        else if request_type == "concert"{
                            let concertInfo = try? JSONDecoder().decode(ConcertInfo.self, from: content)
                            print (concertInfo?.count)
                            if concertInfo?.isEmpty != true{
//                                for concert in concertInfo!{
//                                    print(concert.title)
//                              self.events_Images.append(concert.imageURL)
//                              self.events_names.append(concert.title)
//                              self.events_dates.append(concert.startDate)
//                            }
//                                self.do_table_refresh()
//                                for i in self.events_dates{
//                                    print(i)
//                                }
                            }
                            
                        }
                    }catch{
                        
                    }
                }
            }
            
        }
        
        
        task.resume()
        
        
    }
        
    
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image_bg.image = UIImage(data: data)
                self.image_front.image = UIImage(data: data)
                print("image should show")

            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
   /* func circle_image(){
        artist_image.layer.borderWidth = 1
        artist_image.layer.masksToBounds = false
        artist_image
            .layer.borderColor = UIColor.black.cgColor
        artist_image.layer.cornerRadius = artist_image.frame.height/2
        artist_image.clipsToBounds = true
    }*/
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




