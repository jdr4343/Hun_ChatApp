//
//  ChatViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/08/06.
//

import UIKit
import MessageKit


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
    
    //Messages 배열 생성
    private var messages = [Message]()
    //Messages Test용 보낸사람 만들기
    private let selfSender = Sender(PhotoURL: "",
                                    senderId: "1",
                                    displayName: "Joe Smith")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //메시지를 추가하기위해 구조체 Message를 연결하여 줍니다.
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hello Yaman")))
        //메시지를 추가하기위해 구조체 Message를 연결하여 줍니다.
         messages.append(Message(sender: selfSender,
                                 messageId: "1",
                                 sentDate: Date(),
                                 kind: .text("12321 Yaman")))
        
        
        view.backgroundColor = .red
        
        //messagesCollectionView에는 할당해야 하는 세 가지 프로토콜이 있습니다. 연결 해준뒤 확장하겠습니다.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

    }
    
}
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    //첫번째 함수는 기본적으로 발신자가 누군지 알고 싶어합니다.이 기능은 프레임워크가 채팅 풍선을 보낸 것처럼 오른쪽에 표시 한거나 받은 것처럼 왼쪽에 채팅 풍선을 표시 하도록 합니다
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
