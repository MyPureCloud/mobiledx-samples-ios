// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import OpalImagePicker
import Photos
import Bold360AI
import MobileCoreServices

class FileUploadDemoViewController: AgentViewController {
    
    lazy var imagePicker: UIImagePickerController = { return UIImagePickerController()}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FileUploadDemoViewController: OpalImagePickerControllerDelegate {
    func didClickUploadFile() {
        
        let actionSheet = UIAlertController(title: "Choose File Selector", message: nil, preferredStyle: .actionSheet)
        
        // Create your actions - take a look at different style attributes
        let reportAction = UIAlertAction(title: "Choose media", style: .default) { (action) in
            //Example instantiating OpalImagePickerController with delegate
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            imagePicker.maximumSelectionsAllowed = 10
            self.navigationController?.presentedViewController?.present(imagePicker, animated: true, completion: nil)
        }
        
        let blockAction = UIAlertAction(title: "Choose File", style: .default) { (action) in
            let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: UIDocumentPickerMode.import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.navigationController?.presentedViewController?.present(documentPicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("didPress cancel")
        }
        
        // Add the actions to your actionSheet
        actionSheet.addAction(reportAction)
        actionSheet.addAction(blockAction)
        actionSheet.addAction(cancelAction)
        // Present the controller
        self.navigationController?.presentedViewController?.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        //Cancel action?
    }

    public func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        assets.forEach { asset in
            let resources = PHAssetResource.assetResources(for: asset)
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .default, options: nil) { image, dictionary in
                if let isDegraded = dictionary?[PHImageResultIsDegradedKey] as? Bool, !isDegraded {
                    if let data = image?.jpegData(compressionQuality: 1.0) {
                        let request = UploadRequest()
                        request.fileName = (resources.first!).originalFilename
                        request.fileType = .picture
                        request.fileData = data
                        self.chatController.uploadFile(request, progress: { (progress) in
                            print("application file upload progress -> %.5f", progress)
                        }) { (info: FileUploadInfo!) in
                            self.chatController.handle(BoldEvent.fileUploaded(info))
                        }
                    }
                }
            }
        }
        self.navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension FileUploadDemoViewController: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        self.navigationController?.presentedViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let request = UploadRequest()
        request.fileName = "fileName.pdf"
        request.fileType = .default
        
        var data: Data!
        
        if FileManager.default.fileExists(atPath: urls.first!.path) {
            data = FileManager.default.contents(atPath: urls.first!.path)
        }
        
        request.fileData = data
        
        self.chatController.uploadFile(request, progress: { (progress) in
            print("application file upload progress ->")
        }) { (info) in
            if((info.error) != nil) {
                print(info.error.localizedDescription)
                
                let alert = UIAlertController(title: "Error", message:info.error.localizedDescription, preferredStyle: UIAlertController.Style.alert)

                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                // show the alert
                self.navigationController?.presentedViewController?.present(alert, animated: true, completion: nil)
            }
            self.chatController.handle(BoldEvent.fileUploaded(info))
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
    }
}

extension FileUploadDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    func didClickUploadFile() {
//        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
//            print("can't open photo library")
//            return
//        }
//        self.imagePicker.delegate = self
//        self.imagePicker.sourceType = .photoLibrary
//        self.navigationController?.presentedViewController?.present(imagePicker, animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        do {
            picker.dismiss(animated: true)
            if let url = info[.imageURL] as? NSURL, let fileName = url.lastPathComponent, let image = info[.originalImage] as? UIImage, let fileData = image.jpegData(compressionQuality: 1.0) {
                let request = UploadRequest()
                request.fileName = fileName
                request.fileType = .picture
                request.fileData = fileData
                
                self.chatController.uploadFile(request, progress: { (progress) in
                    print("application file upload progress ->")
                }) { (info) in
                    if((info.error) != nil) {
                        
                    }
                    self.chatController.handle(BoldEvent.fileUploaded(info))
                }
            }

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
            let infoFile = FileUploadInfo()
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"file failed to upload"])
            infoFile.error = error
            self.chatController.handle(BoldEvent.fileUploaded(infoFile))
        }
        
        print("did cancel")
    }
}
