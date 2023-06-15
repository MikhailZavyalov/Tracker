import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let trackersViewController = UINavigationController(rootViewController: TrackersMainViewController())
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        statisticsViewController.title = "Статистика"
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackersViewController, statisticsViewController]
        tabBarController.viewControllers?[0].tabBarItem.image = UIImage(named: "record.circle.fill")
        tabBarController.viewControllers?[1].tabBarItem.image = UIImage(named: "hare.fill")

        window = UIWindow(windowScene: scene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

struct Scene_Previews: PreviewProvider {
  static var previews: some View {
      let trackersViewController = UINavigationController(rootViewController: TrackersMainViewController())
      let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
      statisticsViewController.title = "Статистика"
      let tabBarController = UITabBarController()
      tabBarController.viewControllers = [trackersViewController, statisticsViewController]
      
    return UIViewRepresented(makeUIView: { _ in tabBarController.view })
  }
}
