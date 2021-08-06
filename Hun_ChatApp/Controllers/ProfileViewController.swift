//
//  ProfileViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseStorage
//모든 설정이 완료되면 로그인한 사용자가 프로필로 이동 하여 프로필을 관리할수 있도록 프로필 구현
class ProfileViewController: UIViewController {
    
//로그아웃 버튼 구현
    @IBOutlet var tableView: UITableView!
    
    //로그아웃 옵션추가
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 셀 등록
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        //아래에 확장자를 선언하여 delegate와 dataSource를 연결해줍니다.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        //헤더뷰 생성
        tableView.tableHeaderView = createTableHeader()
    }
    func createTableHeader() -> UIView? {
        //해당 사용자 이메일이 저장되어 있지 않으면 테이블에 표시할 프로필 헤더를 만들고 싶지 않습니다.
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        //데이터베이스에게 이메일 전달
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        //모듈을 유지하도록 하는 함수 추가 / 디렉터리 구조
        let path = "images/"+filename
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: self.view.width,
                                              height: 300))
        headerView.backgroundColor = .link
        let imageView = UIImageView(frame: CGRect(x: (headerView .width-150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        headerView.addSubview(imageView)
        return headerView
    }
    
    
    
}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //실수로 로그아웃 할일이 없도록 경고메시지를 출력 하겠습니다.
        let actionSheet = UIAlertController(title: "Are you sure you want to log out?",
                                            message: "See you next time!",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { [weak self] _ in
                                                
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                //로그아웃을 누르면 Firebase 세션에서는 로그아웃 하지만 facebook 버튼은 여전히 로그아웃 입니다.facebook 세션에서도 동시에 로그인 하도록 구현하겠습니다.
                                                FBSDKLoginKit.LoginManager().logOut()
                                                
                                                //do catch블록을 작성하여 오류에 대비하겠습니다.
                                                do {
                                                    try FirebaseAuth.Auth.auth().signOut()
                                                    //사용자가 로그아웃한 후 수행하려는 작업이므로 해당 코드를 복사하여 붙입니다
                                                    
                                                        let vc = LoginViewController()
                                                        let nav = UINavigationController(rootViewController: vc)
                                                        nav.modalPresentationStyle = .fullScreen
                                                        strongSelf.present(nav, animated: true)
                                                }
                                                catch {
                                                    print("Failed log out")
                                                }
                                                
                                            }))
        //액션시트 취소버튼
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //출력
        present(actionSheet, animated: true)
        
    }
}
