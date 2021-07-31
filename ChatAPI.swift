//
//  ChatAPI.swift
//  Jared Cassoutt
//
//  Created by Jared Cassoutt on 5/6/21.
//

import Foundation

struct ChatAPI {
    
    static func fetchChat(success: @escaping(_ data:ChatInformation)->(),failure:@escaping (_ error:Error)->()) {
        let urlString = "https://www.chatURL.com/AllMessagesAPI/"
        print(urlString)
        //create a url
        if let url = URL(string: urlString) {
            //create URLSession
            let session = URLSession(configuration: .default)
            //give session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error ?? "error")
                    return
                }
                if let safeData = data { 
                    let jsonString = String(data: safeData, encoding: String.Encoding.utf8)
                    let parsed = jsonString!.replacingOccurrences(of: ", NaN", with: "")
                    let jsonData = Data(parsed.utf8)
                    print(jsonData)
                    /*
                    {
                        "messages": [
                            {"user": "jaredcassoutt", "content": "hello, this is a test message", "datetime": "2021-07-10T08:18:44.921Z"}, 
                            {"user": "otheruser", "content": "hello, this is another test message", "datetime": "2021-08-10T08:19:49.921Z"}
                        ]
                    }
                    */
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(ChatInformation.self, from: jsonData)
                        print(decodedData)
                        DispatchQueue.main.async {
                            success(decodedData)
                        }
                    }
                    catch {
                        print(error)
                        failure(error)
                    }
                }
            }
            //Start task
            task.resume()
        }
    }
    
    static func sendMessage(username: String, message: String, success: @escaping(_ data:SentMessageStatus)->(),failure:@escaping (String)->()) {
        print("usernamee: \(username)")
        let url = URL(string: "http://www.chatURL.com/sendingChatAPI/")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "content=\(message)&username=\(username)"
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error ?? "error")
                return
            }
            if let safeData = data {
                // {"respsonse":"successfully registered a new user.","email":"jaredcassoutt@gmail.com","username":"jaredcassoutt"}
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(SentMessageStatus.self, from: safeData)
                    if decodedData.status.contains("Sent message!") {
                        DispatchQueue.main.async {
                            success(decodedData)
                        }
                    }
                    else {
                        failure("Username could not be found. Try loging out and loging back in.")
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        print(error)
                        failure("Cannot connect to the Network right now, check your connection and try again later!")
                    }
                }
            }
        }
        task.resume()
    }
}  
