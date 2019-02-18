//
//  LoginViewController.swift
//  ACRCloudDemo_Swift
//
//  Created by Aprcot on 1/23/19.
//  Copyright © 2019 olym.yin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var login_bg: UIImageView!
    @IBAction func Login_button(_ sender: Any) {
        let user_name  = username.text
        let pass_word = password.text
        if user_name == "" || pass_word==""{
            return
            
        }
        else
        {//DoLogin(user_name!,pass_word!)
            
        }
    }
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        blur_bg()
        // Do any additional setup after loading the view.
    }
    
    /*
    func DoLogin(_ user: String,_ psw: String){
        let url = URL(string: "http://app.ticketoui.com/api/login")
        let session = URLSession.shared
       
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let paramToSend = "username="+user+"&password"+psw
        
       request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        
        let tast = session.dataTask(with: url!) { (data,response,error) in
            guard let _:Data = data else
            {
                return
            }
            
            let json:Any?
            do{
                json = try JSONSerialization.jsonObject(with: data!, options:[])
            }
            catch{
                
            }
            guard let server_response = json as?NSDictionary else {
                return
            }
            
            if let data_block = server_response["data"]as? NSDictionary{
                if let session_data = data_block["session"]as? String{
                    let preferences = UserDefaults.standard
                    preferences.set(session_data,forKey:"session")
                    DispatchQueue.main.async {
                        //execute;:self.loginDone
                    }
                }
            }
            
            
        }
        
        
        
    }
   */
    func blur_bg(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = login_bg.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        login_bg.addSubview(blurEffectView)
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
