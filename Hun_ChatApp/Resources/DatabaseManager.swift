//
//  DatabaseManager.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/08/03.
//

import Foundation
import FirebaseDatabase
//데이터베이스를 읽고 쓰는 객체를 만들어 데이터베이스를 읽고 쓸 수 있도록 하겠습니다.각 뷰에서 만들어도 되지만 중복코드가 있을수 있기 때문에 전용 파일을 만들겠습니다.

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    //유저 데이터
    public func insertUser(with user: ChatAppUser) {
        
    }
}
//삽입하려는 모든 값을 래핑하는 구조체
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let password: String
}
