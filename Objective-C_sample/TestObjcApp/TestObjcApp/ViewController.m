//
//  ViewController.m
//  TestObjcApp
//
//  Created by Extrieve Technologies Pvt Ltd on 14/06/23.
//




#import "ViewController.h"


///Framework contains two Header file which is Necessary to import
/// QuickCaptureSDK-Swift.h and QuickCaptureFW.h
#import <QuickCaptureSDK/QuickCaptureFW.h>
#import <QuickCaptureSDK/QuickCaptureSDK-Swift.h>


#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^CaptureCallbackBlock)(NSArray<NSString *> * _Nonnull imageArray);

@interface ViewController ()
@property (nonatomic, copy, nullable) CaptureCallbackBlock captureCallback;
@property __block NSArray<NSString *>  *CapturedImages;

///A property to save an array of ui images loaded from the gallery
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedImages;

@end

@implementation ViewController 


//DEV_HELP: To get and check if the working directory is readable and writeable or not
- (NSString*)GetWorkingDirectory
{
    NSString *directory = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] absoluteString];

    NSURL *url = [NSURL URLWithString:directory];
    if (!url) {
        return @"";
    }
    
    ///Some Configurations before starting the Camera Capture
    ///The camera Capture session will behave according to these settings
    NSURL *workingDirUrl = [url URLByAppendingPathComponent:@"QuickCaptureDemoWorking1"];
    
    //DEV_HELP : Checking if Directory Exists or Not
    BOOL isDir = YES;
    BOOL tmp;
    NSError *err = [[NSError alloc] init];
    if (![NSFileManager.defaultManager fileExistsAtPath:workingDirUrl.path isDirectory:&isDir] || !isDir)
    {
        tmp =  [NSFileManager.defaultManager createDirectoryAtPath:workingDirUrl.path withIntermediateDirectories:false attributes:nil error:&err];
        if(tmp==NO)
        {
            NSLog(@"Unable to create Directory at  %@", workingDirUrl.path);
        }
        else
        {
            //Creating test file to check the folder is writeable or not
            NSURL *filePathURL = [workingDirUrl URLByAppendingPathComponent:@"test.txt"];
            BOOL ret = [NSFileManager.defaultManager createFileAtPath:filePathURL.path contents:nil attributes:nil];
            if (ret)
            {
                BOOL ret = [NSFileManager.defaultManager removeItemAtPath:filePathURL.path error:&err];
                if(!ret)
                {
                    NSLog(@"test file deletion failed");
                }
                else
                {
                    return workingDirUrl.absoluteString;
                }
            } else {
                NSLog(@"File not created.");
            }
            
        }
    }
    else
    {
        return workingDirUrl.absoluteString;
    }
    return @"";
}


- (IBAction)btnLaunchCameraTap:(id)sender {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *directory = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] absoluteString];

    NSURL *url = [NSURL URLWithString:directory];
    if (!url) {
        return;
    }

    //DEV_HELP : Getting Working Directory
    NSString* workingDirectory = [self GetWorkingDirectory];
    if(![workingDirectory  isEqual: @""])
    {
        CaptureSupport.OutputPath = workingDirectory;
    }
    else
    {
        NSLog(@"Invalid Working Directory");
    }
    

    
    ///Some Configurations before starting the Camera Capture
    ///The camera Capture session will behave according to these settings
    CaptureSupport.CaptureSound = true;
    CaptureSupport.ColorMode = ColorModesRGB;
    CaptureSupport.CameraToggle = 2;
    CaptureSupport.EnableFlash = false;

    CaptureSupport.MaxPage = 1;
    
    NSString *workingDir = [paths firstObject];
    
    
    ///DEV_HELP:::This callback will be Required for CameraHelper.StartCapture as an argument.
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
    
    ///Instanciating the ImgHelper class using GetInstance Method
    ImgHelper *imgObj = [ImgHelper GetInstance];
    
    ///Setting the DPI as 100 using SetDpi method which takes enum value as an argument
    [imgObj SetDpi:DPI_200];
    
    ///Setting the PageLayout as A4 using setPageLayout method which takes enum value as an argument
    [imgObj setPageLayout:LayoutTypeA4];
    
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
    
    NSLog(@"%@\n", CaptureSupport.SDKInfo);
    
    
    //DEV_HELP : Getting working directory
    NSString* workingDirectory = [self GetWorkingDirectory];
    if(![workingDirectory  isEqual: @""])
    {
        CaptureSupport.OutputPath = workingDirectory;
    }
    else
    {
        NSLog(@"Invalid Working Directory");
    }
    
    
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

    NSURL *outputPdfURL = [workingDirURL URLByAppendingPathComponent:@"OutputImage.tiff"];
    NSError * _Nullable  err;
    
    
    ///Instanciating the ImgHelper class using GetInstance Method
    ImgHelper *imgObj = [ImgHelper GetInstance];
    
    ///Setting the DPI as 100 using SetDpi method which takes enum value as an argument
    [imgObj SetDpi:DPI_200];
    
    ///Setting the PageLayout as A4 using setPageLayout method which takes enum value as an argument
    [imgObj setPageLayout:LayoutTypeA4];

    
    ///CompressAndGetThumbnail : This method Returns an UIImage object which is THumbnail of the image path passed as an argument
    ///It saves the compressed image on outputURI path
    ///Last argument "err" is for any excceptions occurs
    ///Note: Here we are providing the AbsoluteString as it take the FullPath to save the image
    //UIImage* thumb = [imgObj CompressAndGetThumbnail:self->_CapturedImages[0] outputURI:outputTiffURL.absoluteString err:&err];
    
    
    ///Getting the ImageQuality
    int quality = [imgObj getJPEGQuality];
    ///createPdfFileFromJpegArray : This method will create a PDF out of Images provided by the NSArray of NSString saves the pdf file in outputTiffURL provided as String
    ///First argument is working directory it should be readable and writeable directory where this function saves some temporary data then removes after completion
    ///Return Integer value as 0 means TRUE or success and vice versa
    int ret = [imgObj createPdfFileFromJpegArray:workingDirURL.path :self->_CapturedImages :outputPdfURL.path :DPI_200 :DPI_200 :quality];
    NSLog(@"%d",ret);
    //NSMutableArray<UIImage*> *tiffImages = [self GetUIimageArrayFromTiffURL:outputPdfURL];
    [self shareFileWithURL:outputPdfURL];
    


    
}


