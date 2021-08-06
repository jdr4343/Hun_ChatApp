//
//  RegistarViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//  먼저 사용자가 있는지 확인하고 스피너를 닫습니다.그런다음 Firebase인증 참조에서 벗어나 사용자를 만든다음 디스크의 위치를 호출합니다. 성공하면 데이터베이스가 표시되는 것이 아니라 디스크가 아닌 데이터베이스에  쓰지 않습니다.

import UIKit
import FirebaseAuth
import JGProgressHUD

//새 계정을 만드는 컨트롤러
class RegisterViewController: UIViewController {
    //LoginViewController에서 작성한 내용을 RegisterViewController에 복사
    
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
        return filed
    }()
    
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
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
        //선택한 이미지가 둥글도록 설정
        imageView.layer.masksToBounds = true
        //이미지가 멋있게 보이도록 테두리 설정
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Log in"
        //사용자가 등록을 허용하는 버튼 구현 /RegisterViewController로 넘어가게 됨
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        //loginButton 연결 대상 추가 / 사용자가 탭을 하면 로그인 기능 호출 / 사용자가 비밀번호 필드에서 리턴을 누르면 자동으로 로그인 기능 호출 /필드가 delgate를 호출 할수 있도록 아래에 extention(LoginViewController확장자)를 생성하여 구현하겠습니다
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        firstNameField.delegate = self
        lastNameField.delegate = self
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
        //        gesture.numberOfTouchesRequired = 1
        //        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)
        
    }
    @objc private func didTapChangeProfilePic() {
        //프로필 탭 액션 / 인포에서 카메라, 사진 권한 허용 /아래에 확장자 설정
        presentPhotoActionSheet()
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
        //선택된 이미지 원으로 설정
        imageView.layer.cornerRadius = imageView.width/2.0
        
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
    
    
    
    @objc private func didTapRegister() {
        //private: 클래스로 부터 private임을 의미하는함수 / 본질적으로 사용자가 버튼을 탭하면 RegisterViewController 화면으로 전환되도록 할겁니다 vc가 ResiseterViewController 라고 정의하고 pushViewController로 vc를 호출 할것입니다.
        let vc = RegisterViewController()
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
        //스피너
        spinner.show(in: view)
        
        //파이어베이스를 여기에서 구축하겠습니다.
        
        //회원가입시 사용자 이메일이 존재하는 경우 에러를 표시할것 입니다.
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            //스피너 제거
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            
            guard !exists else {
                //user already exists
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email addres already exists.")
                return
            }
            // 이메일과 비밀번호를 사용하여 계정을 만들수 있도록 코드를 선언하여 주겠습니다.
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
                //오류가 발생하지 않았는지 확인하기 위해 가드문을 추가 하겠습니다. 오류가 발생하면 프린트를 출력 할것입니다.
                guard authResult != nil, error == nil else {
                    print("Error cureating User")
                    return
                }
                //이렇게 작성해주면 데이터베이스 항목과 언급한 작업이 수행됩니다.
                let chatUser = ChatAppUser(firstName: firstName,
                                           lastName: lastName,
                                           emailAddress: email)
                
                DatabaseManager.shared.insertUser(with: chatUser, complaetion: { success in
                    if success {
                        //upload image
                        guard let image = strongSelf.imageView.image,
                              let data = image.pngData() else {
                            return
                        }
                        //위의 작업을 수행한 후 파일이름 생성
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
                    }
                    //사용자가 Firebase를 이용하여 성공적으로 회원가입을 하고 loginView에서 로그인을 한다면 loginview를 dismiss 하겠습니다 이제 사용자가 로그인 했다는 것을 알고 있기 때문에 더 이상 로그인 화면을 표시하지 않겠습니다. 매번 서명 하는일은 매우 귀찮은 일이니깐요.
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                })
            })
        })
    }
    
    
    func alertUserLoginError(message: String = "please enter all information to create a new account") {
        //경고 메시지를 추가하고 사용자가 취소 할수 있게 구현 하겠습니다.
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    
}

//Controller를 작성하고 UITextFieldDelegate를 준수하므로 확장은 코드를 분리하는 정말 좋은방법 입니다. 직접 위의 LoginViewController class 코드에 delegate를 추가 할수 있지만 그러면 모든 코드를 같은 블록에 넣어야하니 많이 지저분해집니다.
extension RegisterViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField {
            emailTextFiled.becomeFirstResponder()
        }
        else if textField == emailTextFiled {
            passwordTextFiled.becomeFirstResponder()
        }
        else if textField == passwordTextFiled {
            registerButtonTapped()
        }
        
        return true
    }
}

// 사진과 Delegate를 선택하는 것에 관련 코드를 확장자에 구성하여 정리 하겠습니다.
//사용자가 사진을 찍거나 카메라 롤에서 사진을 선택한 결과를 얻을 수 있도록 하는 RegisterViewControllerDelegate를 상속 시켜줍니다.
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //사진찍기 / 사진선택 액션 시트 추가
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        // 버튼 추가
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Phote", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    //사용자가 이미지를 업데이트 할수있게 하기위해서 두개의 함수를 추가하고 ActionSheet에 handler를 버튼에 추가 하겠습니다.
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        // 편집을 허용하고 사용자가 사진을 찍은 후 잘린 사각형을 선택하도록하고 사진을 찍거나 카메라 롤에서 선택할수 있게 하겠습니다.
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    //이미지 선택기(imagePickerController)는 사용자가 사진을 찍거나 사진을 선택할떄 호출됩니다.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        //editedImage를 선택하여 정사각형으로 선택 하겠습니다.또 선탣된 이미지가 선택사항이 되도록 래핑을 해제 하겠습니다
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    
    
    //사용자가 사진을 촬영하거나 사진을 선택 하고 취소 할수 있도록 imagePickerControllerDidCancel 추가합니다
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
