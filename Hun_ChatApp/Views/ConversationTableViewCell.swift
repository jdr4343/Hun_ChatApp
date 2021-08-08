//
//  ConversationTableViewCell.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/08/08.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
//세가지 기능을 추가 하겠습니다.
    //첫번째 기능은 이니셜라이저에 대한 재정의이고 스타일과 reuseIdentifier를 전달하는 동일한 이니셜라이저를 사용하여 super.init을 호출할것입니다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    //두번째는 layoutSubviews를 재정의 하는것 입니다. 이름에서 알 수 있듯이 하위 보기를 배치하는 기능입니다.
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //아래의 코드는 모델과 함께 호출 할 것입니다.
    public func configure(with model: String) {
        
    }
}
