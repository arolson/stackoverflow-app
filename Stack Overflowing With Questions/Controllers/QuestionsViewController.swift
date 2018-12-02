//
//  ViewController.swift
//  Stack Overflowing With Questions
//
//  Created by Andrew Olson on 11/30/18.
//  Copyright © 2018 Andrew Olson. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    var questions: [Question] = []
    var selectedQuestion: Question!
    var selectedImage: UIImage!
    var pageNum = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        incrementAndLoadNewPage()
    }

    func incrementAndLoadNewPage() {
        pageNum += 1
        let parameters: [String : Any] = [SOF.order: SOF.desc, SOF.sort : SOF.activity,
                                          SOF.intitle: SOF.swift, SOF.site : SOF.stackoverflow,
                                          SOF.page : pageNum, SOF.filter : SOF.withbody]
        let url = URLClient.stackoverflowSearchQuestionsURLFrom(parameters: parameters)
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
                showNotification(message: "No new data found")
                return
            }
            for i in items {
                if let _ = i["owner"] {
                    let question = Question(info: i)
                    questions.append(question)
                }
            }
            performUIUpdatesOnMain {
                self.table.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AnswersViewController {
            destination.question = selectedQuestion
            destination.profileImage = selectedImage
        }
    }
}
// MARK: TableView Delegate Methods
extension QuestionsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "dcell") as? DescriptionCell {
            let title = questions[indexPath.row].title
            let display_name = questions[indexPath.row].display_name
            let profile_image = questions[indexPath.row].profile_image
            cell.configureCell(title: title, displayName: display_name, url: profile_image)
            return cell
        }
        
        return DescriptionCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (questions.count - 1) {
            incrementAndLoadNewPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = table.cellForRow(at: indexPath) as? DescriptionCell {
            if let image = cell.profileImageView.image {
                selectedImage = image
            } else {
                selectedImage = UIImage(named: "default_image")
            }
        }
        selectedQuestion = questions[indexPath.row]
        performSegue(withIdentifier: "toAnswersView", sender: nil)
    }
}
