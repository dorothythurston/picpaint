//
//  BrushSettingsViewController.swift
//  PicPaint
//
//  Created by Dorothy Thurston on 7/27/15.
//  Copyright (c) 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

protocol BrushSettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: BrushSettingsViewController)
}

class BrushSettingsViewController: UIViewController {
    // MARK: - Properties
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!
    
    @IBOutlet weak var imageViewBrush: UIImageView!
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    
    var delegate: BrushSettingsViewControllerDelegate?
    
    //MARK: - Actions

    @IBAction func didPressClose(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawPreview()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func colorChanged(sender: UISlider) {
        red = CGFloat(sliderRed.value / 255.0)
        green = CGFloat(sliderGreen.value / 255.0)
        blue = CGFloat(sliderBlue.value / 255.0)
        
        drawPreview()
    }
    
    @IBAction func propertyChanged(sender: UISlider) {
        if sender == sliderBrush {
            brush = CGFloat(sender.value)
        } else {
            opacity = CGFloat(sender.value)
        }
        
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContext(imageViewBrush.frame.size)
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brush)
        CGContextMoveToPoint(context, 60.0, 60.0)
        CGContextAddLineToPoint(context, 60.0, 60.0)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextStrokePath(context)
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
}
