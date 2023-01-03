//
//  ActivityRecordInfoVC.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit
import SnapKit
import Then

final class ActivityRecordInfoVC: UIViewController {
    
    // MARK: - Variables
    
    var activityRecordList: [ActivityRecordInfoModel] = [
        ActivityRecordInfoModel(title: "석촌 호수 한 바퀴", place: "서울시 강동구", date: "2022.12.28", distance: "4.01 km", runningTime: "0:27:36", averagePace: "6'45\""),
        ActivityRecordInfoModel(title: "석촌 호수 한 바퀴", place: "서울시 강동구", date: "2022.12.28", distance: "4.01 km", runningTime: "0:27:36", averagePace: "6'45\""),
        ActivityRecordInfoModel(title: "석촌 호수 한 바퀴", place: "서울시 강동구", date: "2022.12.28", distance: "4.01 km", runningTime: "0:27:36", averagePace: "6'45\""),
        ActivityRecordInfoModel(title: "석촌 호수 한 바퀴", place: "서울시 강동구", date: "2022.12.28", distance: "4.01 km", runningTime: "0:27:36", averagePace: "6'45\""),
        ActivityRecordInfoModel(title: "석촌 호수 한 바퀴", place: "서울시 강동구", date: "2022.12.28", distance: "4.01 km", runningTime: "0:27:36", averagePace: "6'45\""),
        ActivityRecordInfoModel(title: "석촌 호수 한 바퀴", place: "서울시 강동구", date: "2022.12.28", distance: "4.01 km", runningTime: "0:27:36", averagePace: "6'45\"")
    ]
    
    // MARK: - UI Components
    
    private lazy var navibar = CustomNavigationBar(self, type: .titleWithLeftButton).setTitle("활동 기록")
    
    private let activityRecordTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
    }

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUI()
        setLayout()
        register()
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
            make.top.equalTo(navibar.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - General Helpers

    private func register() {
        activityRecordTableView.register(ActivityRecordInfoTVC.self,
                                     forCellWithReuseIdentifier: ActivityRecordInfoTVC.className)
    }
}

// MARK: - UITableViewDelegate

extension ActivityRecordInfoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177
    }
}

// MARK: - UITableViewDataSource

extension ActivityRecordInfoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityRecordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let activityRecordCell = tableView.dequeueReusableCell(withIdentifier: ActivityRecordInfoTVC.className, for: indexPath) as? ActivityRecordInfoTVC else { return UITableViewCell()}
        activityRecordCell.dataBind(model: activityRecordList[indexPath.item])
        return activityRecordCell
    }
}
