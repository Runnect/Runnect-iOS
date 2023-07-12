//
//  AdImageCollectionViewCell.swift
//  Runnect-iOS
//
//  Created by YEONOO on 2023/01/10.
//

import UIKit
import SnapKit

import Then

class AdImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    // MARK: - collectionview
    
    private lazy var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    // MARK: - Constants
    
    final let collectionViewInset = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)

    // MARK: - UI Components
    var eventImg: UIImage = ImageLiterals.imgBanner4
    var imgBanners: [UIImage] = [ImageLiterals.imgBanner4, ImageLiterals.imgBanner1, ImageLiterals.imgBanner2]
    var currentPage: Int = 0
    private var timer: Timer?
    
    private var pageControl = UIPageControl()
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setDelegate()
        startBannerSlide()
        goToForm()
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
    
    private func startBannerSlide() {
        currentPage = imgBanners.count
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(animateBannerSlide), userInfo: nil, repeats: true)
        pageControl.currentPage = 0
        pageControl.numberOfPages = imgBanners.count
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
    }
    
    private func updatePageControl() {
        let currentIndex = currentPage % imgBanners.count
        pageControl.currentPage = currentIndex
        let indexPath = IndexPath(item: currentPage, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func goToForm() {
        // 이미지 뷰에 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        bannerCollectionView.addGestureRecognizer(tapGesture)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentPage % imgBanners.count
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

// MARK: - @objc Function

extension AdImageCollectionViewCell {
    @objc func animateBannerSlide() {
        currentPage += 1
        if currentPage >= imgBanners.count {
            currentPage = 0
        }
        updatePageControl()
    }
    @objc func imageTapped() {
           // Safari 링크로 연결
           if let url = URL(string: "https://docs.google.com/forms/d/1cpgZHNNi1kIvi2ZCwCIcMJcI1PkHBz9a5vWJb7FfIbg/edit") { // 연결하고자 하는 링크 주소에 따라 변경해야 합니다.
               UIApplication.shared.open(url)
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
