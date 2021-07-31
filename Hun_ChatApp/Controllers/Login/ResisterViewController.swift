//
//  RegistarViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
//새 계정을 만드는 컨트롤러
class ResisterViewController: UIViewController {
    //LoginViewController에서 작성한 내용을 ResisterViewController에 복사
    
    //사용자 인터페이스 요소 추가 / 스크롤 뷰 / 이메일,비밀번호를 적을 두개의 텍스트 필드 / 로그인 버튼
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true //클립의 균형을 유지
        return scrollView
    }()
    
    private let emailTextFiled: UITextField = {
        let filed = UITextField()
        filed.autocapitalizationType = .none //자동 대문자 유형 없음
        filed.autocorrectionType = .no //자동 수정 유형 없음
        filed.returnKeyType = .continue //사용자가 리턴키를 눌렀을때 다시작성하라고 말하겠습니다.
        filed.layer.cornerRadius = 12 //모서리 조절
        filed.layer.borderWidth = 1 //테두리 폭
        filed.layer.borderColor = UIColor.lightGray.cgColor //테두리 컬러
        filed.placeholder = "  Email Adress"
        
        //텍스트 필드에 타이핑 되는 글자가 너무 오른쪽에 붙지 않도록 leftView를 이용해 위치를 조정 하고 항상 조정될수있도록  .always를 추가하여 줍니다.
        filed.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        filed.leftViewMode = .always
        filed.backgroundColor = .white
        return filed
    }()
    private let passwordTextFiled: UITextField = {
        let filed = UITextField()
        filed.autocapitalizationType = .none
        filed.autocorrectionType = .no
        filed.returnKeyType = .done
        filed.layer.cornerRadius = 12
        filed.layer.borderWidth = 1
        filed.layer.borderColor = UIColor.lightGray.cgColor
        filed.placeholder = "  password"
        filed.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        filed.leftViewMode = .always
        filed.backgroundColor = .white
        filed.isSecureTextEntry = true // 텍스트가 보이지 않기위해 보안 텍스트 항목 지정
        return filed
    }()
    
    //두 필드의 키보드를 없애기 위해 필드를 두번 복사하여 붙여 넣고 이름을 바꾸겠습니다.
    private let firstNameField: UITextField = {
        let filed = UITextField()
        filed.autocapitalizationType = .none
        filed.autocorrectionType = .no
        filed.returnKeyType = .continue
        filed.layer.cornerRadius = 12
        filed.layer.borderWidth = 1
        filed.layer.borderColor = UIColor.lightGray.cgColor
        filed.placeholder = "  First Name"
        filed.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        filed.leftViewMode = .always
        filed.backgroundColor = .white
        return filed
    }()
    private let lastNameField: UITextField = {
        let filed = UITextField()
        filed.autocapitalizationType = .none
        filed.autocorrectionType = .no
        filed.returnKeyType = .done
        filed.layer.cornerRadius = 12
        filed.layer.borderWidth = 1
        filed.layer.borderColor = UIColor.lightGray.cgColor
        filed.placeholder = "  last Name"
        filed.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        filed.leftViewMode = .always
        filed.backgroundColor = .white
        filed.isSecureTextEntry = true // 텍스트가 보이지 않기위해 보안 텍스트 항목 지정
        return filed
    }()

    
    
    
    
    
    
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Resister", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true //두개의 경계를 마스킹
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    //상단에 로고 이미지 삽입
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
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
        
        //loginButton 연결 대상 추가 / 사용자가 탭을 하면 로그인 기능 호출 / 사용자가 비밀번호 필드에서 리턴을 누르면 자동으로 로그인 기능 호출 /필드가 delgate를 호출 할수 있도록 아래에 extention(LoginViewController확장자)를 생성하여 구현하겠습니다
      registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        emailTextFiled.delegate = self
        passwordTextFiled.delegate = self
        
        
        
        //이미지 서브 뷰 추가 / 스크롤 뷰를 추가하고 사용자 인터페이스 요소를 추가하겠습니다.
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailTextFiled)
        scrollView.addSubview(passwordTextFiled)
        scrollView.addSubview(registerButton)
        
        //Register의 프로필을 클릭하면 아래의 gesture 코드와 상호작용을 활성화
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        //사용자가 프로필 사진을 탭하고 프로필를 변경할수 있도록 addGestureRecognizer을 추가하여 제스처를 추가하겠습니다.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)

    }
    @objc private func didTapChangeProfilePic() {
           print("change Pic called")
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
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+5,
                                     width: scrollView.width-60,
                                     height: 52)
        
        emailTextFiled.frame = CGRect(x: 30,
                                      y: lastNameField.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
        
        passwordTextFiled.frame = CGRect(x: 30,
                                         y: emailTextFiled.bottom+5,
                                         width: scrollView.width-60,
                                         height: 52)
        
      registerButton.frame = CGRect(x: 30,
                                   y: passwordTextFiled.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
    }
    
    
    
    @objc private func didTapResister() {
        //private: 클래스로 부터 private임을 의미하는함수 / 본질적으로 사용자가 버튼을 탭하면 ResisterViewController 화면으로 전환되도록 할겁니다 vc가 ResiseterViewController 라고 정의하고 pushViewController로 vc를 호출 할것입니다.
        let vc = ResisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //사용자가 버튼을 탭하거나 비밀번호를 입력한후 리턴을 누른후 실제로 로그인을 시도하기전에 모든것을 검증하고 로그인을 시도하기 위해 호출되는 함수를 만들겠습니다.
    @objc private func registerButtonTapped() {
        emailTextFiled.resignFirstResponder()
        passwordTextFiled.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        //두 필드에 텍스트가 있는지 확인하고 텍스트가 비어있지 않은지, 암호가 6자 이상인지, 성과 이름이 입력되었는지 확인하는 유효성 검사를 하겠습니다.
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailTextFiled.text,
              let password = passwordTextFiled.text,
              !email.isEmpty, !firstName.isEmpty, !lastName.isEmpty, !password.isEmpty,
              password.count >= 6 else {
            //하나라도 올바르지 않은 경우 되돌아가고 로그인을 시도하기 전에 모든 정보를 입력해야한다고 사용자에게 알리겠습니다.
            alertUserLoginError()
            return
        }
        
        //firebase login
    }
    
    
    func alertUserLoginError() {
        //경고 메시지를 추가하고 사용자가 취소 할수 있게 구현 하겠습니다.
        let alert = UIAlertController(title: "Woops",
                                      message: "please enter all information to create a new account",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    
    }

//Controller를 작성하고 UITextFieldDelegate를 준수하므로 확장은 코드를 분리하는 정말 좋은방법 입니다. 직접 위의 LoginViewController class 코드에 delegate를 추가 할수 있지만 그러면 모든 코드를 같은 블록에 넣어야하니 많이 지저분해집니다.
extension ResisterViewController: UITextFieldDelegate {
    
    //이 함수는 사용자가 계속 버튼이든 이동 버튼이든 반환 키를 눌렀을때 호출됩니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField == emailTextFiled 경우 passwordTextFiled에 포커스를 맞추지 않기를 원하므로 textField가 첫번쨰 응답자가 되고 그렇지 않고
        //textField == emailTextFiled인 경우 로그인 기능을 호출하려고 합니다.
        if textField == emailTextFiled {
            passwordTextFiled.becomeFirstResponder()
            //textField가 첫번쨰 응답자가 되고 그렇지 않으면 텍스트 필드가 이미 비밀번호 필드인 경우 로그인 기능을 사용자가 그런식으로 호출하려고 합니다 계속하기 위해 명시적으로 로그인 버튼을 누를 필요가 없을므로
        }
        else if textField == passwordTextFiled {
          registerButtonTapped()
        }
        return true
    }
}

