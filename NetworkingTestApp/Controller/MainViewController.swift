//
//  MainViewController.swift
//  NetworkingTestApp
//
//  Created by Admin on 23.09.2020.
//

import UIKit

private let reuseIdentifier = "collectionCell"

enum Actions: String, CaseIterable {
    case getImage = "Get Image"
    case get = "GET"
    case post = "POST"
    case decoded = "Decoded"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case alamofire = "Alamofire"
}

class MainViewController: UICollectionViewController {
    
//    private var actions = ["Get Image", "GET", "POST", "Decoded", "Upload Image"]
    private var actions = Actions.allCases
    private var alert: UIAlertController!
    private var dataProvider = DataProvider()
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifications()

        dataProvider.fileLocation = { (location) in
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
    }

    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alert.view!,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: nil,
                                        attribute: .notAnAttribute,
                                        multiplier: 0,
                                        constant: 170)
        alert.view.addConstraint(height)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let activityRect = CGRect(x: self.alert.view.frame.width / 2 - size.width / 2,
                                      y: self.alert.view.frame.height / 2 - size.height / 2,
                                      width: size.width,
                                      height: size.height)
            let activityIndicator = UIActivityIndicatorView(frame: activityRect)
            activityIndicator.startAnimating()
            
            let progressRect = CGRect(x: 0,
                                      y: self.alert.view.frame.height - 44,
                                      width: self.alert.view.frame.width,
                                      height: 2)
            let progressView = UIProgressView(frame: progressRect)
            progressView.progress = 0
            
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
                
                if progressView.progress == 1 {
                    self.alert.dismiss(animated: false)
                }
            }

            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)

        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("=== prepare")
        if segue.identifier == "getCoursesAlamofire" {
            let courseVC = segue.destination as? CoursesViewController
            courseVC?.fetchDataAlamofire()
        } else if segue.identifier == "getCourses" {
            let courseVC = segue.destination as? CoursesViewController
            courseVC?.fetchData()
        }
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainViewCell
    
        cell.actionLabel.text = actions[indexPath.row].rawValue
        cell.layer.cornerRadius = 10
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        print("=== shouldSelectItemAt")
        let action = actions[indexPath.row]
        
        switch action {
        case .getImage:
            performSegue(withIdentifier: "getPicture", sender: self)
        case .get:
            NetworkManager.getJSON(urlString: "https://jsonplaceholder.typic––ode.com/posts/1/comments") { json in
                print(json)
            }
        case .post:
            NetworkManager.postJSON(urlString: "https://jsonplaceholder.typicode.com/posts")
        case .decoded:
            performSegue(withIdentifier: "getCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(urlString: "https://api.imgur.com/3/image")
        case .downloadFile:
            print("Download File")
            dataProvider.startDownload()
            showAlert()
        case .alamofire:
            performSegue(withIdentifier: "getCoursesAlamofire", sender: self)
            print("Alamofire")
        }
        
        return true
    }
   

}

extension MainViewController {
    
    private func registerForNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Download completed!"
        content.body = "Your backgroung transfer has completed. File path: \(filePath!)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Transfer complete", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
