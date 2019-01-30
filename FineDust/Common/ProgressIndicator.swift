//
//  ProgressIndicator.swift
//  FineDust
//
//  Created by Presto on 25/01/2019.
//  Copyright © 2019 boostcamp3rd. All rights reserved.
//

import UIKit

/// 네트워크 인디케이터 뷰
final class ProgressIndicator: UIView {
  
  // MARK: Singleton Object
  static let shared = ProgressIndicator(frame: UIScreen.main.bounds)
  
  /// 배경 뷰
  private var backgroundView: UIView! {
    didSet {
      backgroundView.backgroundColor = .lightGray
      backgroundView.clipsToBounds = true
      backgroundView.layer.cornerRadius = 10
      backgroundView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(backgroundView)
      NSLayoutConstraint.activate([
        backgroundView.anchor.centerX.equal(to: anchor.centerX),
        backgroundView.anchor.centerY.equal(to: anchor.centerY),
        backgroundView.anchor.width.equal(toConstant: 100),
        backgroundView.anchor.height.equal(toConstant: 100)
        ])
    }
  }
  
  // 액티비티 인디케이터
  private var indicator: UIActivityIndicatorView! {
    didSet {
      indicator.style = .whiteLarge
      indicator.color = .black
      indicator.hidesWhenStopped = true
      indicator.translatesAutoresizingMaskIntoConstraints = false
      backgroundView.addSubview(indicator)
      NSLayoutConstraint.activate([
        indicator.anchor.centerX.equal(to: backgroundView.anchor.centerX),
        indicator.anchor.centerY.equal(to: backgroundView.anchor.centerY)
        ])
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    backgroundColor = UIColor.black.withAlphaComponent(0.3)
    backgroundView = UIView()
    indicator = UIActivityIndicatorView()
  }
  
  /// `ProgressIndicator.shared.show()`로 인디케이터 표시
  func show() {
    DispatchQueue.main.async { [weak self] in
      guard let `self` = self else { return }
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      self.indicator.startAnimating()
      if let window = UIApplication.shared.keyWindow {
        window.addSubview(self)
      }
    }
  }
  
  /// `ProgressIndicator.shared.hide()`로 인디케이터 표시
  func hide() {
    DispatchQueue.main.async { [weak self] in
      guard let `self` = self else { return }
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      self.indicator.stopAnimating()
      self.removeFromSuperview()
    }
  }
}