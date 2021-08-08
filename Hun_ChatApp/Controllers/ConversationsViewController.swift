//
//  ViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
import FirebaseAuth
import JGProgressHUD



class ConversationsViewController: UIViewController {
    
    //스피너 인스턴스 생성
    private let spinnet = JGProgressHUD(style: .dark)
    
    //대화 목록 구현
    //테이블 숨김 설정 대화가 있는 경우 테이블 보기를 표시하고 그렇지 않으면 숨겨두겠습니다.
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    //대화가 없을떄 테이블뷰를 숨기고 보여줄 textLabel
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: . medium)
        return label
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //바버튼 아이템
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        //테이블 뷰 하위 뷰 추가
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        setupTableView()
        fetchConversations()
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    //뷰가 표시되지 않도록 재정의
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAute()
        
    }
    //바 버튼 아이템
    @objc private func didTapComposeButton() {
            //사용자가 새 대화를 생성할수 있는 화면 NewConversationViewController로 연결합니다. 바버튼을 누르면 사용자는 새 대화를 생성할것 입니다.
        let vc = NewConversationViewController()
        //새로운 대화 라고 가정
        vc.completion = { [weak self] result in
            print("\(result)")
            self?.creatNewConversation(result: result)
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    //새 대화를 생성하고 위의 결과를 보내서 이결과의 유형을 지정 하겠습니다.
    private func creatNewConversation(result: [String: String]) {
        //이름과 이메일 키를 언래핑 하겠습니다.아래의 코드는 새 대화를 시작하기 위한 최소 요구사항입니다.이것이 필요한 이유는 이메일이 데이터베이스에서 사용되기 떄문입니다.
        guard let name = result["name"], let email = result["email"] else {
            return
        }
        let vc = ChatViewController(with: email)
        //새로운 대화에 참을 전하겠습니다
        vc.isNewConversation = true
        
        //사용자를 식별하기 위해 이름으로 지정
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
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
    //delegate, datasource 할당하고 하위뷰에 추가
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func fetchConversations() {
        tableView.isHidden = false
    }
    
    
    
}
//delegate, datasource 확장
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world "
        //대화를 위한 이셀에 액세서리 유형을 설정하겠습니다. 셀 오른쪽에 표시되는 화살표입니다.
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
   //사용자가 이러한 셀 중 하나를 탭할 때 해당 채팅 화면을 스택으로 푸시하는 코드 작성
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //채팅 화면과 연결
        let vc = ChatViewController(with: "jsdfas@gmail.com")
        //임의 항목
        vc.title = "Jenny Smith"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
