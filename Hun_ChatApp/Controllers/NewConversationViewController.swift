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
    //Firebase를 다시 사용하면 비용이 많이 들고 긴로딩 때문에 배열을 생성하고 그배열은 사용자 개체를 가지고 있을것 입니다.
    //처음 결과를 가져올 위치
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    //가져오기가 완료되었는지 여부 확인
    private var hasFetched = false
    
    
    //검색할시 돌아가는 스피너
    private let spinner = JGProgressHUD(style: .dark)
    
    
//사용자가 버튼을 눌러 사용자를 검색 할수 있도록 검색 표시줄 구현
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users."//자리표시자 텍스트
        
        return searchBar
    }()
    
    //개인 테이블 뷰
    private let tableView: UITableView = {
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
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.width/4,
                                     y: (view.height-200)/2,
                                     width: view.width/2,
                                     height: 200 )
    }
    
    
    
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //start conversation
    }
    
}




//검색 표시줄 확장 구현 / 사용자 이름을 입력하고 무언가를 입력한 후 검색이 가능하게 하겠습니다. 검색을 기다리는 동안 스피너가 돌아가고 해당 검색과 일치하는 기록을 띄우겠습니다.
extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //검색창에 검색된 text가져오기 / 사용자가 스페이스바를 누르거나 엔터를 치면 그곳에 글자가 없기 떄문에 비어있는지 확인 /가져오기 기능은 DatabaseManager에서 구현
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
    
        results.removeAll()
        spinner.show(in: view)
        //사용자를 검색하고 테이블 보기를 업데이트 하기
        self.searchUsers(query: text )
    }
    
    
    //텍스트가 있으면 검색에 전달할 함수
    func searchUsers(query: String) {
        //배열에 'firebase' 결과가 있는지 확인
        if hasFetched {
            //있는 경우: 필터
            filterUsers(with: query)
        } else {
            //그렇지 않으면 가져온 후 필터
            DatabaseManager.shared.getAllUser(completion: { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users: \(error)")
                }
            })
        }
        
    }
    //updatr UI: 결과를 표시하거나 결과 레이블을 표시하지 않습니다.
    func filterUsers(with term: String) {
        guard hasFetched else {
            return
        }
        
        self.spinner.dismiss()
        
        let results: [[String: String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            //접두어가 소문자인 경우 반환
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        
        updateUI()
    }
    func updateUI() {
        if results.isEmpty {
            self.noResultLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
