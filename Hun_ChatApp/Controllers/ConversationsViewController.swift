//
//  ViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //사용자가 기본값을 기반으로 로그인 했는지 확인하고 로그인 한경우 화면을 유지하고 그렇지 않은경우 로그인 화면 표시
       
        
        
    }
    //뷰가 표시되지 않도록 재정의
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        validateAute()
     
        }
    //회원가입을 한사람이 앱을 열때 로그인을 다시 표시 하지 않게 하기 위해서 앱이 시작될 때 인스턴스화 되는 ConversationsViewController로 이동 해서 코드를 다시 작성하겠습니다.
        //인증 상태 확인, 검증
        private func validateAute() {
            // firebase에서 인증이 되었는지 확인 / 현재 사용자가 nil이라면 LoginViewController를 표시할것입니다. 
            if FirebaseAuth.Auth.auth().currentUser == nil {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                //로그인한 상태가 아니라면 로그인 페이지 등록을 제출하지ㅣ 않고 닫을수 있게 아래로 스와이프 하여 해제 할수 있도록 구현
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: false)
        }
    }


}

