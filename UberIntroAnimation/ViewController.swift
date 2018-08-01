//
//  ViewController.swift
//  UberIntroAnimation
//
//  Created by Murat YILMAZ on 26.07.2018.
//  Copyright © 2018 Murat YILMAZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUberView()
    }

    private func setupUberView() {
        let tileView = UberView(frame: .zero)
        tileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tileView)
        
        tileView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tileView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tileView.startAnimation()
    }
}

