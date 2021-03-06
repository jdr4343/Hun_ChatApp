//
//  ConversationTableViewCell.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/08/08.
//

import UIKit
import SDWebImage

class ConversationTableViewCell: UITableViewCell {
    //셀에 등록할 식별자 부여
    static let identifier = "ConversationTableViewCell"
    
    //셀에 부여할 세가지 하위보기를 추가하겠습니다.
    //첫번째는 사용자 이미지 입니다
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    //두번쨰는 이름라벨 입니다.
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        return label
    }()
    //세번쨰는 채팅라벨 입니다.
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
//세가지 기능을 추가 하겠습니다.
    //첫번째 기능은 이니셜라이저에 대한 재정의이고 스타일과 reuseIdentifier를 전달하는 동일한 이니셜라이저를 사용하여 super.init을 호출할것입니다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //두번째는 layoutSubviews를 재정의 하는것 입니다. 이름에서 알 수 있듯이 하위 보기를 배치하는 기능입니다.
    override func layoutSubviews() {
        super.layoutSubviews()
    
        userImageView.frame = CGRect(x: 8, y: 8, width: 80, height: 80)
    
        userNameLabel.frame = CGRect(x: userImageView.right+30,
                                     y: 8,
                                     width: contentView.width - 20 - userImageView.width,
                                     height: (contentView.height-20)/2)
        userMessageLabel.frame = CGRect(x: userImageView.right+30,
                                        y: userNameLabel.bottom+10,
                                        width: contentView.width - 20 - userImageView.width,
                                        height: (contentView.height-20)/2)
    }
    
    
    
    
    //아래의 코드는 모델과 함께 호출 할 것입니다.
    public func configure(with model: Conversation) {
        self.userMessageLabel.text = model.latestMessage.text
        self.userNameLabel.text = model.name
        //SDWebImage구현 기본적으로 이미지의 저장소 경로의 캐싱을 처리함
        let path = "images/\(model.otherUserEmail)_Profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.userImageView.sd_setImage(with: url, completed: nil)
                }
            case .failure(let error):
                print("failed to get image url:\(error)")
            }
        })
    }
}
