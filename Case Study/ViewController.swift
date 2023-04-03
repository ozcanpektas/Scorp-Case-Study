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
    var isPaginating = false

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
        if (people.count > indexPath.row) {
            cell.textLabel?.text = "\(people[indexPath.row].fullName) (\(people[indexPath.row].id))"
        }
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            fetchData()
            isPaginating = true
        }
        tableView.tableFooterView = createFooterSpinner()
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
        self.people.removeAll()
        fetchData()
    }
    
    func fetchData() {
        if isPaginating {
           return
        }
        
        DataSource.fetch(next: self.fNext) { response, error in
            if let _ = response {
                self.fNext = response?.next
                response?.people.forEach({ person in
                    if !self.isIdDuplicate(person: person) {
                        self.people.append(person)
                    }
                })
                
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
                
                if !self.people.isEmpty {
                    self.infoLabel.isHidden = true
                }
                
            }
            
            if let err = error {
                print("\(err.errorDescription)")
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
            }
            
            if self.isPaginating {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                }
                self.isPaginating = false
            }
        }
        
    }

    private func createFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    private func isIdDuplicate(person: Person) -> Bool {
        for element in people {
            if element.id == person.id {
                return true
            }
        }
        return false
    }
}

