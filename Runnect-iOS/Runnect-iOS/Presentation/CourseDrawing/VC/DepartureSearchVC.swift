//
//  DepartureSearchVC.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import UIKit

final class DepartureSearchVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .search).setTextFieldPlaceholder(placeholder: "지역과 키워드 위주로 검색해보세요")
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .g4
    }
    
    private let locationTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
    }
    
    private let emptyDataView = UIView().then {
        let alertImageView = UIImageView()
        alertImageView.image = ImageLiterals.icAlert
    }
    
    // MARK: - View Life Cycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setLayout()
        self.setDelegate()
        self.registerCell()
    }
}

// MARK: - Methods

extension DepartureSearchVC {
    private func setDelegate() {
        self.naviBar.delegate = self
        self.locationTableView.delegate = self
        self.locationTableView.dataSource = self
    }
    
    private func registerCell() {
        self.locationTableView.register(LocationSearchResultTVC.self,
                                        forCellReuseIdentifier: LocationSearchResultTVC.className)
    }
}

// MARK: - UI & Layout

extension DepartureSearchVC {
    private func setUI() {
        view.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, dividerView, locationTableView)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(6)
        }
        
        locationTableView.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom)
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DepartureSearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationSearchResultTVC.className, for: indexPath)
                as? LocationSearchResultTVC
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}

// MARK: - CustomNavigationBarDelegate

extension DepartureSearchVC: CustomNavigationBarDelegate {
    func searchButtonDidTap(text: String) {
        print(text)
        // 서버 통신 구현
    }
}
