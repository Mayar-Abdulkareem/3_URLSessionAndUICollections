//
//  followerCollectionViewCell.swift
//  03_URLSessionAndUICollection
//
//  Created by FTS on 03/10/2023.
//

import UIKit

struct FollowerCellModel {
    let name: String
    let avatarUrl: String
}

class FollowerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var followerName: UILabel!
    @IBOutlet weak var followerImage: RoundedImageView!
    
    static var id = "followerCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with model: FollowerCellModel) {
        followerName.text = model.name
        Task {
            do {
                try await followerImage.image = ImageUtility.shared.loadImageFromURLAsync(model.avatarUrl)
            } catch {
                print("error")
            }
        }
    }

}
