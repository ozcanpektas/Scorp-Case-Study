//
//  ViewController.swift
//  Case Study
//
//  Created by Yusuf Pektaş on 31.03.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var people = [Person]()
    var refreshController = UIRefreshControl()
    var fNext: String? = nil

    lazy var infoLabel: UILabel = {
        var _infoLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        _infoLabel.text = "No one here :)"
        _infoLabel.isHidden = false
        _infoLabel.textAlignment = .center
        return _infoLabel
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(people[indexPath.row].fullName)- (\(people[indexPath.row].id)) --- \(indexPath.row+1)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.conü.height - 100 )
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(infoLabel)
        infoLabel.center = self.view.center
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshController.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshController)
       
    }
    
    @objc func refreshData() {
        
        DataSource.fetch(next: self.fNext) { response, error in
            if let _ = response {
                print("------------- sonraki responsee geldiiii \(response?.people.count!) --------------")
                response?.people.forEach({ person in
                    self.people.append(person)
                })
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
                
                if !self.people.isEmpty {
                    self.infoLabel.isHidden = true
                }
                
            }
            if let _ = error {
                print("errrorrr happened")
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
            }
        }
        
    }

    
}

