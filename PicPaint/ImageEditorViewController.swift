//
//  ImageEditorViewController.swift
//  PicPaint
//
//  Created by Dorothy Thurston on 7/27/15.
//  Copyright (c) 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Properties
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempDrawImageView: UIImageView!
    
    
    // MARK: - Actions
    
    @IBAction func didPressDelete(sender: UIBarButtonItem) {
        let deleteImageAlert = UIAlertController(title: "Delete Drawing?", message: "This action cannot be undone", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteImageAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction) in
            self.mainImageView.image = nil
        }))
        
        deleteImageAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
        }))
        presentViewController(deleteImageAlert, animated: true, completion: nil)
    }
    
    @IBAction func didPressShare(sender: UIBarButtonItem) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    @IBAction func didPressTakePhoto(sender: UIBarButtonItem) {
        if (UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        }
        else {
            noCamera()
        }
    }
    
    @IBAction func didPressAlbum(sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIGraphicsBeginImageContext(mainImageView.frame.size)
            image.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// alert if no rear camera available
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
  
    
    override func touchesBegan(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(tempDrawImageView)
        }
       
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(tempDrawImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempDrawImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempDrawImageView.frame.size.width, height: tempDrawImageView.frame.size.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        CGContextStrokePath(context)
        
        tempDrawImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempDrawImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(tempDrawImageView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempDrawImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempDrawImageView.image = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsViewController = segue.destinationViewController as! BrushSettingsViewController
        settingsViewController.delegate = self
        settingsViewController.brush = brushWidth
        settingsViewController.opacity = opacity
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue
    }
    
}

extension ImageEditorViewController: BrushSettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: BrushSettingsViewController) {
        self.brushWidth = settingsViewController.brush
        self.opacity = settingsViewController.opacity
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
    }
}

