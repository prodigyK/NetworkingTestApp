//
//  NetworkManager.swift
//  NetworkingTestApp
//
//  Created by Admin on 23.09.2020.
//

import UIKit

class NetworkManager {
    
    private init() {}
    
    static func getJSON(urlString: String, completion: @escaping (Any) -> ()) {
        
        // "https://jsonplaceholder.typicode.com/posts/1/comments"
        
        guard
            let url = URL(string: urlString)
        else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let response = response else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
                completion(json)
            } catch {
                print(error)
            }
            
        }.resume()
 
    }
    
    static func postJSON(urlString: String) {
        
        // "https://jsonplaceholder.typicode.com/posts"
        
        guard
            let url = URL(string: urlString)
        else { return }
        
        let userData = ["Course": "Networking", "Lesson": "Some interesting lesson"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, let response = response else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
            
            
        }.resume()
    }

    static func downloadImage(urlString: String, completion: @escaping (_ image: UIImage) -> ()) {
        
        // https://upload.wikimedia.org/wikipedia/commons/2/2d/Snake_River_%285mb%29.jpg
        
        guard
            let url = URL(string: urlString)
        else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                completion(image)
            }
        
        }.resume()

    }
    
    static func getCourses(urlString: String, completion: @escaping ([Course]) -> ()) {
        
//        https://swiftbook.ru//wp-content/uploads/api/api_courses
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            var courses = [Course]()
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                courses = try decoder.decode([Course].self, from: data)
                
                DispatchQueue.global().async {
                    
                    var tempCourses = [Course]()
                    for course in courses {
                        var newCourse = course
                        guard let url = URL(string: course.imageUrl) else {
                            tempCourses.append(newCourse)
                            continue
                        }
                        let data = try? Data(contentsOf: url)
                        
                        newCourse.imageData = data
                        tempCourses.append(newCourse)
                    }
//                    courses = tempCourses
                    
                    completion(tempCourses)
                    
                }
                
            } catch {
                print("==== Json error")
                print(error)
            }
            
        }.resume()
     
    }
    
    static func uploadImage(urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        let image = UIImage(named: "course-img")!
        guard let imageProperties = ImageProperties(key: "image", image: image) else { return }
        
        let httpHeader = ["Authorization": "Client-ID ee751ddadfdf7b4"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeader
        request.httpBody = imageProperties.data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            guard let response = response else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(" === json ===")
                print(json)
            } catch {
                print(" === error ===")
                print(error)
            }
            
        }.resume()
    }

}
