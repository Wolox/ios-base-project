//
//  ViewController.swift
//  BaseProject
//
//  Created by Guido Marucci Blas on 4/3/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let frame = CGRect(x: 0, y: view.frame.size.height / 2 - 11, width: view.frame.size.width, height: 22)
        let label = UILabel(frame: frame)
        label.text = "Welcome! This is a new blank project"
        label.textAlignment = .center
        label.sizeToFit()
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
