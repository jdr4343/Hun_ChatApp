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
    //재사용 가능한 속성으로 만들겠습니다.
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
    }
//MARK: - Account Management
extension DatabaseManager {
    //새사용자가 사용하려는 현재 이메일의 유효성 검사 /사용자 이메일이 존재하지 않으면 true를 반환 하고 존재하고 이름을 지정할 수 있으면 false를 반환합니다.
    public func userExists(with emali: String, completion: @escaping((Bool) -> Void)) {
        //이메일을 사용하기 때문에 특수문자 허용
        var safeEmail = emali.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
    
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    
    ///Inserts new user to database
    //삽입된 사용자 함수에 완료 블록을 추가하고 완료 되면 호출자에게 알릴 것이고 데이터베이스에 쓰기가 완료되면 그렇게 할 것 입니다. 그런다음 이미지를 업로드 하고 싶으므로 기능을 추가할 것입니다.
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        //사용자를 구분하는 고유한 사항이 이메일이기떄문에 따로 추가할필요는 없습니다.따라서 동일한 주소를 가진 사용자는 사용자가 될수 없는 것입니다.
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed out write to database")
                completion(false)
                return
            }
            //존재하지 않는 경우 기존 사용자 배열에 대한 참조를 얻으려고 시도 /데이터베이스에서 참조를 얻거나 해당 값을 가져오겠습니다.
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var userCollection = snapshot.value as? [[String: String]] {
                    //사용자를 dictionary에 추가 하겠습니다.
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    
                    userCollection.append(newElement)
                    
                    self.database.child("users").setValue(userCollection, withCompletionBlock: { error, _ in
                        guard  error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    //배열을 만들겠습니다.
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard  error == nil else{
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
            
        })
    }
    //검색 기능 구현
    public func getAllUser(completion: @escaping(Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    //오류 정의
    public enum DatabaseError: Error {
        case failedToFetch
    }
}



//삽입하려는 모든 값을 래핑하는 구조체 / 이메일 주소로 지정하면 비밀번호를 저장할 필요가 없습니다.그리고 암호화 되지 않은 상태로 저장하는 연습하지 않을것이므로 비밀번호는 생략하겠습니다.
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    //safe Email 계산 속성 추가 safe Email이 반환되려면 위의 코드에서 이메일 주소 속성을 가져와서 문자열을 교체하고 반환 하면됩니다.
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    //사진 파일 이름
    var profilePictureFileName: String {
        //images/jdr4343-naver-com_Profile_Picture.png 기본적으로 유형을 이런식으로 만들고 싶습니다.
        return "\(safeEmail)_Profile_picture.png"
    }
}
