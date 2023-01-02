//
//  RNStartMarker.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import UIKit

import NMapsMap
import SnapKit
import Then

final class RNStartMarker: NMFMarker {
    
    // MARK: - UI & Layout
    
    let startInfoWindow = NMFInfoWindow()
    
    // MARK: - initialization
    
    override init() {
        super.init()
        setUI()
        setInfoWindow()
    }
}

// MARK: - UI & Layout

extension RNStartMarker {
    private func setUI() {
        let image = NMFOverlayImage(image: ImageLiterals.icMapDeparture)
        self.iconImage = image
        
        self.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        self.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        self.anchor = CGPoint(x: 0.5, y: 0.5)
        
        self.iconPerspectiveEnabled = true
    }
    
    private func setInfoWindow() {
        startInfoWindow.dataSource = self
    }
    
    func showInfoWindow() {
        startInfoWindow.open(with: self)
    }
    
    func hideInfoWindow() {
        startInfoWindow.close()
    }
}

// MARK: - NMFOverlayImageDataSource

extension RNStartMarker: NMFOverlayImageDataSource {
    func view(with overlay: NMFOverlay) -> UIView {
        // 마커 위에 보여줄 InfoView 이미지 리턴
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 58, height: 34))
        imageView.image = ImageLiterals.icMapDeparture
        return imageView
    }
}
