//
//  ActivityRecordInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit

import SnapKit
import Then
import Moya

final class ActivityRecordInfoVC: UIViewController {
    
    // MARK: - Properties
    
    private var recordProvider = Providers.recordProvider
    
    private var activityRecordList = [ActivityRecord]()
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("활동 기록")
    
    private lazy var activityRecordTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        setDelegate()
        register()
        getActivityRecordInfo()
    }
}

// MARK: - Methods

extension ActivityRecordInfoVC {
    private func setData(activityRecordList: [ActivityRecord]) {
        self.activityRecordList = activityRecordList
        activityRecordTableView.reloadData()
    }
    
    private func setDelegate() {
        self.activityRecordTableView.delegate = self
        self.activityRecordTableView.dataSource = self
    }
    
    private func register() {
        self.activityRecordTableView.register(ActivityRecordInfoTVC.self, forCellReuseIdentifier: ActivityRecordInfoTVC.className)
    }
}

extension ActivityRecordInfoVC {
    
    // MARK: - Layout Helpers
    
    private func setNavigationBar() {
        view.addSubview(navibar)
        
        navibar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
    }
    
    private func setUI() {
        view.backgroundColor = .w1
        activityRecordTableView.backgroundColor = .w1
    }
    
    private func setLayout() {
        view.addSubview(activityRecordTableView)
        
        activityRecordTableView.snp.makeConstraints { make in
            make.top.equalTo(navibar.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension ActivityRecordInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 193
    }
}

// MARK: - UITableViewDataSource

extension ActivityRecordInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityRecordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let activityRecordCell = tableView.dequeueReusableCell(withIdentifier: ActivityRecordInfoTVC.className, for: indexPath) as? ActivityRecordInfoTVC else { return UITableViewCell()}
        activityRecordCell.selectionStyle = .none
        activityRecordCell.setData(model: activityRecordList[indexPath.item])
        return activityRecordCell
    }
}

// MARK: - Network

extension ActivityRecordInfoVC {
    func getActivityRecordInfo() {
        LoadingIndicator.showLoading()
        recordProvider.request(.getActivityRecordInfo) { [weak self] response in
            LoadingIndicator.hideLoading()
            guard let self = self else { return }
            switch response {
            case .success(let result):
                let status = result.statusCode
                if 200..<300 ~= status {
                    do {
                        let responseDto = try result.map(BaseResponse<ActivityRecordInfoDto>.self)
                        guard let data = responseDto.data else { return }
                        self.setData(activityRecordList: data.records)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("400 error")
                    self.showNetworkFailureToast()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.showNetworkFailureToast()
            }
        }
    }
}
