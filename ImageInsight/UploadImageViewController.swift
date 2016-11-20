//
//  ViewController.swift
//  ImageInsight
//
//  Created by Mitul Manish on 19/11/16.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase


class UploadImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageToBeAnalysed: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        let pickerView = UIImagePickerController()
        pickerView.sourceType = .photoLibrary
        pickerView.mediaTypes = [kUTTypeImage as String]
        pickerView.delegate = self
        present(pickerView, animated: true, completion: nil)
    }
    
    func uploadImageToStorage(imageData: Data) {
        let firebaseStorageReference = FIRStorage.storage().reference(withPath: "photo/imageToBeAnalysed.jpg")
        let imageMetaData = FIRStorageMetadata()
        imageMetaData.contentType = "image/jpeg"
        firebaseStorageReference.put(imageData, metadata: imageMetaData) { (metadata, error) in
            if let error = error {
               print(error.localizedDescription)
            } else {
                if let downloadLink = metadata?.downloadURL()?.absoluteString {
                    print(downloadLink)
                    self.getInsightsFromService(imageURL: downloadLink)
                }
            }
        }
    }
    
    func getInsightsFromService(imageURL: String) {
        WatsonImageAnalysisService.sharedInstance.getDataFromService(imageURL: imageURL) { (dataDictionary) in
            print(dataDictionary)
        }
    }
}

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
            return
        }
        
        if mediaType == kUTTypeImage as String {
            if let imageFromPicker = info[UIImagePickerControllerOriginalImage] as? UIImage, let imageData = UIImageJPEGRepresentation(imageFromPicker, 0.8) {
                imageToBeAnalysed.image = imageFromPicker
                uploadImageToStorage(imageData: imageData)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

