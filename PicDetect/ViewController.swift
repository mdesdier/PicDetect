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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITableViewDataSource ,UITableViewDelegate {
    //had to add additional classes deleages to that imagePicker.delegate = self works
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
  
    let resnetModel = Resnet50()
    var imagePicker = UIImagePickerController()
    var observations : [VNClassificationObservation] = [] //save observations coming back from model
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        tableView.delegate = self  //tableView your data source and delegate is here
        tableView.dataSource = self //had to add UITableViewDataSource to view controller class def above protocol
    }

    func processPic(image:UIImage){
        if let model = try? VNCoreMLModel.init(for: resnetModel.model) {
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    self.observations = results
                    self.tableView.reloadData()
                    
                    //for result in results {
                    //    print("ID: \(result.identifier) Confidence: \(result.confidence)")
                    //}
                }
            }
            
            //image now comes from picker in imagePickerController
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //we are here because user selected an image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            processPic(image: image)    //process image through the coreML model
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let observation = observations[indexPath.row]
        cell.textLabel?.text = "(observation.identifier) Confidence: \(observation.confidence*100.0)%"
   
        return cell
    }
}

