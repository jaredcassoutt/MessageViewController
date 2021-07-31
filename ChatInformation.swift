//
//  ChatInformation.swift
//  Jared Cassoutt
//
//  Created by Jared Cassoutt on 7/21/21.
//

import Foundation

struct ChatInformation: Decodable {
  /*
    {
      "messages": [
        {"user":"jaredcassoutt", "content": "hello, this is a test message", "datetime":"2021-07-10T08:18:44.921Z"}, 
        {"user":"otheruser", "content":"hello, this is another test message", "datetime": "2021-08-10T08:19:49.921Z"}
      ]
    }
    */
    public let messages: [Message]
    
    private enum CodingKeys: String, CodingKey {
        
        case messages = "messages"
    }
}

struct Message: Decodable {
 
    public let user: String
    public let content: String
    public let datetime: String
    
    private enum CodingKeys: String, CodingKey {
        
        case user = "user"
        case content = "content"
        case datetime = "datetime"
        
    }
}


struct SentMessageStatus: Decodable {
    public let status: String
    private enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}
