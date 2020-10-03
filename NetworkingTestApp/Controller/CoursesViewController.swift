//
//  CoursesViewController.swift
//  NetworkingTestApp
//
//  Created by Admin on 21.09.2020.
//

import UIKit

class CoursesViewController: UIViewController {
    
    private let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses"

    @IBOutlet weak var tableView: UITableView!
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?
    let operation = 1 // 1 - URLSession, 2 - Alamofire
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "description" else { return }
        guard let destVC = segue.destination as? DescriptionViewController else { return }
        destVC.courseName = courseName
        destVC.courseURL = courseURL
    }
    
    func fetchData() {
        
        NetworkManager.getCourses(urlString: url) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchDataAlamofire() {
        
    }
}

extension CoursesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseCell
        let course = courses[indexPath.row]
        
        var image = UIImage()
        if let data = course.imageData {
            image = UIImage(data: data) ?? UIImage()
        }
        cell.updateData(image, course.name, String(course.numberOfLessons), String(course.numberOfTests))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let course = courses[indexPath.row]
        courseName = course.name
        courseURL = course.link

        return indexPath
    }
    
}
