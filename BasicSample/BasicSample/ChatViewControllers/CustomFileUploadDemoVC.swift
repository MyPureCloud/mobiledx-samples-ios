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

/************************************************************/
// MARK: - Sample Agenda
/************************************************************/
/**
 0. Listen to relevant chat state
 1. Validate file transfer enabled on bold admin console.
 2. Add custom button.
 3. When uploade button tapped, show file selector view.
 4. Once file was picked create upload request.
 5. Once upload request created start upload file process.
 6. Call handle function on ChatController with upload file information.
 7. You can get progress values, to show upload progress bar.
 */

class CustomFileUploadDemoVC: AgentViewController {
    
    lazy var imagePicker: UIImagePickerController = { return UIImagePickerController()}()
    let uploadBtn = UIButton(type: .custom) as UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didUpdateState(_ event: ChatStateEvent!) {
        switch event.state {
        ///0. Listen to relevant chat state
        case .pending:
            /// 1. Validate file transfer enabled on bold admin console.
            if(self.chatController.isFileTransferEnabled) {
                /// 2. Add custom button.
                DispatchQueue.main.async {
                    self.uploadBtn.backgroundColor = .blue
                    self.uploadBtn.setTitle("Upload File", for: .normal)
                    self.uploadBtn.frame.size = CGSize(width: 150, height: 70)
                    self.uploadBtn.center = (self.navigationController?.visibleViewController?.view.center)!
                    self.uploadBtn.addTarget(self, action: #selector(self.uploadFile), for: .touchUpInside)
                    self.navigationController?.visibleViewController?.view.addSubview(self.uploadBtn)
                }
            }
            break
        default:
            break
        }
    }
    
}

extension CustomFileUploadDemoVC: OpalImagePickerControllerDelegate {
    @objc func uploadFile(_ sender: UIBarButtonItem) {
        
        /// 3. When uploade button tapped, show file selector view.
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
                        /// 4. Once file was picked create upload request.
                        let request = UploadRequest()
                        request.fileName = (resources.first!).originalFilename
                        request.fileType = .picture
                        request.fileData = data
                        /// 5. Once upload request created start upload file process.
                        self.chatController.uploadFile(request, progress: { (progress) in
                            /// 7. You can get progress values, to show upload progress bar.
                            print("application file upload progress -> %.5f", progress)
                        }) { (info: FileUploadInfo!) in
                            /// 6. Call handle function on ChatController with upload file information.
                            self.uploadBtn.removeFromSuperview()
                            self.chatController.handle(BoldEvent.fileUploaded(info))
                        }
                    }
                }
            }
        }
        self.navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension CustomFileUploadDemoVC: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
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
            self.uploadBtn.removeFromSuperview()
            self.chatController.handle(BoldEvent.fileUploaded(info!))
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}

extension CustomFileUploadDemoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
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
                    self.uploadBtn.removeFromSuperview()
                    self.chatController.handle(BoldEvent.fileUploaded(info!))
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
            self.uploadBtn.removeFromSuperview()
            self.chatController.handle(BoldEvent.fileUploaded(infoFile))
        }
        
        print("did cancel")
    }
}
