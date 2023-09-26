
import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // tab bar 아이콘 설정 1
        let firstVC = UINavigationController(rootViewController: AlarmVC())
        firstVC.tabBarItem = UITabBarItem(title: "Alarm", image: UIImage(systemName: "bell"), selectedImage: UIImage(systemName: "bell.fill")?.withTintColor(UIColor(hexCode: "B8C0FF"), renderingMode: .alwaysOriginal))
        // tab bar 아이콘 설정 2
        let secondVC = UINavigationController(rootViewController: TimerVC())
        secondVC.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "timer"), selectedImage: UIImage(systemName: "timer.circle.fill")?.withTintColor(UIColor(hexCode: "B8C0FF"), renderingMode: .alwaysOriginal))
        // tab bar 아이콘 설정 3
        let thirdVC = UINavigationController(rootViewController: StopwatchVC())
        thirdVC.tabBarItem = UITabBarItem(title: "Stopwatch", image: UIImage(systemName: "stopwatch"), selectedImage: UIImage(systemName: "stopwatch.fill")?.withTintColor(UIColor(hexCode: "B8C0FF"), renderingMode: .alwaysOriginal))
        // tab bar 아이콘 설정 4
        let fourthVC = UINavigationController(rootViewController: CalendarVC())
        fourthVC.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar.circle.fill")?.withTintColor(UIColor(hexCode: "B8C0FF"), renderingMode: .alwaysOriginal))

        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)

        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
    }
    
}

