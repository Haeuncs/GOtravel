<h1 align="center">트리비 🚀 여행 일정 관리 iOS 앱 🗺</h1>
<p>
</p>



> 여행 일정과 여행 경비를 관리하는 iOS 앱
>
> iOS App to Manage Travel Schedules and Travel Expenses



## GIF



<img src="githubImage/tribiGif" aligned="center" width="250"/>





## Download

The app currently only supports Korean.
But you can download.



<a href="https://apps.apple.com/app/%ED%8A%B8%EB%A6%AC%EB%B9%84/id1474451502">
<img src="https://linkmaker.itunes.apple.com/ko-kr/badge-lrg.svg?releaseDate=2019-07-30&kind=iossoftware&bubble=ios_apps"/>
</a>



## How does it run on Xcode?

⚠️⚠️Caution⚠️⚠️

You need your own AppDelegate.swift to run this program.

AppDelegate.swift	

~~~swift

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      Singleton.shared.googleMapAPIKey = "⚠️Your own google API Key⚠️"
      if let api = Singleton.shared.googleMapAPIKey {
        GMSServices.provideAPIKey(api)
        GMSPlacesClient.provideAPIKey(api)
      }
        IQKeyboardManager.shared.enable = true
      self.window = UIWindow(frame: UIScreen.main.bounds)
      
      self.window?.rootViewController = TabbarViewController()
      self.window?.makeKeyAndVisible()
      
      return true

    }
}


~~~

You need a pod install.
Then run 'GOtravel.xcworkspace'.

Done! 🥳



## Preview

<img src="githubImage/아트보드 – 2.png" aligned="center" width="250"/><img src="githubImage/아트보드 – 3.png" aligned="center" width="250"/><img src="githubImage/아트보드 – 4.png" aligned="center" width="250"/><img src="githubImage/아트보드 – 5.png" aligned="center" width="250"/>







## Screenshot

<img src="githubImage/1.PNG" aligned="center" width="250"/>

<img src="githubImage/0.PNG" aligned="center" width="250"/>
<img src="githubImage/0_1.PNG" aligned="center" width="250"/>
<img src="githubImage/0_2.PNG" aligned="center" width="250"/>
<img src="githubImage/0_3.PNG" aligned="center" width="250"/>

<img src="githubImage/1.PNG" aligned="center" width="250"/>

<img src="githubImage/2.PNG" aligned="center" width="250"/>

<img src="githubImage/3.PNG" aligned="center" width="250"/>

<img src="githubImage/4.PNG" aligned="center" width="250"/>

<img src="githubImage/5.PNG" aligned="center" width="250"/>

<img src="githubImage/6.PNG" aligned="center" width="250"/>

<img src="githubImage/7.PNG" aligned="center" width="250"/>

<img src="githubImage/8.PNG" aligned="center" width="250"/>

<img src="githubImage/9.PNG" aligned="center" width="250"/>



<img src="githubImage/10.PNG" aligned="center" width="250"/>

<img src="githubImage/11.PNG" aligned="center" width="250"/>

<img src="githubImage/12.PNG" aligned="center" width="250"/>





## Any Question

- Email: haeun.developer@gmail.com





## Show your support

Give a ⭐️ if this project helped you!

