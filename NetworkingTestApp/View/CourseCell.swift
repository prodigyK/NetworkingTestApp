//
//  CourseCell.swift
//  NetworkingTestApp
//
//  Created by Admin on 21.09.2020.
//

import UIKit

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var lessonNumbers: UILabel!
    @IBOutlet weak var someLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    
    func updateData(_ image: UIImage, _ name: String, _ lessons: String, _ some: String) {
        courseImageView.image = image
        courseNameLabel.text = name
        lessonNumbers.text = lessons
        someLabel.text = some
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
