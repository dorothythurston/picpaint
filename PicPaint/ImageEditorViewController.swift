//
//  ImageEditorViewController.swift
//  PicPaint
//
//  Created by Dorothy Thurston on 7/27/15.
//  Copyright (c) 2015 Dorothy Thurston. All rights reserved.
//

import UIKit

class ImageEditorViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempDrawImageView: UIImageView!
    
    
    // MARK: - Actions
    
    @IBAction func didPressDelete(sender: UIBarButtonItem) {
    }
    @IBAction func didPressShare(sender: UIBarButtonItem) {
    }
    
    @IBAction func didPressTakePhoto(sender: UIBarButtonItem) {
    }
    
    @IBAction func didPressAlbum(sender: UIBarButtonItem) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
