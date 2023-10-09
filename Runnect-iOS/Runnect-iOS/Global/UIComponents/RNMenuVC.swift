//
//  RNMenuVC.swift
//  Runnect-iOS
//
//  Created by 이명진 on 2023/10/06.
//

import UIKit
import DropDown
import Combine

class RNMenuVC: UIViewController {

    
    let menu = DropDown()
    
    let dropbutton = UIButton().then {
        $0.setTitle("DropDownClick", for: .normal)
        $0.tintColor = .m1
    }
    
    let line = UIView().then {
        $0.backgroundColor = .black
        $0.frame.size.height = 30 // 구분선의 높이를 1로 설정
    }
    
    private let dropView = UIView().then {
        $0.backgroundColor = .w1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .g1.withAlphaComponent(0.3)
        view.addSubviews(dropView, dropbutton)
        
        initUI()
        setTarget()
        setDropDown()
        // anchorView를 통해 UI와 연결
 
        dropbutton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        // Do any additional setup after loading the view.
    }
    
    func setDropDown() {
        
        let items = ["수정하기", "삭제하기"]
            
        menu.dataSource = items
        menu.cellNib = UINib(nibName: "RNDropDownCell", bundle: nil)
        menu.anchorView = dropbutton
//        dropDown.bottomOffset = CGPoint(x: -20, y: dropbutton.bounds.height + 50)
        menu.width = 170
        menu.cellHeight = 40
        menu.cornerRadius = 10
        menu.dismissMode = .onTap
        
//        dropDown.customCellConfiguration =  { (index: Index, item: String, cell: DropDownCell) -> Void in
//            let dividerLine = UIView(frame: CGRect(x: 0, y: cell.frame.height - 4 , width: self.view.frame.width - 20, height: 1))
//            dividerLine.backgroundColor = UIColor(hex: "EBEBEB")
//            cell.addSubview(dividerLine)
//            }
        menu.separatorColor = .black
    }

}

extension RNMenuVC {
    
    // DropDown UI 커스텀
    func initUI() {
        // DropDown View의 배경
        dropView.backgroundColor = UIColor.init(hex: "#F1F1F1")
        dropView.layer.cornerRadius = 8
        
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.red // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(10)
        menu.dismissMode = .automatic // 팝업을 닫을 모드 설정
        
        menu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? RNDropDownCell else {return}
            
            
        }
        menu.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            let lastdividerLineRemove = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 119), size: CGSize(width: 170, height: 10)))
            lastdividerLineRemove.backgroundColor = .white
            cell.addSubview(lastdividerLineRemove)
        }
        
        // 마지막 줄만 없에는 코드 있으면 완벽함
        
    }
    
    private func setTarget() {
        dropbutton.addTarget(self, action: #selector(touchButton), for: .touchUpInside)
    }
    
    @objc private func touchButton() {
        menu.show()
    }
    
}

#if DEBUG
import SwiftUI
struct Preview: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        // 이부분
        RNMenuVC()
        // 이거 보고싶은 현재 VC로 바꾸면됩니다.
    }
    
    func updateUIViewController(_ uiView: UIViewController, context: Context) {
        // leave this empty
    }
}

struct ViewController_PreviewProvider: PreviewProvider {
    static var previews: some View {
        Group {
            Preview()
                .edgesIgnoringSafeArea(.all)
                .previewDisplayName("Preview")
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
#endif
