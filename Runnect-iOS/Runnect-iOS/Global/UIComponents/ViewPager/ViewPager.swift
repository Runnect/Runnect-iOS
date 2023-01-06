//
//  ViewPager.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/05.
//

import UIKit
import Combine

class ViewPager: UIView {
    
    // MARK: - Properties
    
    @Published var selectedTabIndex = 0
    private var cancelBag = CancelBag()
    
    // 탭이 클릭된 건지 판단하기 위한 변수(스와이프랑 구분하기 위함)
    private var tappedButton: Bool = false
        
    // MARK: - UI Components
    
    private lazy var buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
    }
    
    private let barBackgroundView = UIView().then {
        $0.backgroundColor = .w1
        $0.clipsToBounds = true
    }
    
    private let barView = UIView().then {
        $0.backgroundColor = .m1
    }
    
    private let bottomBorderView = UIView().then {
        $0.backgroundColor = .g3
    }
    
    public let pagedView = PagedView()
    
    // MARK: - Initialization
    
    init(pageTitles: [String]) {
        super.init(frame: .zero)
        self.makeTabbedView(pageTitles: pageTitles)
        self.setLayout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension ViewPager {
    
    /// paging할 UIView 추가
    @discardableResult
    func addPagedView(pagedView: [UIView]) -> Self {
        self.pagedView.pages += pagedView
        return self
    }
    
    private func makeTabbedView(pageTitles: [String]) {
        for (index, pageTitle) in pageTitles.enumerated() {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: pageTitle, attributes: [.font: UIFont.h5, .foregroundColor: UIColor.m1]), for: .selected)
            button.setAttributedTitle(NSAttributedString(string: pageTitle, attributes: [.font: UIFont.b3, .foregroundColor: UIColor.g2]), for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    private func moveBar(index: Int) {
        var leadingConstant: CGFloat = 0
        let buttonWidth = self.buttonStackView.arrangedSubviews[0].frame.width
        leadingConstant += (buttonWidth * CGFloat(index))
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear]) {
            self.barView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(leadingConstant)
            }
            self.barBackgroundView.layoutIfNeeded()
        }
        
        selectedTabIndex = index
        tappedButton = false
    }
}

// MARK: - @objc Function

extension ViewPager {
    @objc private func tabButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index != selectedTabIndex else { return } // 이미 선택되어 있는 페이지일 경우 이동 X
        
        tappedButton = true
        
        moveBar(index: index)
        pagedView.moveToPage(at: index)
    }
}

// MARK: - Bind

extension ViewPager {
    private func bind() {
        pagedView.movedPage.sink { [weak self] index in
            guard let self = self, !self.tappedButton else { return }
            self.selectedTabIndex = index
        }.store(in: cancelBag)
        
        pagedView.percent.sink { [weak self] percent in
            guard let self = self, !self.tappedButton else { return }
            let leadingContraints = self.barBackgroundView.frame.width * percent
            self.barView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(leadingContraints)
            }
        }.store(in: cancelBag)
        
        $selectedTabIndex.sink { index in
            for (i, tabView) in self.buttonStackView.arrangedSubviews.enumerated() {
                guard let button = tabView as? UIButton else { return }
                button.isSelected = (i == index)
            }
        }.store(in: cancelBag)
    }
}

// MARK: - UI & Layout

extension ViewPager {
    private func setUI() {
        self.backgroundColor = .w1
    }
    
    private func setLayout() {
        self.addSubviews(buttonStackView, barBackgroundView, pagedView)
        barBackgroundView.addSubviews(bottomBorderView, barView)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(38)
        }
        
        barBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.bottom.equalTo(buttonStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        bottomBorderView.snp.makeConstraints { make in
            make.top.equalTo(barBackgroundView.snp.bottom).inset(1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        guard let button = buttonStackView.arrangedSubviews.first as? UIButton else { return }
        
        barView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(button.snp.width)
        }
        
        pagedView.snp.makeConstraints { make in
            make.top.equalTo(barBackgroundView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
