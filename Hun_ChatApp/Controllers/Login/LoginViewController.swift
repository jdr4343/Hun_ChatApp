//
//  LoginViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import JGProgressHUD

//로그인 뷰 컨트롤러
class LoginViewController: UIViewController {
//스피너
    private let spinner = JGProgressHUD(style: .dark)
    
    
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
    
    private let loginButton: UIButton = {
       let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true //두개의 경계를 마스킹
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    //상단에 로고 이미지 삽입
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //글로벌 스코프로 이동하고 이름이 겹치므로 변경
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        //사용자의 이메일 및 공개 프로필 사용
        button.permissions = ["email", "public_profile"]
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Log in"
//사용자가 Resister을 허용하는 버튼 구현 /ResisterViewController로 넘어가게 됨
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapResister))
        
        //loginButton 연결 대상 추가 / 사용자가 탭을 하면 로그인 기능 호출 / 사용자가 비밀번호 필드에서 리턴을 누르면 자동으로 로그인 기능 호출 /필드가 delgate를 호출 할수 있도록 아래에 extention(LoginViewController확장자)를 생성하여 구현하겠습니다
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        emailTextFiled.delegate = self
        passwordTextFiled.delegate = self
        
        //페이스북 로그인이 성공했는지 확인하고 Facebook에서 요청 하도록 범위 설정 하므로 facebookButton에 대한 델리게이트 설정
        facebookLoginButton.delegate = self
        
        
        //이미지 서브 뷰 추가 / 스크롤 뷰를 추가하고 사용자 인터페이스 요소를 추가하겠습니다.
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextFiled)
        scrollView.addSubview(passwordTextFiled)
        scrollView.addSubview(loginButton)
        
        //페이스북 로그인 버튼 코드 붙여넣고 코드와 글로벌 스코프로 연결하겠습니다.
        //loginButton.center = view.center
        scrollView.addSubview(facebookLoginButton)

        
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
        
        passwordTextFiled.frame = CGRect(x: 30,
                                      y: emailTextFiled.bottom+5,
                                      width: scrollView.width-60,
                                      height: 52)
        
        loginButton.frame = CGRect(x: 30,
                                   y: passwordTextFiled.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        
        facebookLoginButton.frame = CGRect(x: 30,
                                           y: loginButton.bottom+10,
                                           width: scrollView.width-60,
                                           height: 52)
        facebookLoginButton.frame.origin.y = loginButton.bottom+10
    }
    
    
    
    @objc private func didTapResister() {
    //private: 클래스로 부터 private임을 의미하는함수 / 본질적으로 사용자가 버튼을 탭하면 ResisterViewController 화면으로 전환되도록 할겁니다 vc가 ResiseterViewController 라고 정의하고 pushViewController로 vc를 호출 할것입니다.
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //사용자가 버튼을 탭하거나 비밀번호를 입력한후 리턴을 누른후 실제로 로그인을 시도하기전에 모든것을 검증하고 로그인을 시도하기 위해 호출되는 함수를 만들겠습니다.
    @objc private func loginButtonTapped() {
        //로그인 버튼을 누르면 키보드가 제거 되도록 구현
        emailTextFiled.resignFirstResponder()
        passwordTextFiled.resignFirstResponder()
        
        
        //두 필드에 텍스트가 있는지 확인하고 텍스트가 비어있지 않은지, 암호가 6자 이상인지 확인하는 유효성 검사를 하겠습니다.
        guard let email = emailTextFiled.text, let password = passwordTextFiled.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            //하나라도 올바르지 않은 경우 되돌아가고 로그인을 시도하기 전에 모든 정보를 입력해야한다고 사용자에게 알리겠습니다.
            alertUserLoginError()
            return
        }
        //로그인 버튼을 탭한 firebase 작업을 수행하는 기능을 만들겠습니다.그리고 firebase 인증시도에서 스피너를 제거하겠습니다.
        spinner.show(in: view)
        
        //파이어 베이스 로그인 구현 / 사용자가 버튼을 탭하면 로그인 기능에서 FirebaseAuth.Auth.auth 라고 로그인 하도록 하고 이메일과 패스워드가 맞는지 확인하겠습니다.
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            
            guard let strongSelf = self else {
                return
            }
            //firebase 인증시도에서 스피너를 제거하겠습니다.
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            
            
            
            //오류가 발생하지 않았는지 확인하기 위해 가드문을 추가 하겠습니다. 오류가 발생하면 프린트를 출력 할것입니다.
            guard let result = authResult, error == nil else {
                print("Error cureating User")
                return
            }
            
            //사용자가 로그인하고 탐색 컨트롤러를 해제 하므로 해제 하기전에 사용자 이메일 주소를 저장하겠습니다. 사용자 이메일을 저장하는 이유는 저장소 버킷이 이미지에 대해 사용할수 있는 형식을 가지고 있기 때문입니다. 사용자에 대한 이미지를 쿼리하기 위한 이메일 입니다.
            let user = result.user
            UserDefaults.standard.set(email, forKey: "email")
            
            print("Logged IN User:\(user)")
            //사용자가 Firebase를 이용하여 성공적으로 회원가입을 하고 loginView에서 로그인을 한다면 loginview를 dismiss 하겠습니다 이제 사용자가 로그인 했다는 것을 알고 있기 때문에 더 이상 로그인 화면을 표시하지 않겠습니다. 매번 서명 하는일은 매우 귀찮은 일이니깐요.
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    
    func alertUserLoginError() {
        //경고 메시지를 추가하고 사용자가 취소 할수 있게 구현 하겠습니다.
        let alert = UIAlertController(title: "Woops",
                                      message: "please enter all information to log in",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    
}
//Controller를 작성하고 UITextFieldDelegate를 준수하므로 확장은 코드를 분리하는 정말 좋은방법 입니다. 직접 위의 LoginViewController class 코드에 delegate를 추가 할수 있지만 그러면 모든 코드를 같은 블록에 넣어야하니 많이 지저분해집니다.
extension LoginViewController: UITextFieldDelegate {
    
    //이 함수는 사용자가 계속 버튼이든 이동 버튼이든 반환 키를 눌렀을때 호출됩니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField == emailTextFiled 경우 passwordTextFiled에 포커스를 맞추지 않기를 원하므로 textField가 첫번쨰 응답자가 되고 그렇지 않고
        //textField == emailTextFiled인 경우 로그인 기능을 호출하려고 합니다.
        if textField == emailTextFiled {
            passwordTextFiled.becomeFirstResponder()
            //textField가 첫번쨰 응답자가 되고 그렇지 않으면 텍스트 필드가 이미 비밀번호 필드인 경우 로그인 기능을 사용자가 그런식으로 호출하려고 합니다 계속하기 위해 명시적으로 로그인 버튼을 누를 필요가 없을므로
        }
        else if textField == passwordTextFiled {
            loginButtonTapped()
        }
        return true
    }
}
//facebookLoginButton에 델리게이트를 추가하기 위해서 확장자를 선언하고 필수기능선언
extension LoginViewController: LoginButtonDelegate {
    //facebook 사용자가 로긍니 한 것을 감지하면 로그인 버튼을 탭하여 로그아웃하면 자동으로 로그아웃을 표시하도록 버튼이 업데이트 됩니다. 이 앱의 경우 뷰 컨트롤러에 로그인을 표시하지 않기 때문에 적용할수 없습니다. 필수메소드이기때문에 코드만 남겨두고 아무 작업도 하지 않을것입니다
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        //LoginManagerLoginResult를 클릭하여 확인해보면 클래스이고 취소 토큰이 있으므로 토큰을 가져오면 됩니다.
        //여기에 토큰이 있으면 자격을 생성하고 이를 firebase에 전달 합니다.
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        //페이스북 데이터 요청 /이메일 /이름
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name, picture.type(large)"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        facebookRequest.start(completion: { _, result, error in
            guard let result = result as? [String: Any],
                  error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            
            print(result)
            
            //데이터 가져오기
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String: Any],
                  let data = picture["data"] as? [String: Any],
                  let pictureUrl = data["url"] as? String else {
                print("Faield to get email and name from fb result")
                return
            }
            
            UserDefaults.standard.set(email, forKey: "email")
//            //받아온 데이터 ["name": 아무개, "id": 989961108211470, "email": 000000@naver.com]
            //외국인이라면 이코드 사용 나중에 두개를 한꺼번에 구성하는 코드를 짜봐야 할듯함.
//            let nameComponents = userName.components(separatedBy: " ")
//            guard nameComponents.count == 2 else {
//                return
//            }
//
//            let firstName = nameComponents[0]
//            let lastName = nameComponents[1]

            //facebook에서 요청한 데이터 성과 이름 이메일로 추출
            DatabaseManager.shared.userExists(with: email, completion: { exists in
                if !exists {
                    let chatUser = ChatAppUser(firstName: userName, lastName: "", emailAddress: email)
                     
                    DatabaseManager.shared.insertUser(with: chatUser, complaetion: { success in
                        if success {
                            
                            guard let url = URL(string: pictureUrl) else {
                                return
                            }
                            
                            print("Downloading data from facebook image")
                            
                            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                                guard let data = data else {
                                    print("Failed to get data from facebook")
                                    return
                                }
                                print("get data feom facebook, uploading...")
                                //upload image
                                let fileName = chatUser.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                                    //결과에 실패 또는 성공이 있기 때문에 간단히 전환할수 있게 하기위해 스위치문 추가 /성공의 경우 다운로드 Url을 가지게 되고 오류라면 오류를 출력 할것입니다. 다운로드 하면 업로드 하고 다운로드 URL을 다시 제공하여 캐시에 저장 하겠습니다
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storage manager error: \(error)")
                                    }

                                })
                            }).resume()//중요
                            
                        }
                    })
                }
            })
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }
                //클로저에서 가드 결과가 인증 결과와 같고 오류가 nil이면 출력합니다.
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed")
                    }
                    //실제로 계시할수 있는 액세스 추가
                    
                    return
                }
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
        
    }
}