- (IBAction)btnConvertToTiffTap:(id)sender {
    
    
    //DEV_HELP : Getting Working Directory
    NSString* workingDirectory = [self GetWorkingDirectory];
    if(![workingDirectory  isEqual: @""])
    {
        CaptureSupport.OutputPath = workingDirectory;
    }
    else
    {
        NSLog(@"Invalid Working Directory");
    }
    
    //Save each selected images to Temp Path and create an array of string with the paths
    NSMutableArray<NSString*> *imagePathArray = [NSMutableArray array];
    NSInteger num = 0;
    NSURL* workingDirUrl = [[NSURL alloc] initWithString:CaptureSupport.OutputPath];
    for(UIImage *image in self->_selectedImages)
    {
        //Creating filename
        num = num + 1;
        NSNumber* numObj = [NSNumber numberWithLong:num];
        NSString* numCount = [numObj stringValue];
        NSString* tempName = @"Temp";
        NSString* fileName = [tempName stringByAppendingString:numCount];
        fileName = [fileName stringByAppendingString:@".jpeg"];
    
        
        //Creating Path using filename
        NSURL *filePathURL = [workingDirUrl URLByAppendingPathComponent:fileName];
        
        //Writing imageData to temporary path
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        BOOL success = [imageData writeToFile:filePathURL.path atomically:YES];
        if(success == YES)
        {
            NSLog(@"Image saved : %@",filePathURL.path);
            [imagePathArray addObject:filePathURL.path];
        }
    }
    
    //DEV_HELP: Some configurations based on the ImgHelper Class
    [ImgHelper.shared setDPI:DPI_200];
    [ImgHelper.shared setPageLayout:LayoutTypeA4];
    //DEV_HELP: Call Convert to Tiff function from ImgHelper
    NSURL *outputTiffURL = [workingDirUrl URLByAppendingPathComponent:@"OutputImage.tiff"];
    [ImgHelper.shared setDPI:DPI_200];
    [ImgHelper.shared setPageLayout:LayoutTypeA4];
    DPI dpi = [ImgHelper.shared getDPI];
    
    CameraHelper *cameraHelperObj = [[CameraHelper alloc] init];
    NSString* str = [cameraHelperObj BuildTiff:imagePathArray :outputTiffURL.path :nil];
    
    //Checking if file present or not
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:outputTiffURL.path];
    if(fileExists)
    {
        NSLog(@"Tiff creation success");
    }
    //DEV_HELP: You can get images as UIImage by using below function call
    //Get multipage tiff file as Array of UIImage
    //NSMutableArray<UIImage*> *tiffImages = [self GetUIimageArrayFromTiffURL:outputTiffURL];
    
    //DEV_HELP: This is utility function to test the images by sharing to other devices
    [self shareFileWithURL:outputTiffURL];
}

//DEV_HELP: This is the function definion which takes the URL of the TIFF image and gives UIImage Array for each pages
- (NSMutableArray<UIImage*>*) GetUIimageArrayFromTiffURL:(NSURL*)tiffImageURL {
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)tiffImageURL, NULL);

    NSUInteger pageCount = CGImageSourceGetCount(imageSource);

    NSMutableArray<UIImage *> *imageArray = [[NSMutableArray alloc] init];

    for (NSUInteger pageIndex = 0; pageIndex < pageCount; pageIndex++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSource, pageIndex, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [imageArray addObject:image];
        
        CGImageRelease(imageRef);
    }

    CFRelease(imageSource);

    return imageArray;

}

- (void)shareFileWithURL:(NSURL *)fileURL {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:activityViewController animated:YES completion:nil];
}


//DEV_HELP: Utility function to load the image from gallery, it open gallery to select an image
- (void)presentImagePicker {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.navigationBar.tintColor = [UIColor blackColor];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//DEV_HELP: A callback hits when the user finish the image picking from the gallery
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSMutableArray<UIImage *> *selectedImages = [NSMutableArray array];
    
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
        [selectedImages addObject:originalImage];
    }
    
    // Continue presenting the picker if you want to allow multiple selections
    // or dismiss the picker and handle the selected images here
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // Handle the selected images from the array
        NSLog(@"%lu",selectedImages.count);
        
        NSString *numberString = self->_lblSelectedImages.text;
        NSInteger number = [numberString integerValue];
        number = number + 1;
        NSNumber *num = [NSNumber numberWithInt:number];
        numberString = [num stringValue];
        self->_lblSelectedImages.text = numberString;
    
        [self->_selectedImages addObject:selectedImages.firstObject];
    }];
}

//DEV_HELP: CallBack hits when user cancels the picking of image from the Gallery
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnLoadFromGalleryTap:(id)sender {
    
    [self presentImagePicker];
    
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    //DEV_HELP : IMPORTANT Configuration to perforn any Task
    NSString* workingDirectory = [self GetWorkingDirectory];
    if(![workingDirectory  isEqual: @""])
    {
        
        CaptureSupport.OutputPath = workingDirectory;
    }
    else
    {
        NSLog(@"Invalid Working Directory");
    }
    
    self->_selectedImages = [NSMutableArray array];
}


@end
