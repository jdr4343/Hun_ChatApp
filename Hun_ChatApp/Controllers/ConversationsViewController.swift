//
//  ViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //사용자가 기본값을 기반으로 로그인 했는지 확인하고 로그인 한경우 화면을 유지하고 그렇지 않은경우 로그인 화면 표시
        view.backgroundColor = .red
    }
    //뷰가 표시되지 않도록 재정의
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            //로그인한 상태가 아니라면 로그인 페이지 등록을 제출하지ㅣ 않고 닫을수 있게 아래로 스와이프 하여 해제 할수 있도록 구현
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }


}

