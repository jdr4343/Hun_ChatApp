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
// MARK: - Sending messages / conversations
//첫번째 기능은 새 대화를 삽입하는 기능이고 두번쨰 기능은 현재 사용자에 대한 모든대화 목록을 가져오는 것입니다.세번째 기능은 주어진 모든 대화를 리턴 할것입니다.이 모든 것이 정리될수 있도록 아래의 확장자를 추가 하겠습니다.
extension DatabaseManager {
    ///사용자 이메일과 첫 메시지가 새 대화를 생성하고 첫번째 메시지가 전송됩니다
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        //사용자 이메일이 다른 사용자를 나타내도록 완료 핸들러 추가하고 현재 캐시에 이메일이 있는지 확인
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        //데이터베이스 관리자에서 기억할 수 있는 안전한 이메일을 받기
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)
        //현재 사용자 루트 노드에서 자식 노드에게 안전한 이메일을 전달받고 값을 관찰하고 사용자가 없다면 문제발생을 알립니다.
        let ref = database.child("\(safeEmail)")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            //Date날짜 문자열로 변경
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            
            //문자 메시지 가져오기
            var message = ""
            switch firstMessage.kind {
            
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            //firstMessage Id 도 대화 ID에 포함되도록 대화 접두사를 사용
            let conversationId = "conversation_\(firstMessage.messageId)"
           
            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date":dateString,
                    "message": message,
                    "is_read": false
                ]
                
            ]
            
            //사용자를 찾는다면 dictionary를 반환합니다.
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                // 현재사용자에 대한 대화 배열이 존재합니다.
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(conversationID: conversationId, name: name,
                                                    firstMessage: firstMessage,
                                                    completion: completion)
                })
            } else {
                //현재 사용자에대한 배열이 존재 하지 않습니다. 추가합니다.
                userNode["conversations"] = [
                    newConversationData
                ]
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(conversationID: conversationId, name: name,
                                                    firstMessage: firstMessage,
                                                    completion: completion)
                })
            }
            
        })
    }
    //또 다른 대화 노드
    private func finishCreatingConversation(conversationID: String,name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//
//        "id": String
//        "type": text, photo, video
//        "context": String
//        "date": Date()
//        "sender_email": String
        //        "isRead": true/false
        
        //Date날짜 문자열로 변경
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        
        //문자 메시지 가져오기
        var message = ""
        switch firstMessage.kind {
        
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        let currentUserEmail = DatabaseManager .safeEmail(emailAddress: myEmail)
        
        let collectionMessage: [String:Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "context": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "isRead": false,
            "name": name
        ]
        
        let value: [String: Any] = [
            "messages":
                collectionMessage
        ]
        
        
        
        
        //child Node
        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    
    ///전달된 메일이 있는 사용자의 모든 대화를 가져와서 리턴합니다.
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            //값을 압축하기 보다는 평면 매핑 하고 그 안에 있는 사전을 모델로 변환하여 dictionary(노드)에 대한 유효성 검사를 매핑 하겠습니다.
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                    return nil
                }
                //모델을 생성하고 반환 하겠습니다.n
                let latestMessageObject = LatestMessage(date: date,
                                                        text: message,
                                                        isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMessageObject)
            })
            completion(.success(conversations))
        })
    }
    
    ///주어진 대화에 대한 모든 메시지를 가져옵니다
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[String], Error>) -> Void) {
        
    }
    ///대상(사진이나 동영상) 대화와 함께 메시지 보내기
    public func sendMessage(to conversation: String, message: Message, complation: @escaping (Bool) -> Void) {
        
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
