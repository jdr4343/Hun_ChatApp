//
//  ChatViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/08/06.
//

import UIKit
import MessageKit
import InputBarAccessoryView
//사용자가 보내기 버튼을 눌렀을 때 입력한 텍스트를 얻을수 있는 방법을 설정하겠습니다.우선은 메시지 키트에 의해 가져온 종속성을 가져오겟습니다.

//두개의 구조체를 생성하고 그 중 하나는 메시지를 나타내고 다른 하나는 발신자를 나타내겠습니다.
    //MessageType을 상속하고 fix를 누릅니다.그러면 순서대로 보낸사람,식별자,보낸날짜,종류가 기입됩니다.
    struct Message: MessageType {
        var sender: SenderType
        var messageId: String
        var sentDate: Date
        var kind: MessageKind
    }
    //똑같이 fix를 눌러주면 발신자 ID와 보여지는 이름이 만들어집니다. 하지만 사진을 갖도록 확장하고 싶음으로 PhotoURL을 추가하겠습니다.
    struct Sender: SenderType {
        var PhotoURL: String
        var senderId: String
        var displayName: String
    }
    

class ChatViewController: MessagesViewController {
    
    //날짜 포맷터 추가
    public static let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    //새로운 대화인지 나타내는 속성 추가
    public var isNewConversation = false
    //채팅 하고 있는 사용자 속성을 상수로 만들겠습니다. 그리고 이메일을 전달해야하는 생성자를 만들 것 입니다.
    public let otherUserEmail: String
    
    //Messages 배열 생성
    private var messages = [Message]()
    
    private var selfSender: Sender? {
        //이메일이 존재하지 않는 경우 이것은 보낸 사람 선택 사항이 될 것입니다. 캐시 및 사용자 기본값에서 보낸사람을 반환하지 않습니다.
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        return Sender(PhotoURL: "",
                      senderId: email,
                      displayName: "Joe Smith")
    }
    
    //이메일을 전달해야하는 생성자를 재정의 하겠습니다.
    init(with email: String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .red
        
        //messagesCollectionView에는 할당해야 하는 세 가지 프로토콜이 있습니다. 연결 해준뒤 확장하겠습니다.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //뷰가 로드 된후 대화 키보드 생성
        messageInputBar.inputTextView.becomeFirstResponder()
    }
}
//messageInputBarDelegate 확장하고 기능 부여
extension ChatViewController: InputBarAccessoryViewDelegate {
    //사용자가 공백만 잇는 메시지를 보낼 수 없도록
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageId() else {
            return
        }
        //보낸 메시지 확인
        print("Sending: \(text)")
        
        //실제로 메시지를 보내는 기능 / 대화가 새로운 경우 사용자가 보내기 버튼을 누르면 새대화가 다른 사용자에게 가는 문자열을 만들겠습니다.
        if isNewConversation {
            //데이터베이스에서 대화를 생성하고
            let message = Message(sender: selfSender,
                                  messageId: messageId,
                                  sentDate: Date(),
                                  kind: .text(text))
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message, completion: { sucess in
                if sucess {
                    print("message sent")
                } else {
                    print("failed to send")
                }
            })
        } else {
            //새 대화가 아니라면 기존 대화 데이터를 추가 하겠습니다.
        }
        
    }
    
    
    //메시지 ID 생성 / 무작위 문자열이어야 합니다.
    private func createMessageId() -> String? {
        //date, otherUserEmail, senderEmail, randomInt / 기본적으로 현재 사용자 이메일이 아닌 경우에는 nil 반환
        
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") else {
            return nil
        }
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)_\(dateString)"
        print("createdd message id \(newIdentifier)")
        return newIdentifier
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    //첫번째 함수는 기본적으로 발신자가 누군지 알고 싶어합니다.이 기능은 프레임워크가 채팅 풍선을 보낸 것처럼 오른쪽에 표시 한거나 받은 것처럼 왼쪽에 채팅 풍선을 표시 하도록 합니다
    func currentSender() -> SenderType {
        //발신자가 nil인 경우 더미 샌더를 리턴하여 좀더 타입세이프티하게 만들겠습니다.
            if let sender = selfSender {
                return sender
            }
            //더미 샌더
            fatalError("Self Sender is nil, email shoukd be cached")
        return Sender(PhotoURL: "", senderId: "77", displayName: "")
        }
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
