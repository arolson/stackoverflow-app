//
//  AnswersViewController.swift
//  Stack Overflowing With Questions
//
//  Created by Andrew Olson on 11/30/18.
//  Copyright © 2018 Andrew Olson. All rights reserved.
//

import UIKit
import SwiftSoup
import SCLAlertView

class AnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var displaynameLabel: UILabel!
    @IBOutlet var answersCountLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    var answers: [Answer] = []
    var question: Question!
    var profileImage: UIImage!
    var pageNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        titleLabel.text = question.title
        displaynameLabel.text = question.display_name
        profileImageView.image = profileImage
        answersCountLabel.text = "# \(question.answer_count)"
        bodyLabel.text = parseBody(question.body)
        table.tableFooterView = UIView()
        incrementAndLoadNewAnswers()
    }
    
    func incrementAndLoadNewAnswers() {
        pageNum += 1
        let parameters: [String : Any] = [SOF.order: SOF.desc, SOF.sort : SOF.activity,
                                          SOF.intitle: SOF.swift, SOF.site : SOF.stackoverflow,
                                          SOF.page : pageNum, SOF.filter : SOF.withbody]
        let url = URLClient.stackoverflowSearchAnswersURLFrom(question_Id: question.question_id, parameters: parameters)
        let urlClient = URLClient()
        let request = URLRequest(url: url)
        urlClient.performTask(request: request) { (data, status) in
            if status == URLClient.Status.error {
                self.presentError(message: "Network error\nPlease check your network settings.")
                return
            }
            
            if let response = urlClient.parseData(data: data!) as? [String: Any] {
                self.parseResponse(response: response)
            }
        }
    }
    
    func parseResponse(response: [String : Any]) {
        if let items = response["items"] as? [[String : Any]] {
            if items.count == 0 {
                if question.answer_count > 0 {
                    showNotification(message: "No additional answers found")
                } else {
                    showNotification(message: "No answers found")
                }
                return
            }
            for i in items {
                if let _ = i["owner"] {
                    let answer = Answer(info: i)
                    answers.append(answer)
                }
            }
            performUIUpdatesOnMain {
                self.table.reloadData()
            }
        }
    }
    
    func parseBody(_ body: String) -> String {
        do {
            let doc: Document = try SwiftSoup.parse(body)
             return try doc.text()
        } catch {
            print(error.localizedDescription)
            return body
        }
    }
}

extension AnswersViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "answerCell") as? HTMLViewCell {
            let answer = answers[indexPath.row]
            let display_name = answer.display_name
            let profile_image = answer.profile_image
            let html = parseBody(answer.body)
            cell.configureCell(html: html, displayName: display_name, url: profile_image)
            return cell
        }
        
        return DescriptionCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (answers.count - 1) {
            if indexPath.row < (question.answer_count - 1) {
                incrementAndLoadNewAnswers()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
