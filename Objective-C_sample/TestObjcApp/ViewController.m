//
//  ViewController.m
//  TestObjcApp
//
//  Created by Extrieve Technologies Pvt Ltd on 14/06/23.
//

///Framework contains two Header file which is Necessary to import
/// QuickCaptureSDK-Swift.h and QuickCaptureFW.h
/// Inside the Framework Package you will find under the Header Folder
///
/// import "<Path to Framework>/QuickCaptureSDK.framework/Headers/QuickCaptureSDK-Swift.h"
/// import "<Path to Framework>/QuickCaptureSDK.framework/Headers/QuickCaptureFW.h"


#import "ViewController.h"


#ifdef RELEASE
/// Necessary For CameraHelper Support
#import "../../Build/Products/Release-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureSDK-Swift.h"
/// Necessary For ImgHelper Support
#import "../../Build/Products/Release-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureFW.h"
#else
/// Necessary For CameraHelper Support
#import "../../Build/Products/Debug-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureSDK-Swift.h"
/// Necessary For ImgHelper Support
#import "../../Build/Products/Debug-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureFW.h"

#endif


typedef void (^CaptureCallbackBlock)(NSArray<NSString *> * _Nonnull imageArray);

@interface ViewController ()
@property (nonatomic, copy, nullable) CaptureCallbackBlock captureCallback;
@property __block NSArray<NSString *>  *CapturedImages;
@end

@implementation ViewController




- (IBAction)btnLaunchCameraTap:(id)sender {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *directory = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] absoluteString];

    NSURL *url = [NSURL URLWithString:directory];
    if (!url) {
        return;
    }
    
    
    ///Some Configurations before starting the Camera Capture
    ///The camera Capture session will behave according to these settings
    NSURL *workingDirUrl = [url URLByAppendingPathComponent:@"QuickCaptureDemoWorking1"];
    CaptureSupport.OutputPath = [workingDirUrl absoluteString];
    CaptureSupport.CaptureSound = true;
    CaptureSupport.ColorMode = ColorModesRGB;
    CaptureSupport.CameraToggle = 2;
    CaptureSupport.EnableFlash = false;

    
    NSString *workingDir = [paths firstObject];
    
    
    ///This callback will be Required for CameraHelper.StartCapture as an argument.
    ///This will be called after the Capture Session is closed
    self.captureCallback = ^(NSArray<NSString *> * _Nonnull imageArray) {
        if (imageArray.count == 0) {
            NSLog(@"Error: no images found");
        }
        else{
            
            ///imageArray is the Argument where you get the Array od Strings
            ///these strings are the path of captured image saved in WorkingDirectory temporarily
            ///Note: Don't forget to delete image files after completion of task
            self->_CapturedImages = imageArray;
        }
    };
    
    ///Instanciating the CameraHelper Class to use its properties
    CameraHelper *cameraHelperObj = [[CameraHelper alloc] init];

        
    ///Start Capturing the Images from Camera using Framework
    ///It will save all the Captured images
    [cameraHelperObj StartCapture:self :workingDir : self.captureCallback];
}



///This button tap Action is providing the Usage of ImageHelper Class Properties
- (IBAction)btnActionTap:(id)sender{
    
    
    NSLog(@"%lu", (unsigned long)self->_CapturedImages.count);
    BOOL isExist = [NSFileManager.defaultManager fileExistsAtPath:self->_CapturedImages[0]];
    
    
    NSURL *workingDirURL = [NSURL URLWithString:CaptureSupport.OutputPath];
    if (!workingDirURL) {
    return;
    }

    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![manager fileExistsAtPath:workingDirURL.path isDirectory:&isDirectory] || !isDirectory) {
    NSError *error = nil;
    [manager createDirectoryAtPath:workingDirURL.path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
    NSLog(@"Unable to create output directory");
    }
    }

    NSURL *outputTiffURL = [workingDirURL URLByAppendingPathComponent:@"OutputPDF.JPEG"];
    NSError * _Nullable  err;
    
    
    ///Instanciating the ImgHelper class using GetInstance Method
    ImgHelper *img = [ImgHelper GetInstance];
    
    ///Setting the DPI as 100 using SetDpi method which takes enum value as an argument
    [img SetDpi:DPI_100];
    
    ///Setting the PageLayout as A4 using setPageLayout method which takes enum value as an argument
    [img setPageLayout:LayoutTypeA4];

    
    ///CompressAndGetThumbnail : This method Returns an UIImage object which is THumbnail of the image path passed as an argument
    ///It saves the compressed image on outputURI path
    ///Last argument "err" is for any excceptions occurs
    ///Note: Here we are providing the AbsoluteString as it take the FullPath to save the image
    UIImage* thumb = [img CompressAndGetThumbnail:self->_CapturedImages[0] outputURI:outputTiffURL.absoluteString err:&err];
    NSLog(@"%@",err.description);
    NSLog(@"%@",err.localizedDescription);
    
    ///Getting the ImageQuality
    int quality = [img getJPEGQuality];
    
    ///createPdfFileFromJpegArray : This method will create a PDF out of Images provided by the NSArray of NSString saves the pdf file in outputTiffURL provided as String
    ///First argument is working directory it should be readable and writeable directory where this function saves some temporary data then removes after completion
    ///Return Integer value as 0 means TRUE or success and vice versa
    int ret = [img createPdfFileFromJpegArray:workingDirURL.path :self->_CapturedImages :outputTiffURL.path :DPI_200 :DPI_200 :quality];
    
    NSLog(@"%d",ret);
    
    
    
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *Directory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject].absoluteString;
    NSURL *url = [NSURL URLWithString:Directory];
    if (!url) {
    return;
    }
    NSURL *workingDirUrl = [url URLByAppendingPathComponent:@"QuickCaptureDemoWorking1"];
    CaptureSupport.OutputPath = workingDirUrl.absoluteString;
    
}


@end
