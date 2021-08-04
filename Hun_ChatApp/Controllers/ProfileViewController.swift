//
//  ProfileViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
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
