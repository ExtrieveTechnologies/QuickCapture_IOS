//
//  ViewController.swift
//  TestSwiftApp
//
//  Created by Extrieve Technologies Pvt Ltd on 14/06/23.
//

import UIKit

//DEV_HELP: This is import statement required
import QuickCaptureSDK

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //String array contains path of images which are compressed and captured from QC Camera
    var CapturedImages : [String] = [String]()

    //String array contains path of images which are Loaded from Gallery of the phone
    var JPEGImages : [UIImage] = [UIImage]()
    @IBOutlet weak var selectedImageCountLabel: UILabel!
    
    @IBOutlet weak var capturedImageCountLabel: UILabel!
    @IBAction func btnLaunchCameraTap(_ sender: Any) {
        
        
        ///Some Configurations before starting the Camera Capture
        ///The camera Capture session will behave according to these settings
        ///This need to be set once anywhere before inititalization
        Config.CaptureSupport.CaptureSound = true;
        Config.CaptureSupport.ColorMode = ColorModes.RGB;
        Config.CaptureSupport.CameraToggle = 2;
        Config.CaptureSupport.EnableFlash = false;

        Config.CaptureSupport.MaxPage = 3;
        
        
        //DEV_HELP: Instanciating the Camera Helper Class
        let cameraHelper = CameraHelper()
        
        ///Start Capturing the Images from Camera using Framework
        ///It will save all the Captured images
        cameraHelper.StartCapture( sender: self, workingDirectory: Config.CaptureSupport.OutputPath, callback: camerahelperCallback)
        
    }
    
    
    ///DEV_HELP:::This callback will be Required for CameraHelper.StartCapture as an argument.
    ///This will be called after the Capture Session is closed
    func camerahelperCallback(paths: [String]) -> Void
    {
        
        ///paths is the Argument where you get the Array od Strings
        ///these strings are the path of captured image saved in WorkingDirectory temporarily
        ///Note: Don't forget to delete image files after completion of task
        CapturedImages = paths
        
        //Updating the label
        self.capturedImageCountLabel.text = String(paths.count)
    }
    
    
    //Function to convert to PDF using QuickCapture Framework triggered by button TAP
    @IBAction func btnConvertToPDFTap(_ sender: Any)
    {
        
        ///DEV_HELP:  Some Configurations are inside ImgHelper Class
        ImgHelper.shared.setDPI(DPI._200)
        ///DEV_HELP: Setting PageLayout
        ImgHelper.shared.setPageLayout(LayoutType.A4)
        
        
        ///DEV_HELP: ImgHelper class is not required to Instanciate
        ///we can directly use it like this
        let dpi = ImgHelper.shared.getDPI()
        
        
        //Getting Quility based on the config we set earlier
        let Quality = ImgHelper.shared.getJPEGQuality()
        
        guard let workingDirURL = URL(string: Config.CaptureSupport.OutputPath)else{
            return
        }
        
        //Creating temporary file name
        let fileName = String(Int(NSDate().timeIntervalSince1970))
        
        //Creating temporary file URL
        guard let pdfURL = URL(string: Config.CaptureSupport.OutputPath)?.appendingPathComponent(fileName + "_QCOutput_PDF.pdf")else
        {
            return
        }
        
        ///createPdfFileFromJpegArray : This method will create a PDF out of Images provided by the NSArray of NSString saves the pdf file in outputTiffURL provided as String
        ///First argument is working directory it should be readable and writeable directory where this function saves some temporary data then removes after completion
        ///Return Integer value as 0 means TRUE or success and vice versa
        let ret = ImgHelper.shared.createPdfFileFromJpegArray(workingDirURL.path, CapturedImages, pdfURL.path, dpi, dpi, Quality)
        if(ret == 0)
        {
            print("PDF Creation Success")
        }
        else
        {
            print("PDF Creation Failed")
        }
        var sharePaths = [String]()
        sharePaths.append(pdfURL.path)
        shareFiles(paths: sharePaths)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let Directory = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).first!.absoluteString
        let manager = FileManager.default
        guard let url = URL(string: Directory)else{
            return
        }
        let workingDirUrl = url.appendingPathComponent("QuickCaptureDemoWorking1")
        
        
        //Configurabale settings based on the Config Class.
        Config.CaptureSupport.CaptureSound = true
        Config.CaptureSupport.EnableFlash = false
        Config.CaptureSupport.OutputPath = workingDirUrl.absoluteString
        Config.CaptureSupport.ColorMode = ColorModes.RGB
        
        
        let licenseFileName = "TestSwiftApp_Zeeshan_15-06to16-07_15062023"
        let licenseFileExtension = "lic"
        let licenseData : String
        if let fileURL = Bundle.main.url(forResource: licenseFileName, withExtension: licenseFileExtension)
        {
            do{
                let fileContents = try String(contentsOf: fileURL)
                licenseData = fileContents
            }
            catch{
                print("Error reading license file:" + error.localizedDescription)
                licenseData = ""
            }
        }
        else
        {
            print("License file not found | \(licenseFileName)");
            licenseData = ""
        }
        
        ///
        
        let ret = ImgHelper.shared.UnlockLibrary(mainBundle: Bundle.main, licenseFile: licenseData)
        if(ret)
        {
            print("Library Unlock Success")
        }
        else
        {
            print("Library unlock failed")
        }
    }

    @IBAction func LoadFromGalleryTap(_ sender: Any) {
        
        //Load Image from Gallery
        LoadFromGallery(sender)
    }
    
    func LoadFromGallery(_ sender: Any)
    {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = false
        present (vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage{
            JPEGImages.append(selectedImage)
            selectedImageCountLabel.text = String(JPEGImages.count)
        }
        else
        {
            print("Image Not Found")
        }
        
        picker.dismiss(animated: true)
    }
    
    
    //This will convert the Gallery Images into Tiff file
    @IBAction func btnConvertToTiffTap(_ sender: Any)
    {
        var fileArray = [String]()
        for image in JPEGImages
        {
            //Creating a temporary file name
            let fileName = String(Int(NSDate().timeIntervalSince1970))
            
            guard let jpegURL = URL(string: Config.CaptureSupport.OutputPath)?.appendingPathComponent(fileName + "_QCOutput_JPEG.jpeg")else
            {
                return
            }
            
            ///DEV_HELP :
            ///It saves the compressed image on outputURI path
            ///Note: Here we are providing the AbsoluteString as it take the FullPath to save the image
            let ret = ImgHelper.shared.CompressToJPEG(image: image, outputURI: jpegURL.absoluteString)
            if(ret == true)
            {
                //Adding saved images path to an array to create TIFF from it
                fileArray.append(jpegURL.path)
            }
            else
            {
                print("Compress to JPEG ::: Failed")
            }
        }
        
        //Share JPEG
        var paths = [String]()
        if(fileArray.count > 0)
        {
            
            //Compress to JPEG
            let fileName = String(Int(NSDate().timeIntervalSince1970))
            guard let outputTiffURL = URL(string: Config.CaptureSupport.OutputPath)?.appendingPathComponent(fileName + "_QCOutput_JPEG.TIFF")else
            {
                return
            }
            
            let obj = CameraHelper()
            do
            {
                //createTiffFileFromJpegArray : This method will create a TIFF out of Images provided by the NSArray of NSString saves the tiff file in outputTiffURL provided as String
                ///First argument is working directory it should be readable and writeable directory where this function saves some temporary data then removes after completion
                ///Return string in format below
                ///SUCCESS:::"+TiffFilePath --- if SUCCESS
                ///FAILED:::Reason --- if FAILED
                let status = try obj.BuildTiff(ImageArray: fileArray, TiffFilePath: outputTiffURL.path)
                print(status)
            }
            catch{
                print(error)
            }
            
            paths.append(outputTiffURL.path)
        }
        shareFiles(paths: paths)
    }
    
    //Utility function to share files
    func shareFiles(paths: [String])
    {
        // Create the Array which includes the files you want to share
        var filesToShare = [Any]()
        for str in paths{
            let fileURL = NSURL(fileURLWithPath: str)
            // Add the path of the file to the Array
            filesToShare.append(fileURL)
        }
        // Make the activityViewContoller which shows the share-view
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

        // Be notified of the result when the share sheet is dismissed
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            self.dismiss(animated: true)
        }

        // Show the share-view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
}

