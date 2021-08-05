//
//  NewConversationViewController.swift
//  Hun_ChatApp
//
//  Created by 신지훈 on 2021/07/31.
//

import UIKit
import JGProgressHUD
//사용자가 새 대화를 생성할수 있는 화면
//채팅하고 싶은 다른 사용자를 검색하고 해당 사용자 존재하는 확인 할수 있습니다.
class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD()
    
//사용자가 버튼을 눌러 사용자를 검색 할수 있도록 검색 표시줄 구현
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users."//자리표시자 텍스트
        
        return searchBar
    }()
    
    //개인 테이블 뷰
    private let tavleView: UITableView = {
       let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    //테이블이 hidden 되어있고 사용자가 검색하는 항목에 대해 찾은 사용자가 없는지 표시하는 레이블을 만들것 입니다.
    private let noResultLabel: UILabel = {
       let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = .white
        //검색 표시줄과 동일한 상단 항목이 수행하는 작업은 탐색표시줄이 명력하는 대로 표시줄을 배치하므로 수동으로 프레임을 지정하고 위치를 할당해야 합니다.
        navigationController?.navigationBar.topItem?.titleView = searchBar
        //취소 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        //기본적으로 키보드를 검색 표시줄에 띄우겠습니다.
        searchBar.becomeFirstResponder()
        
    }
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
//검색 표시줄 확장 구현
extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

