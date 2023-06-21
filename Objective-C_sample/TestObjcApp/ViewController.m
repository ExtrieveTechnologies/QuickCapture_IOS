//
//  ViewController.m
//  TestObjcApp
//
//  Created by Extrieve Technologies Pvt Ltd on 14/06/23.
//

#import "ViewController.h"


#ifdef RELEASE
//For CameraHelper Support
#import "../../Build/Products/Release-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureSDK-Swift.h"
//For ImgHelperSupport
#import "../../Build/Products/Release-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureFW.h"
#else
//For CameraHelper Support
#import "../../Build/Products/Debug-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureSDK-Swift.h"
//For ImgHelperSupport
#import "../../Build/Products/Debug-iphoneos/QuickCaptureSDK.framework/Headers/QuickCaptureFW.h"

#endif

typedef void (^CaptureCallbackBlock)(NSArray<NSString *> * _Nonnull imageArray);




@interface ViewController ()
@property (nonatomic, copy, nullable) CaptureCallbackBlock captureCallback;

@end

@implementation ViewController


- (void) CallbackForCaptureCB:(NSArray<NSString *> *) imageArray
{
    return;
}


- (IBAction)btnLaunchCameraTap:(id)sender {



    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *directory = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] absoluteString];

    NSURL *url = [NSURL URLWithString:directory];
    if (!url) {
        return;
    }
    
    
    NSURL *workingDirUrl = [url URLByAppendingPathComponent:@"QuickCaptureDemoWorking1"];
    CaptureSupport.OutputPath = [workingDirUrl absoluteString];
    CaptureSupport.CaptureSound = true;

    
    NSString *documentDir = [paths firstObject];
    
    
    //Handling the captured images in this callback function
    self.captureCallback = ^(NSArray<NSString *> * _Nonnull imageArray) {
        if (imageArray.count == 0) {
            NSLog(@"Error: no images found");
        }
        else{
            NSLog(@"%lu", (unsigned long)imageArray.count);
            BOOL isExist = [NSFileManager.defaultManager fileExistsAtPath:imageArray[0]];
            
            ImgHelper *img = [ImgHelper GetInstance];
            
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
            
            [img SetDpi:DPI_100];
            [img setPageLayout:LayoutTypeA0];

            UIImage* thumb = [img CompressAndGetThumbnail:imageArray[0] outputURI:outputTiffURL.absoluteString err:&err];
            //UIImage* thumb = [img CompressAndGetThumbnailWithInputURI:imageArray[0] outputURI:outputTiffURL.absoluteString error:&err];
            NSLog(@"%@",err.description);
            NSLog(@"%@",err.localizedDescription);
            
            int ret = [img createPdfFileFromJpegArray:workingDirUrl.path :imageArray :outputTiffURL.path :200 :200 :40];
            
            NSLog(@"%d",ret);
        }
    };
    
    CameraHelper *cameraHelperObj = [[CameraHelper alloc] init];

        
    //Start Capturing the Images from Camera using Framework
    [cameraHelperObj StartCapture:self :documentDir : self.captureCallback];
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
