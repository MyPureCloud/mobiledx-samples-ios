// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI
import OpalImagePicker
import Photos


class ViewController: UIViewController {
    
    var chatController: ChatController!
    var account = LiveAccount()
    var chatVC: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let botAccount = BotAccount()
        botAccount.account = "nanorep"
        botAccount.knowledgeBase = "English"
        botAccount.perform(Selector.init(("setServer:")), with:"mobilestaging")
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = .white
//        self.account.apiKey = "2300000001700000000:2279740578451875484:w+8/nRppLqulxknuMDWbiwyAbWbNgv/Y:gamma"
        
        self.chatController = ChatController(account: botAccount)
        self.chatController.viewConfiguration.incomingBotConfig.backgroundColor = UIColor(named: "IncomingBGColor")
        self.chatController.viewConfiguration.outgoingConfig.backgroundColor = UIColor(named: "OutgoingBGColor")
        chatController.delegate = self
    }
    
    lazy var imagePicker: UIImagePickerController = { return UIImagePickerController()}()
}

extension ViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
//        viewController.modalPresentationStyle = .overFullScreen
        var items = self.tabBarController?.viewControllers
        self.tabBarController?.tabBar.isHidden = true
        items?.append(viewController)
        self.tabBarController?.viewControllers = items
        self.tabBarController?.selectedIndex = 2
//        weak var presentingViewController = self.presentingViewController
//
//        self.dismiss(animated: true, completion: {
//            presentingViewController?.present(viewController, animated: false, completion: nil)
//        })
        
//        self.show(viewController, sender: self)
//        self.present(viewController, animated: true) { () -> Void in
//            viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(ViewController.dismissChat(_:)))
//        }
    }
    
    func didFailWithError(_ error: BLDError!) {
    }
}

extension ViewController: OpalImagePickerControllerDelegate {
    func didClickUploadFile() {
        let actionSheet = UIAlertController(title: "Choose File Selector", message: nil, preferredStyle: .actionSheet)
        
        // Create your actions - take a look at different style attributes
        let mediaAction = UIAlertAction(title: "Choose media", style: .default) { (action) in
            //Example instantiating OpalImagePickerController with delegate
            let imagePicker = OpalImagePickerController()
            imagePicker.imagePickerDelegate = self
            imagePicker.maximumSelectionsAllowed = 10
            self.navigationController?.presentedViewController?.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("didPress cancel")
        }
        
        // Add the actions to your actionSheet
        actionSheet.addAction(mediaAction)
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

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
