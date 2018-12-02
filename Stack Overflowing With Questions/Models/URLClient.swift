//
//  URLClient.swift
//  Stack Overflowing With Questions
//
//  Created by Andrew Olson on 11/30/18.
//  Copyright © 2018 Andrew Olson. All rights reserved.
//

import Foundation
import UIKit

class URLClient {
    static let sharedInstance = URLClient()
    class func getSharedInstance() -> URLClient {
        return sharedInstance
    }
    enum Status: String {
        case success = "success"
        case error = "error"
    }
    
    func performTask(request: URLRequest, completion: @escaping (_ data: Data?,_ status: Status) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(data, Status.error)
                print(error.localizedDescription)
                return
            }
            if data == nil { completion(nil, Status.error); return }
            completion(data, Status.success)
        }
        task.resume()
    }
    
    func parseData(data: Data) -> Any {
        var result: Any!
        do {
            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    class func stackoverflowSearchQuestionsURLFrom(parameters: [String : Any]) -> URL {
        var components = URLComponents()
        components.scheme = SOF.scheme
        components.host = SOF.host
        components.path = SOF.search_path
        components.queryItems = [URLQueryItem]()
        for (key , value) in parameters
        {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url!
    }
    
    class func stackoverflowSearchAnswersURLFrom(question_Id: Int, parameters: [String : Any]) -> URL {
        var components = URLComponents()
        components.scheme = SOF.scheme
        components.host = SOF.host
        components.path = SOF.answer_path + "\(question_Id)" + "/answers"
        components.queryItems = [URLQueryItem]()
        for (key , value) in parameters
        {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url!
    }
    
    class func loadProfileImage(url: URL, completion: @escaping (_ image: UIImage?)->Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil)
                print(error.localizedDescription)
                return
            }
            if data == nil { completion(nil); return}
            let image = UIImage(data: data!)
            completion(image)
        }
        task.resume()
    }
}
