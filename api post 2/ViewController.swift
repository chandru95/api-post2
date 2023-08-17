//
//  ViewController.swift
//  api post 2
//
//  Created by Admin on 15/08/23.
//

import UIKit

struct root: Codable{
    var status: String?
    var modelList: [String?]
}


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondata?.modelList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"tablecell")
        cell?.textLabel?.text = jsondata?.modelList[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    var jsondata: root?
    

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        response()
        
    }
    
    func response(){
        let url = "https://kuwycredit.in/servlet/rest/ltv/forecast/ltvModels"
        let request = NSMutableURLRequest (url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue ("application/json",forHTTPHeaderField: "Content-Type")
        var params: [String: Any] = ["year":"2020","make":"RENAULT"]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = URLSession.shared.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print("status rode = \(statusCode)")
                }
                if let error = error {
                    print ("\(error)")
                }
                if let data = data {
                    do {
                        let content = try? JSONDecoder().decode(root.self, from: data)
                        self.jsondata = content
                        print (content as Any)
                        
                        DispatchQueue.main.async{
                            self.tableview.reloadData()
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            })
            task.resume()
        }catch _ {
            print("oops something happened buddy")
        }
            
            
    }


}

