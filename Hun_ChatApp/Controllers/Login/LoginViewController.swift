//
//  LoginViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
//로그인 뷰 컨트롤러
class LoginViewController: UIViewController {

    //사용자 인터페이스 요소 추가 / 스크롤 뷰 / 이메일,비밀번호를 적을 두개의 텍스트 필드
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true //클립의 균형을 유지
        return scrollView
    }()
    private let emailTextFiled: UITextField = {
        let emailTextFiled = UITextField()
        emailTextFiled.autocapitalizationType = .none //자동 대문자 유형 없음
        emailTextFiled.autocorrectionType = .no //자동 수정 유형 없음
        emailTextFiled.returnKeyType = .continue //사용자가 리턴키를 눌렀을때 다시작성하라고 말하겠습니다.
        emailTextFiled.layer.cornerRadius = 12 //모서리 조절
        emailTextFiled.layer.borderWidth = 1 //테두리 폭
        emailTextFiled.layer.borderColor = UIColor.lightGray.cgColor //테두리 컬러
        emailTextFiled.placeholder = "  Email Adress"
        return emailTextFiled
    }()
    
    
    //상단에 로고 이미지 삽입
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Log in"
//사용자가 등록을 허용하는 버튼 구현 /ResisterViewController로 넘어가게 됨
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapResister))
        //이미지 서브 뷰 추가 / 스크롤 뷰를 추가하고 이메일 필드의 요소를 추가하겠습니다.
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextFiled)
        
    }
    //상위, 하위 LayoutSubview를 재정의 하고 뷰를 호출 / 이미지 뷰를 위한 프레임을 중앙의 정사각형으로 구현 하겠습니다
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 50,
                                 width: size,
                                 height: size)
        //도우미 기능 추가를 해서 뷰 프레임 크기를 수정할 필요가 없도록 하겠습니다.
        //이렇게 몇가지 도우미 기능을 추가 해놓으면 코드도 깔끔해지고 이미지를 수정하기 편해집니다
        emailTextFiled.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width-60,
                                 height: 52)
    }
     
    
    
    @objc private func didTapResister() {
    //private: 클래스로 부터 private임을 의미하는함수 / 본질적으로 사용자가 버튼을 탭하면 ResisterViewController 화면으로 전환되도록 할겁니다 vc가 ResiseterViewController 라고 정의하고 pushViewController로 vc를 호출 할것입니다.
        let vc = ResisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
