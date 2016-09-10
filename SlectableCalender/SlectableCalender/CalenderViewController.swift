//
//  ViewController.swift
//  SlectableCalender
//
//  Created by Shohei Yokoyama on 2016/09/04.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

final class CalenderViewController: UIViewController {

    @IBOutlet private weak var calenderView: CalenderView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerLabel.text = calenderView.model.headerTitle
    }
}

// MARK: - Private Methods -

private extension CalenderViewController {
    
    
    @IBAction func tapPreviousButton(sender: AnyObject) {
        calenderView.model.displayPreviousMonth()
        calenderView.reloadData()
        headerLabel.text = calenderView.model.headerTitle
    }
    
    @IBAction func tapNextButton(sender: AnyObject) {
        calenderView.model.displayNextMonth()
        calenderView.reloadData()
        headerLabel.text = calenderView.model.headerTitle
    }
}


