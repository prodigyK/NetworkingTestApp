//
//  ImageViewController.swift
//  NetworkingTestApp
//
//  Created by Konstantin Petkov on 20.09.2020.
//

import UIKit

private let url = "https://upload.wikimedia.org/wikipedia/commons/2/2d/Snake_River_%285mb%29.jpg"

class ImageViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        NetworkManager.downloadImage(urlString: url) {[weak self] (image) in
            self?.imageView.image = image
            self?.activityIndicator.stopAnimating()

        }
    }
    
    


}
