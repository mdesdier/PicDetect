//
//  ViewController.swift
//  PicDetect
//
//  Created by tester on 12/2/18.
//  Copyright © 2018 Tepo Labs. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //had to add additional classes deleages to that imagePicker.delegate = self works
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    let resnetModel = Resnet50()
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        
        if let model = try? VNCoreMLModel.init(for: resnetModel.model) {
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    for result in results {
                        print("ID: \(result.identifier) Confidence: \(result.confidence)")
                    }
                }
            }
    
            //for now work with fixed image that we put in assets
            if let image = UIImage(named: "hotdog1") {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let handler = VNImageRequestHandler(data: imageData, options: [:])
                    try? handler.perform([request])
                }
            }
            
        
        }
        

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)  //dismiss the picker
    }
    
    @IBAction func photosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil) //present image picker view controller we created
    }
    
    @IBAction func CameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil) //present image picker view controller we created
    }
}

