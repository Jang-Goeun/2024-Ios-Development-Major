//
//  ViewController.swift
//  MyPageControlTest
//
//  Created by 장세화 on 10/13/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lblPageControlNumber: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    var pageNumbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pageControl.numberOfPages = 10
        pageControl.currentPage = 0
        
        pageControl.pageIndicatorTintColor = UIColor.orange
        pageControl.currentPageIndicatorTintColor=UIColor.green
        
        lblPageControlNumber.text = pageNumbers[0]
    }

    @IBAction func pageChange(_ sender: UIPageControl) {
        lblPageControlNumber.text = pageNumbers[pageControl.currentPage]
    }
    
}

