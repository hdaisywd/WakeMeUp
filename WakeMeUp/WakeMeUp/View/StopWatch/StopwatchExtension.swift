import Foundation
import UIKit

enum MyColor {
    static let pulseColor = UIColor(red: 1.00, green: 0.84, blue: 1.00, alpha: 1.00)
    static let stopWatchColor = UIColor(red: 0.78, green: 0.71, blue: 1.00, alpha: 1.00)
    static let indicatorColor = UIColor(red: 0.91, green: 0.78, blue: 1.00, alpha: 1.00)
}

enum MyButton {
    static let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
    static let playIcon = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
    static let stopIcon = UIImage(systemName: "pause.fill", withConfiguration: imageConfig)
    static let lapIcon = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)
    static let resetIcon = UIImage(systemName: "arrow.counterclockwise.circle.fill", withConfiguration: imageConfig)
}
