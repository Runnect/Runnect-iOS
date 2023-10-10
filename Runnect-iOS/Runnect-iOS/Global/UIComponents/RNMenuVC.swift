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
    
    private var items = [String]()
    private var popUpImageArray = [UIImage]()
    
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
    
//    init(ImageArray: [UIImage], items: [String]) {
//        super.init(nibName: nil, bundle: nil)
//        self.popUpImageArray = ImageArray
//        self.items = items
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
        let itemsCount = items.count
            
        menu.dataSource = items
        menu.anchorView = dropbutton
        menu.bottomOffset = CGPoint(x: -20, y: dropbutton.bounds.height + 50)
        menu.width = 170
        menu.cellHeight = 40
        menu.cornerRadius = 10
        menu.dismissMode = .onTap
        
        menu.separatorColor = .black
    }

}

extension RNMenuVC {
    
    // DropDown UI 커스텀
    func initUI() {
        // DropDown View의 배경
        
        let imageArray: [UIImage] = [ImageLiterals.icModify, ImageLiterals.icRemove]
        dropView.backgroundColor = UIColor.init(hex: "#F1F1F1")
        dropView.layer.cornerRadius = 8
        
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.red // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(10)
        menu.dismissMode = .automatic // 팝업을 닫을 모드 설정
    
        menu.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            let lastdividerLineRemove = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 79), size: CGSize(width: 170, height: 10)))
            lastdividerLineRemove.backgroundColor = .white
            cell.addSubview(lastdividerLineRemove)
            cell.dropDownImage.image = imageArray[index]
        }
        
        menu.selectionAction = { [unowned self] (index, item) in
            
            self.menu.clearSelection()
            print("선택 index \(index)")
            print("선택 item \(item)")
            
        }
        
        // 마지막 줄만 없에는 코드 있으면 완벽함
        
    }
    
    private func setLayout() {
        
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
