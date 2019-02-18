//
//  ListenViewController.swift
//  ACRCloudDemo_Swift
//
//  Created by Aprcot on 1/21/19.
//  Copyright © 2019 olym.yin. All rights reserved.
//

import UIKit
var artist_name = ""
var song_title = ""
var image_url = ""
var events_Images = [String]()
var events_names = [String]()
var events_dates = [String]()

class ListenViewController: UIViewController,UISearchBarDelegate {
    var _start = false
    var _client: ACRCloudRecognition?
    var my_result = ""
    @IBOutlet weak var back_ground: UIImageView!
    @IBOutlet weak var listen_label: UILabel!
    
    
    @IBOutlet weak var search_bar: UISearchBar!
    
    @IBOutlet weak var listen_button: UIButton!
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(search_bar.text)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(search_bar.text)
    }
    func searchBarSearchButtonClicked(_: UISearchBar){
        print(search_bar.text)
        events_names.removeAll()
        events_Images.removeAll()
        events_dates.removeAll()
        artist_name = search_bar.text!;
        let event_url = "http://app.ticketoui.com/api/events/"+artist_name
        request(url: event_url, request_type: "concert")
        performSegue(withIdentifier: "segue2", sender: self)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artist_name = ""
        search_bar.delegate = self;
        _start = false;
        
        let config = ACRCloudConfig();
        
        config.accessKey = "0a5fd375ac0f2092bf6634bdd066a1fd";
        config.accessSecret = "CHC4jyeJonioKS4Difq2bOnz0RDMRKfbCWVQyNh2";
        config.host = "identify-us-west-2.acrcloud.com";
        //if you want to identify your offline db, set the recMode to "rec_mode_local"
        config.recMode = rec_mode_remote;
        config.requestTimeout = 10;
        config.protocol = "https";
        
        /* used for local model */
        if (config.recMode == rec_mode_local || config.recMode == rec_mode_both) {
            config.homedir = Bundle.main.resourcePath!.appending("/acrcloud_local_db");
        }
        
        /*
        config.stateBlock = {[weak self] state in
            self?.handleState(state!);
        }
        config.volumeBlock = {[weak self] volume in
            //do some animations with volume
            self?.handleVolume(volume);
        };
        config.resultBlock = {[weak self] result, resType in
            self?.handleResult(result!, resType:resType);
        }*/
        config.resultBlock = {[weak self] result, resType in
            self?.handleResult(result!, resType:resType);
        }
        
        self._client = ACRCloudRecognition(config: config);

        // Do any additional setup after loading the view.
    }
    @IBAction func listen_button(_ sender: UIButton) {
        events_names.removeAll()
        events_Images.removeAll()
        events_dates.removeAll()
        image_url=""
        if (_start) {
            return;
        }
        
        self._client?.startRecordRec();
        self._start = true;
        self.listen_label.text = "Listening"
        listen_label.isHidden = false
        back_ground.isHidden = false
        back_ground.loadGif(name: "bg")
        sender.isHidden = true
        
    }
    func handleResult(_ result: String, resType: ACRCloudResultType) -> Void
    {
        
        DispatchQueue.main.async {
            //self.resultView.text = result;
            print(result);
            self.my_result = result
            self._client?.stopRecordRec();
            self._start = false;
            self.ParseJSON()
        }
    }
    func ParseJSON(){
       
        do{
            if let data = my_result.data(using: .utf8)
            {
                let songInfo = try? JSONDecoder().decode(SongInfo.self, from: data)
                print("HOLA")
                var msg = songInfo?.status.msg ?? "No result"
                print(msg)
                if msg=="No result"{
                    print("damn")
                    back_ground.isHidden = true
                    
                    listen_label.text = "Try again"
                    listen_button.isHidden = false
                    listen_button.setImage(UIImage(named: "my_mic"), for: .normal)
                }
                else{
                    artist_name = (songInfo?.metadata.music[0].artists[0].name ?? "")
                    song_title = (songInfo?.metadata.music[0].title ?? "")
                    let artist_url = "http://app.ticketoui.com/api/search_artist/"+artist_name
                    let event_url = "http://app.ticketoui.com/api/events/"+artist_name
                    request(url: artist_url, request_type: "artist")
                    request(url: event_url, request_type: "concert")

                    self.performSegue(withIdentifier: "segue1", sender: self)
                    back_ground.isHidden = true
                    listen_button.isHidden = false
                    listen_button.setImage(UIImage(named: "my_mic"), for: .normal)
                    listen_label.isHidden=true

                    
                }
                
                
                
                
            }
        }catch{
            print(error)
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
                                    image_url = my_url;
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
                                
                                for concert in concertInfo!{
                                    print(concert.title)
                                    
                                    events_Images.append(concert.imageURL)
                                    events_names.append(concert.title)
                                    events_dates.append(concert.startDate)
                                }
                                //self.do_table_refresh()
                                for i in events_dates{
                                    print(i)
                                }
                            }
                            
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
