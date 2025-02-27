//
//  CustomSlider.swift
//  MusicPlayer
//
//  Created by DongHyeokHwang on 2/27/25.
//

import Foundation
import SwiftUI
import UIKit

struct CustomSlider: UIViewRepresentable {
    @Binding var value: TimeInterval

    var range: ClosedRange<TimeInterval>
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        slider.minimumTrackTintColor = .white
        if let thumbImage = UIImage.thumbImage(with: .white, size: CGSize(width: 10, height: 20)) {
                slider.setThumbImage(thumbImage, for: .normal)
                slider.setThumbImage(thumbImage, for: .highlighted)
            }
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.minimumValue = Float(range.lowerBound)
        uiView.maximumValue = Float(range.upperBound)
        uiView.setValue(Float(value), animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }
    
    class Coordinator: NSObject {
        var value: Binding<TimeInterval>
        
        init(value: Binding<TimeInterval>) {
            self.value = value
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = TimeInterval(sender.value)
        }
    }
}

extension UIImage {
    static func thumbImage(with color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 4)
        color.setFill()
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
