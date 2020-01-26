//
//  ViewController.swift
//  concurrency-and-background
//
//  Created by Mateusz Rybka on 24/01/2020.
//  Copyright © 2020 Mateusz Rybka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    
    let filesToDownload: [URL] = [
        URL(string: "https://upload.wikimedia.org/wikipedia/commons/c/ce/Petrus_Christus_-_Portrait_of_a_Young_Woman_-_Google_Art_Project.jpg")!,
        URL(string :"https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg")!,
        URL(string: "https://upload.wikimedia.org/wikipedia/commons/c/c8/Valmy_Battle_painting.jpg")!
    ]
    var tenPercentEvent: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for url in filesToDownload {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let downloadSession = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: url.relativePath), delegate: self, delegateQueue: OperationQueue.main)
                
                downloadSession.downloadTask(with: url).resume()
                debugPrint("Started download of file \(url)")
            }
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let file = session.configuration.identifier?.split(separator: "/").last
        
        let progress = Int(Float(totalBytesWritten) * 100 / Float(totalBytesExpectedToWrite))
        tenPercentEvent += Float(bytesWritten) * 100 / Float(totalBytesExpectedToWrite)
        
        if tenPercentEvent > 10 {
            tenPercentEvent -= 10
            debugPrint("Downloaded \(progress)% of file \(file!)")
        }
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        let file = session.configuration.identifier?.split(separator: "/").last
        debugPrint("Downloading of \(file!) completed. Location: \(location)")
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destination = docDir + "/" + file!
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destination) {
            try? fileManager.removeItem(atPath: destination)
        }
        try? fileManager.copyItem(atPath: location.absoluteString, toPath: destination)
        debugPrint("File copied to documents directory: \(destination)")
        
        let image = CIImage(contentsOf: location)!
        
        debugPrint("Started face detection task.")
        let faces = faceDetection(image: image)
        debugPrint("Face detection: Number of faces in \(file!) is: \(faces?.count ?? 0)")
    }
    
    func faceDetection(image: CIImage) -> [CIFeature]? {
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        return faceDetector?.features(in: image)
    }
}
