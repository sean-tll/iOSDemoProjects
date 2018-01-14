//
//  ViewController.swift
//  Filterer
//
//  Created by Tianshu Zhou on 1/3/18.
//  Copyright © 2018 Tianshu Zhou. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet weak var bottomMenu: UIStackView!
    @IBOutlet var editMenu: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    var originalImage: UIImage?
    var colorEdittedImage: UIImage?
    var filteredImage: UIImage?
    
    @IBAction func shareTapped(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func newPhotoTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { (action) in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] {
            originalImage = image as? UIImage
            originalImage = fixOrientation(img: originalImage!)
            imageView.image = originalImage
            filteredImage = nil
            colorEdittedImage = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            hideEditMenu()
            sender.isSelected = false
        } else {
            showEditMenu()
            sender.isSelected = true
        }
    }
    
    func showEditMenu() {
        if self.secondaryMenu.isDescendant(of: view) {
            self.secondaryMenu.removeFromSuperview()
            filterButton.isSelected = false
        }
        
        view.addSubview(editMenu)
        
        editMenu.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = editMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = editMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = editMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = editMenu.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        editMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.editMenu.alpha = 0.5
        })
    }
    
    func hideEditMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.editMenu.alpha = 0
        }) { (finished) in
            if finished == true {
                DispatchQueue.main.async() {
                    self.editMenu.removeFromSuperview()
                }
            }
        }
    }
    @IBAction func brightnessControl(_ sender: UISlider) {
        colorEdit(editAttribute: "brightness", inputValue: sender.value)
    }
    
    @IBAction func saturationControl(_ sender: UISlider) {
        colorEdit(editAttribute: "saturation", inputValue: sender.value)
    }
    
    @IBAction func contrastControl(_ sender: UISlider) {
        colorEdit(editAttribute: "contrast", inputValue: sender.value)
    }
    
    func colorEdit(editAttribute: String, inputValue: Float) {
        var attributeMapping: [String: String] = ["brightness": kCIInputBrightnessKey, "saturation": kCIInputSaturationKey, "contrast": kCIInputContrastKey]
        
        let context = CIContext()
        let filter = CIFilter(name: "CIColorControls")!
        
        let image: CIImage?
        if filteredImage != nil {
            image = CIImage(image: filteredImage!)
        } else {
            image = CIImage(image: originalImage!)
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(inputValue, forKey: attributeMapping[editAttribute]!)
        
        let result = filter.outputImage!
        let cgImage = context.createCGImage(result, from: result.extent)
        
        colorEdittedImage = UIImage(cgImage: cgImage!)
        imageView.image = colorEdittedImage
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }
    
    func showSecondaryMenu() {
        if self.editMenu.isDescendant(of: view) {
            self.editMenu.removeFromSuperview()
            editButton.isSelected = false
        }
        
        view.addSubview(secondaryMenu)
        
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 80)
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 1
        })
    }
    
    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
        }) { (finished) in
            if finished == true {
                DispatchQueue.main.async() {
                    self.secondaryMenu.removeFromSuperview()
                }
            }
        }
    }
    
    @IBAction func instantTapped(_ sender: Any) {
        filterApplied(filterName: "CIPhotoEffectInstant")
    }
    
    @IBAction func monoTapper(_ sender: Any) {
        filterApplied(filterName: "CIPhotoEffectMono")
    }
    
    @IBAction func noirTapped(_ sender: Any) {
        filterApplied(filterName: "CIPhotoEffectNoir")
    }
    
    @IBAction func chromeTapped(_ sender: Any) {
        filterApplied(filterName: "CIPhotoEffectChrome")
    }
    
    @IBAction func fadeTapped(_ sender: Any) {
        filterApplied(filterName: "CIPhotoEffectFade")
    }
    
    func filterApplied(filterName: String) {
        let context = CIContext()
        let filter = CIFilter(name: filterName)!
        
        let image: CIImage?
        if colorEdittedImage != nil {
            image = CIImage(image: colorEdittedImage!)
        } else {
            image = CIImage(image: originalImage!)
        }
        
        filter.setValue(image, forKey: kCIInputImageKey)
        let result = filter.outputImage!
        let cgImage = context.createCGImage(result, from: result.extent)
        
        filteredImage = UIImage(cgImage: cgImage!)
        imageView.image = filteredImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        originalImage = UIImage(named: "HorseWS")
        imageView.image = originalImage
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imagePressed(longPressGestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func imagePressed(longPressGestureRecognizer: UILongPressGestureRecognizer)
    {
        
        if longPressGestureRecognizer.state == .began {
            imageView.image = originalImage
        } else if longPressGestureRecognizer.state == .ended {
            if filteredImage != nil {
                imageView.image = filteredImage
            } else {
                imageView.image = originalImage
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

