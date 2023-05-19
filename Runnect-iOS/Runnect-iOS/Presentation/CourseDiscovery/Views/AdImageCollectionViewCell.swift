//
//  AdImageCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import UIKit
import SnapKit

import Then

class AdImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - collectionview
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    // MARK: - Constants
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)

    // MARK: - UI Components
    var imgBanners: [UIImage] = [ImageLiterals.imgBanner1, ImageLiterals.imgBanner2, ImageLiterals.imgBanner3]
    var currentPage: Int = 0
    
    private var pageControl = UIPageControl()
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setDelegate()
        startBannerSlide()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Extensions

extension AdImageCollectionViewCell {
    private func setDelegate() {
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
    }
    func startBannerSlide() {
        
        // 초기 페이지 설정
        currentPage = imgBanners.count
                
        // 제스처 인식기 추가
               let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
               swipeLeftGesture.direction = .left
        bannerCollectionView.addGestureRecognizer(swipeLeftGesture)
               
               let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
               swipeRightGesture.direction = .right
        bannerCollectionView.addGestureRecognizer(swipeRightGesture)
        
        // 페이지 컨트롤 설정
                pageControl.currentPage = 0
                pageControl.numberOfPages = imgBanners.count
                pageControl.pageIndicatorTintColor = .lightGray // 페이지를 암시하는 동그란 점의 색상
                pageControl.currentPageIndicatorTintColor = .white
        }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        // 배너를 스와이프하여 수동으로 슬라이드
               if gesture.direction == .left {
                   currentPage += 1
               } else if gesture.direction == .right {
                   currentPage -= 1
               }
               // 첫 번째 배너에서 이전으로 스와이프하면 마지막 배너로 이동
               if currentPage < 0 {
                   currentPage = imgBanners.count * 2 - 1
               }
               
               // 마지막 배너에서 다음으로 스와이프하면 첫 번째 배너로 이동
               if currentPage >= imgBanners.count * 2 {
                   currentPage = 0
               }
               
               let indexPath = IndexPath(item: currentPage, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        updatePageControl()
       }
    
    // 페이지 컨트롤 업데이트
        func updatePageControl() {
            let currentIndex = currentPage % imgBanners.count
            pageControl.currentPage = currentIndex
        }
    
    // MARK: - Layout Helpers
    
    func layout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(bannerCollectionView)
        contentView.addSubview(pageControl)
        bannerCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
                make.centerX.equalTo(self)
                make.bottom.equalTo(bannerCollectionView.snp.bottom)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension AdImageCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgBanners.count*3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath)
                
        // 배너 이미지 설정
                let imageIndex = indexPath.item % imgBanners.count
                let imageView = UIImageView(frame: cell.contentView.bounds)
                imageView.image = imgBanners[imageIndex]
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                cell.contentView.addSubviews(imageView)
                return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AdImageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
