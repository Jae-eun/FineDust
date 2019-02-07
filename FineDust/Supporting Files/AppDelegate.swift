//
//  AppDelegate.swift
//  FineDust
//
//  Created by Presto on 21/01/2019.
//  Copyright © 2019 boostcamp3rd. All rights reserved.
//

import CoreData
import CoreLocation
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  var healthKitManager = HealthKitManager()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window?.tintColor = Asset.graph1.color
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = Asset.graph1.color
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    UITabBar.appearance().tintColor = .white
    UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
    UITabBar.appearance().barTintColor = Asset.graph1.color
    UITextField.appearance().tintColor = .clear
    healthKitManager.requestAuthorization()
    LocationManager.shared.configure(configureLocationManager(_:))
    LocationManager.shared.requestAuthorization()
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) { }
  
  func applicationDidEnterBackground(_ application: UIApplication) { }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    LocationManager.shared.startUpdatingLocation()
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) { }
  
  func applicationWillTerminate(_ application: UIApplication) {
    self.saveContext()
  }
  
  // MARK: - Core Data stack
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "FineDust")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

// MARK: - Location Manager Configuration

private extension AppDelegate {
  
  /// Location Manager 환경설정
  func configureLocationManager(_ manager: LocationManagerType) {
    manager.authorizationChangingHandler = { status in
      // 권한이 주어지면 위치 정보 갱신 작업을 시작하고
      // 그렇지 않으면 관련 상태를 포함하여 노티피케이션을 쏴준다
      switch status {
      case .authorizedAlways, .authorizedWhenInUse:
        manager.startUpdatingLocation()
      default:
        NotificationCenter.default
          .post(name: .locationPermissionDenied, object: nil, userInfo: ["status": status])
      }
    }
    manager.locationUpdatingHandler = { location in
      // 위치 정보가 갱신되면
      // 일단 위치 정보 갱신을 멈춘다
      // 위경도를 변환하여 SharedInfo 싱글톤 객체에 저장하고
      // GeocoderManager를 통해 주소를 얻어 SharedInfo 싱글톤 객체에 저장하고
      // DustManager를 통해 관측소를 얻어 SharedInfo 싱글톤 객체에 저장한다
      // 이후 위치 정보 갱신 작업이 완료되었다는 노티피케이션을 쏴준다
      // 에러 발생시 해당하는 에러 정보를 포함하여(LocationTaskError) 노티피케이션을 쏴준다
      manager.stopUpdatingLocation()
      let coordinate = location.coordinate
      let convertedCoordinate
        = GeoConverter().convert(sourceType: .WGS_84,
                                 destinationType: .TM,
                                 geoPoint: GeographicPoint(x: coordinate.longitude,
                                                           y: coordinate.latitude))
      SharedInfo.shared.set(x: convertedCoordinate?.x ?? 0, y: convertedCoordinate?.y ?? 0)
      GeocoderManager.shared.fetchAddress(location) { address, error in
        if let error = error {
          NotificationCenter.default
            .post(name: .didFailUpdatingAllLocationTasks,
                  object: nil,
                  userInfo: ["error": LocationTaskError.geoencodingError(error)])
          return
        }
        SharedInfo.shared.set(address: address ?? "")
        let dustObservatoryManager = DustObservatoryManager()
        dustObservatoryManager.fetchObservatory(numberOfRows: 1, pageNumber: 1) { response, error in
          if let error = error {
            NotificationCenter.default
              .post(name: .didSuccessUpdatingAllLocationTasks,
                    object: nil,
                    userInfo: ["error": LocationTaskError.networkingError(error)])
            return
          }
          guard let observatory = response?.observatory else { return }
          SharedInfo.shared.set(observatory: observatory)
          NotificationCenter.default.post(name: .didSuccessUpdatingAllLocationTasks, object: nil)
        }
      }
    }
    manager.errorHandler = { error in
      // 작업중 에러가 발생하면 관련 에러를 포함하여 노티피케이션을 쏴준다
      NotificationCenter.default
        .post(name: .didFailUpdatingAllLocationTasks,
              object: nil,
              userInfo: ["error": LocationTaskError.coreLocationError(error)])
    }
  }
}
