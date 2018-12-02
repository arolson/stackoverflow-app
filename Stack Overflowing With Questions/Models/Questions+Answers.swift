//
//  Questions+Answers.swift
//  Stack Overflowing With Questions
//
//  Created by Andrew Olson on 11/30/18.
//  Copyright © 2018 Andrew Olson. All rights reserved.
//

import Foundation

class Question {
    var display_name = String()
    var answer_count = Int()
    var question_id = Int()
    var title = String()
    var profile_image = String()
    var body = String()
    
    init(info: [String : Any]) {
        
        if let answer_count = info["answer_count"] as? Int {
            self.answer_count = answer_count
        }
        
        if let question_id = info["question_id"] as? Int {
            self.question_id = question_id
        }
        
        if let title = info["title"] as? String {
            self.title = title
        }
        
        if let body = info["body"] as? String {
            self.body = body
        }
        
        if let owner = info["owner"] as? [String : Any] {
            if let display_name = owner["display_name"] as? String {
                self.display_name = display_name
            }
            
            if let profile_image = owner["profile_image"] as? String {
                self.profile_image = profile_image
            }
        }
    }
    init() {
        
    }
}

class Answer {
    var display_name = String()
    var profile_image = String()
    var body = String()
    
    init(info: [String : Any]) {
        if let body = info["body"] as? String {
            self.body = body
        }
        if let owner = info["owner"] as? [String : Any] {
            if let profile_image = owner["profile_image"] as? String {
                self.profile_image = profile_image
            }
            if let display_name = owner["display_name"] as? String {
                self.display_name = display_name
            }
        }
    }
    init() {
        
    }
}
