//
//  ViewController.swift
//  WDImagePicker
//
//  Created by Wu Di on 27/8/15.
//  Copyright (c) 2015 Wu Di. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WDImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var imagePicker: WDImagePicker!
    private var popoverController: UIPopoverController!
    private var imagePickerController: UIImagePickerController!

    private var customCropButton: UIButton!
    private var normalCropButton: UIButton!
    private var imageView: UIImageView!
    private var resizableButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.customCropButton = UIButton()
        self.customCropButton.frame = UIDevice.currentDevice().userInterfaceIdiom == .Pad ?
            CGRectMake(20, 20, 220, 44) :
            CGRectMake(20, CGRectGetMaxY(self.customCropButton.frame) + 20 , CGRectGetWidth(self.view.bounds) - 40, 44)
        self.customCropButton.setTitleColor(self.view.tintColor, forState: .Normal)
        self.customCropButton.setTitle("Custom Crop", forState: .Normal)
        self.customCropButton.addTarget(self, action: #selector(ViewController.showPicker(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.customCropButton)

        self.normalCropButton = UIButton()
        self.normalCropButton.setTitleColor(self.view.tintColor, forState: .Normal)
        self.normalCropButton.setTitle("Apple's Build In Crop", forState: .Normal)
        self.normalCropButton.addTarget(self, action: #selector(ViewController.showNormalPicker(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.normalCropButton)

        self.resizableButton = UIButton()
        self.resizableButton.setTitleColor(self.view.tintColor, forState: .Normal)
        self.resizableButton.setTitle("Resizable Custom Crop", forState: .Normal)
        self.resizableButton.addTarget(self, action: #selector(ViewController.showResizablePicker(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(self.resizableButton)

        self.imageView = UIImageView(frame: CGRectZero)
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(self.imageView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.normalCropButton.frame = UIDevice.currentDevice().userInterfaceIdiom == .Pad ?
            CGRectMake(260, 20, 220, 44) :
            CGRectMake(20, CGRectGetMaxY(self.customCropButton.frame) + 20 , CGRectGetWidth(self.view.bounds) - 40, 44)

        self.resizableButton.frame = UIDevice.currentDevice().userInterfaceIdiom == .Pad ?
            CGRectMake(500, 20, 220, 44) :
            CGRectMake(20, CGRectGetMaxY(self.normalCropButton.frame) + 20 , CGRectGetWidth(self.view.bounds) - 40, 44)

        self.imageView.frame = UIDevice.currentDevice().userInterfaceIdiom == .Pad ?
            CGRectMake(20, 84, CGRectGetWidth(self.view.bounds) - 40, CGRectGetHeight(self.view.bounds) - 104) :
            CGRectMake(20, CGRectGetMaxY(self.resizableButton.frame) + 20, CGRectGetWidth(self.view.bounds) - 40, CGRectGetHeight(self.view.bounds) - 20 - (CGRectGetMaxY(self.resizableButton.frame) + 20))
    }

    func showPicker(button: UIButton) {
        let actionSheet = UIAlertController.init(title: "Please choose a source type", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (action) in
            self.showCamera(button, isCropAreaResizable: false)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertActionStyle.Default, handler: { (action) in
            self.showPhotoGallery(button, isCropAreaResizable: false)
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController = UIPopoverController(contentViewController: actionSheet)
            self.popoverController.presentPopoverFromRect(button.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        } else {
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
//        self.presentViewController(actionSheet, animated: true, completion: nil)

    }

    func showNormalPicker(button: UIButton) {
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.sourceType = .PhotoLibrary
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController = UIPopoverController(contentViewController: self.imagePickerController)
            self.popoverController.presentPopoverFromRect(button.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        } else {
            self.presentViewController(self.imagePickerController, animated: true, completion: nil)
        }
    }

    func showResizablePicker(button: UIButton) {
        let actionSheet = UIAlertController.init(title: "Please choose a source type", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "Take Photo", style: UIAlertActionStyle.Default, handler: { (action) in
            self.showCamera(button, isCropAreaResizable: true)
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Choose Photo", style: UIAlertActionStyle.Default, handler: { (action) in
            self.showPhotoGallery(button, isCropAreaResizable: true)
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController = UIPopoverController(contentViewController: actionSheet)
            self.popoverController.presentPopoverFromRect(button.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        } else {
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
    }

    func imagePicker(imagePicker: WDImagePicker, pickedImage: UIImage) {
        self.imageView.image = pickedImage
        self.hideImagePicker()
    }

    func hideImagePicker() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController.dismissPopoverAnimated(true)
        } else {
            self.imagePicker.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.imageView.image = image

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController.dismissPopoverAnimated(true)
        } else {
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func showPhotoGallery(button : UIButton, isCropAreaResizable : Bool){
        
        self.imagePicker = WDImagePicker.init(withSourceType: .PhotoLibrary)
        self.imagePicker.cropSize = CGSizeMake(280, 280)
        self.imagePicker.delegate = self
        self.imagePicker.resizableCropArea = isCropAreaResizable
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController = UIPopoverController(contentViewController: self.imagePicker.imagePickerController)
            self.popoverController.presentPopoverFromRect(button.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        } else {
            self.presentViewController(self.imagePicker.imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    func showCamera(button : UIButton, isCropAreaResizable : Bool){
        self.imagePicker = WDImagePicker.init(withSourceType: .Camera)
        self.imagePicker.cropSize = CGSizeMake(280, 280)
        self.imagePicker.delegate = self
        self.imagePicker.resizableCropArea = isCropAreaResizable
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.popoverController = UIPopoverController(contentViewController: self.imagePicker.imagePickerController)
            self.popoverController.presentPopoverFromRect(button.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        } else {
            self.presentViewController(self.imagePicker.imagePickerController, animated: true, completion: nil)
        }
    }
    
    
}

