//
//  NewConversationCell.swift
//  ChattingDemo
//
//  Created by 陳冠甫 on 2022/5/12.
//

import Foundation
import SDWebImage

class NewConversationCell: UITableViewCell {
    
    static let identifier = "NewConversationCell"
    
    private let userImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 35
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImgView)
        contentView.addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImgView.frame = CGRect(x: 10, y: 10, width: 70, height: 70)
        
        userNameLabel.frame = CGRect(x: userImgView.right + 10,
                                     y: 20,
                                     width: contentView.width - 20 - userImgView.width,
                                     height: 50)
    }
    
    public func configure(with model: SearchResult) {
        self.userNameLabel.text = model.name
        
        let path  = "images/\(model.email)_profile_pic.png"
        StorageManager.shared.downloadURL(for: path) { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImgView.sd_setImage(with: url)
                }
            case .failure(let error):
                print("failed to get img url: \(error)")
            }
        }
    }
}
