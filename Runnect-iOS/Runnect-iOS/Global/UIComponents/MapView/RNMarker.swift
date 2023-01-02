//
//  RNMarker.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import UIKit

import NMapsMap
import SnapKit
import Then

final class RNMarker: NMFMarker {
    
    // MARK: - initialization
    
    override init() {
        super.init()
        setUI()
    }
}

// MARK: - UI & Layout

extension RNMarker {
    private func setUI() {
        let image = NMFOverlayImage(image: ImageLiterals.icMapPoint)
        self.iconImage = image
        
        self.width = CGFloat(NMF_MARKER_SIZE_AUTO)
        self.height = CGFloat(NMF_MARKER_SIZE_AUTO)
        
        self.anchor = CGPoint(x: 0.5, y: 0.5)
        
        self.iconPerspectiveEnabled = true
    }
}
