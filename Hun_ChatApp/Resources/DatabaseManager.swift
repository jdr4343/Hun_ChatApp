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
    
    }
//MARK: - Account Management
extension DatabaseManager {
    //새사용자가 사용하려는 현재 이메일의 유효성 검사 /사용자 이메일이 존재하지 않으면 true를 반환 하고 존재하고 이름을 지정할 수 있으면 false를 반환합니다.
    public func userExists(with emali: String, completion: @escaping((Bool) -> Void)) {
        
        database.child(emali).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    
    ///Inserts new user to database
    public func insertUser(with user: ChatAppUser) {
        //사용자를 구분하는 고유한 사항이 이메일이기떄문에 따로 추가할필요는 없습니다.따라서 동일한 주소를 가진 사용자는 사용자가 될수 없는 것입니다.
        database.child(user.emailAddress).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}

//삽입하려는 모든 값을 래핑하는 구조체 / 이메일 주소로 지정하면 비밀번호를 저장할 필요가 없습니다.그리고 암호화 되지 않은 상태로 저장하는 연습고 하지 않을것이므로 비밀번호는 생략하겠습니다.
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
  
}
