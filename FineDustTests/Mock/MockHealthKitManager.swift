//
//  MockHealthKitManager.swift
//  FineDustTests
//
//  Created by Presto on 28/01/2019.
//  Copyright © 2019 boostcamp3rd. All rights reserved.
//

@testable import FineDust
import Foundation
import HealthKit

final class MockHealthKitManager: HealthKitManagerType {
  
  func findHealthKitValue(startDate: Date,
                          endDate: Date,
                          quantityFor: HKUnit,
                          quantityTypeIdentifier: HKQuantityTypeIdentifier,
                          completion: @escaping (Double) -> Void) {
    switch quantityTypeIdentifier {
    case .distanceWalkingRunning:
      completion(1409.53)
    case .stepCount:
      completion(2314.0)
    default: 0
    }
  }
  
  func requestAuthorization() {
    print(" ")
  }
  
}
