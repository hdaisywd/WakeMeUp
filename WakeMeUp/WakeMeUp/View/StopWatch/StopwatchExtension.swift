import Foundation
import UIKit

enum MyColor {
    static let pulseColor = UIColor(hexCode: "ffd6ff")
    static let indicatorColor = UIColor(hexCode: "e7c6ff")
    static let stopWatchColor = UIColor(hexCode: "c8b6ff")
    static let largeLapTime = UIColor(hexCode: "f49cbb")
    static let smallLapTime = UIColor(hexCode: "b388eb")
}

enum MyButton {
    static let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
    static let playIcon = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
    static let stopIcon = UIImage(systemName: "pause.fill", withConfiguration: imageConfig)
    static let lapIcon = UIImage(systemName: "checkmark", withConfiguration: imageConfig)
    static let resetIcon = UIImage(systemName: "clock.arrow.circlepath", withConfiguration: imageConfig)
}

extension UILabel {
    static func makeTimeLabel(_ text: String, _ alignment: NSTextAlignment, _ fontSize: CGFloat, _ color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.text = text
        label.textColor = color
        label.backgroundColor = .clear
        return label
    }

    static func makeTimeTitleLabel(_ text: String, _ size: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: size)
        label.text = text
        label.textColor = .white
        label.textAlignment = .center
        return label
    }
}

extension UIImage {
    static func image(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}




