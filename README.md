<img class="img-fluid" align="center" src="https://raw.githubusercontent.com/ExtrieveTechnologies/QuickCapture/main/img/QuickCapture.png" width="30%" alt="img-verification"><img align="right" class="img-fluid" width="8%" src="https://raw.githubusercontent.com/ExtrieveTechnologies/QuickCapture/main/img/apple-ios.png" alt="img-verification">

  

## Document Scanning-Capture SDK IOS v4.0

QuickCapture Mobile Scanning SDK Specially designed for native IOS from [Extrieve](https://www.extrieve.com/).
> It's not "****just****" a scanning SDK. It's a "****document****"
scanning/capture SDK evolved with ****Best Quality****, ****Highest Possible Compression****, ****Image Optimisation****, keeping output quality of the document in mind.  

> Control ****DPI****,****Layout**** & ****Size**** of output images and can convert them into ****PDF & TIFF****
  
> ****QR code**** & ****BAR Code**** Scanning & Generation
  
> ****Developer-friendly**** & ****Easy to integrate**** SDK.
  
> ****Works entirely offline****, locally on the device, with ****no data transferred to any server or third party****.
  
  *_For reduced build size if needed, an initial internet connection may optionally be required to fetch ML data or resource files, depending on the specific integration and features used by the consumer application_*
  
> ****End of support Notice**** :  QuickCapture SDK IOS ****V1**** deprecated by June. 2023.For any further updates and support, can use ****V2****

> which having no major modifications.But with improved funcionalities,feature additions and fixes.
> QuickCapture SDK Android ****V2**** deprecated by Dec. 2024.For any further updates and support, can use ****V4**** & bugfixes on ****V3****
  
### Other available platform options

- [Android](https://github.com/ExtrieveTechnologies/QuickCapture_Android)

- [Fultter Plugin](https://pub.dev/packages/quickcapture)

- [Web SDK](https://github.com/ExtrieveTechnologies/QuickCapture_WEB)

  

  

## Compatibility

* ****Minimum IOS version****: QuickCapture v4.0 requires a minimum **iOS 12**.
* Compatible with ****Swift**** and ****Objective-C****
* Required Operating System: **iphoneos**

  ## Run-time requirement

- [x] This SDK is designed to run on officially supported Android & **iOS devices** only.
- [x] Supported CPU architectures: **arm64**.
- [x] Simulator and emulator environments are not supported.For testing on simulators, please contact the development support team to request a dedicated test version compatible with those environments.


Download
--------

You can download sdk as ****framework**** in ****.zip**** file from GitHub's [releases page](https://github.com/ExtrieveTechnologies/QuickCapture_IOS/releases).

  

QuickCaptureSDK IOS  ****v4.0****

  

## API  and  integration  Details

SDK has three core classes and supporting classes :

1. ****`CameraHelper`****  -  *_Handle the  camera  related  operations. Basically,  an  activity._*

2. ****`ImgHelper`****  - *_Purpose of this class is to handle all imaging related operations._*

3. ****`HumanFaceHelper`**** - *_Advanced Ai based utility class handles all functionalities such as face detection, extraction,matching & related functions._*

4. ****`Config`****  -  *_Holds various configurations of SDK._*

5. ****`ImgException`****  -  *_Handle all exceptions on Image related operations on ImgHelper._*

Based on the requirement any one or all classes can be used. And need to import those from the  SDK.
```swift
//Swift
import QuickCaptureFW;
```
```objectivec
//Objective-C

#import <QuickCaptureSDK/QuickCaptureFW.h>
#import <QuickCaptureSDK/QuickCaptureSDK-Swift.h>

```

---

## 1. CameraHelper

This  class  will  be  implemented  as  an  activity.  This  class  can  be  initialized  as  normal class.
```swift
//Swift

var cameraHelper = CameraHelper();
```
```objectivec
//Objective-C

CameraHelper *camerahelper = [[CameraHelper alloc] init];
```
With an activity call, triggering the SDK for capture activity can be done.Most operations in ****`CameraHelper`**** is ****view based****.
```swift
//Swift

cameraHelper.StartCapture(
	sender:self,
	//pathtowritabledirectorywherecaptured
	//files are stored temporarily for processing
	workingDirectory:“”,
	callback:cameraHelperCallBack
)

func cameraHelperCallback(_ImageArray:[String])->Void {

//paths-  arrayofcapturedimagesavailablehere.

//Use returned images

}
```

```objectivec
//Objective-C

@property (nonatomic, copy, nullable) CaptureCallbackBlock captureCallback;

self.captureCallback = ^(NSArray<NSString *> * _Nonnull imageArray) {
		if (imageArray.count == 0) {
		NSLog(@"Error: no images captured");
	}
	else{
		///imageArray is the Argument where you get the Array of Strings
		///these strings are the path of captured image saved in WorkingDirectory temporarily
		///Note: Don't forget to delete image files after completion of task
		self->_CapturedImages = imageArray;
	}
};

//Starts Camera Capture Activity
[cameraHelper StartCapture:self :workingDir : self.captureCallback];
```
SDK is having multiple flows as follows :

* ****CAMERA_CAPTURE_REVIEW**** - *_Default flow. Capture with SDK Camera_ ****_->_**** _review._*

* ****SYSTEM_CAMERA_CAPTURE_REVIEW**** - *_Capture with system default camera_ ****_->_**** _review._*

* ****IMAGE_ATTACH_REVIEW**** - *_Attach/pass image_ ****_->_**** _review._*

****1. CAMERA_CAPTURE_REVIEW**** - *_Default flow of the CameraHelper. Includes Capture with SDK Camera -> Review Image._*
```swift
//swift

Config.CaptureSupport.CaptureMode = CaptureModes.CAMERA_CAPTURE_REVIEW
```
```objectivec
//objective-c

CaptureSupport.CaptureMode = CaptureModesCAMERA_CAPTURE_REVIEW;
```
****2. SYSTEM_CAMERA_CAPTURE_REVIEW**** - *_If user needs to capture an image with system default camera, this can be used. It includes Capture with system default camera -> Review_*.
```swift
//swift

Config.CaptureSupport.CaptureMode = CaptureModes.SYSTEM_CAMERA_CAPTURE_REVIEW
```
```objectivec
//objective-c

CaptureSupport.CaptureMode = CaptureModesSYSTEM_CAMERA_CAPTURE_REVIEW;
```
****3. IMAGE_ATTACH_REVIEW**** - *_This option can be used if the user needs to review an image from their device's gallery. After attaching each image, the review and all dependent functionalities become available_*.
```swift
//swift

Config.CaptureSupport.CaptureMode = CaptureModes.IMAGE_ATTACH_REVIEW
```
```objectivec
//objective-c

CaptureSupport.CaptureMode = CaptureModesIMAGE_ATTACH_REVIEW;
```
## 2. Config

The SDK includes a supporting class called for static configuration. This class holds all configurations related to the SDK. It also contains sub-configuration collection for further organization.

This includes:  :

****CaptureSupport**** - Contains all the Capture & review related configurations. ****Config.CaptureSupport**** contains various configurations as follows:

- ****`OutputPath`**** - To set the output directory in which the captured images will be saved. Base app should have permissions to write to the provided path.

```swift
//Swift

Config.CaptureSupport.OutputPath = “pass output path as string”
```
```objectivec
//Objective-C

CaptureSupport.OutputPath = “pass output path as string”;
```

- ****`MaxPage`**** - To set the number of captures to do on each camera session. And this can also  control  whether  the  capture  mode  is  single  or  multi  i.e

> if  `MaxPage` <= 0 //  not  set:  means  unlimited.
> If  `MaxPage`  >= 1 // means  limited.

```swift
// MaxPage <= 0  : Unlimited Capture Mode

// MaxPage = 1 : Limited Single Capture

// MaxPage > 1 : Limited Multi Capture Mode

//Swift

Config.CaptureSupport.MaxPage = 0
```
```objectivec
//Objective-C

CaptureSupport.MaxPage = 0;
```

- ****`ColorMode`****  -  To  Set  the  capture  color  mode-  supporting  color  and  grayscale.
>`RGB` `GRAY`
```swift
//Swift

Config.CaptureSupport.ColorMode = ColorModes.RGB
```
```objectivec
//Objective-C

CaptureSupport.ColorMode = ColorModesRGB
```

- ****`EnableFlash`****  -  Enable  Document  capture  specific  flash  control  for  SDK  camera.

```swift
//Swift

Config.CaptureSupport.EnableFlash  =  true;
```
```objectivec
//Objective-C

CaptureSupport.EnableFlash  =  true;
```

- ****`CaptureSound`****  -  To  Enable  camera  capture  sound.

```swift
//Swift

Config.CaptureSupport.CaptureSound  =  true;
```
```objectivec
//Objective-C

CaptureSupport.CaptureSound  =  true;
```

- ****`ShowCaptureCountAndLimit`****  - Enable/Disable  Capture count as toast at bottom while capturing from  SDK camera.

```swift
//Swift

Config.CaptureSupport.ShowCaptureCountAndLimit  =  true;
```
```objectivec
//Objective-C

CaptureSupport.ShowCaptureCountAndLimit  =  true;
```

- ****`SDKInfo`****  - Contains  all  version  related  information  on  SDK.

```swift
//Swift

Config.CaptureSupport.SDKInfo
```
```objectivec
//Objective-C

CaptureSupport.SDKInfo;
```
- ****`CameraToggle`****  -  Toggle  camera  between  front  and  back.

`0` Disable camera toggle option.
`1` Enable camera toggle option with Front camera by default.
`2` Enable camera toggle option with Back camera  by default.
```swift
//Swift

Config.CaptureSupport.CameraToggle  =  2;
```
```objectivec
//Objective-C

CaptureSupport.CameraToggle  =  2;
```


## 3. `ImgHelper`

Following  are  the  options/methods  available  from  class  ****`ImgHelper`**** :

To instanciate this class

```swift

//Swift

let ImgHelper = ImgHelper.GetInstance()
```
```objectivec

//Objective-C

ImgHelper *ImgHelper = [ImgHelper GetInstance];

```

- ****_*SetImageQuality*_**** - *_Set the Quality of the image, Document_Quality isused. If documents are used further for any automations and OCR, use Document_Quality._*

>*_Available Image Qualities_* :
>1. `Photo_Quality`
>2. `Document_Quality`
>3. `Compressed_Document`

```swift
//Swift

ImgHelper.shared.SetImageQuality(value: ImageQuality.Document_Quality)

//OR

ImgHelperObj.SetImageQuality(value: ImageQuality.Document_Quality)
```
```objectivec
//Objective-C

[ImgHelperObj SetImageQuality:ImageQualityDocument_Quality];
```

- *****SetPageLayout***** - *_Set the Layout for the images generated/processed by the system._*
>*_Available layouts_* : A1, A2, A3, **`A4`**, A5, A6, A7,PHOTO & CUSTOM

*_A4 is the most recommended layout for document capture scenarios._*
```swift
//swift
ImgHelper.shared.SetPageLayout(LayoutType.A4)

//OR

ImgHelper.SetPageLayout(LayoutType.A4)
```
```objectivec
//objective-c

[ImgHelperObj SetPageLayout:LayoutTypeA4];
```

- *****SetDPI***** - *_Set DPI (depth per inch) for the image._*

>*_Available DPI_* : DPI_150, **`DPI_200`**, DPI_300, DPI_500, DPI_600

*_150 & 200 DPI is most used. And 200 DPI recommended for OCR and other image extraction prior to capture._*
```swift
//Swift
ImgHelper.shared.SetDPI(DPI._200)

//OR

ImgHelperObj.SetDPI(DPI._200)
```
```objectivec
//objective-c

[ImgHelperObj SetDpi:DPI_200];
```
- *****SetResizeMode***** - *_This method manages how the resizing of captured images are processed and output is created accordingly._*
>***Available Resize Modes:***
>
>`STRETCH_TO_EXACT_SIZE` - Stretches the image to match exact width & height.
>**`PRESERVE_ASPECT_ONLY`** - Tries to fit within the given width & height to preserve quality at its best. 	
>`FIT_WITH_ASPECT` - Output image will be the exact size with white background colour if the captured image does not fits.
```swift
//swift

ImgHelper.shared.SetResizeMode(mode: ResizeMode.PRESERVE_ASPECT_ONLY)
```
```objectivec
//objective-c

[ImgHelper.shared SetResizeModeWithMode:ResizeModePRESERVE_ASPECT_ONLY];
```
- *****SetCustomLayOut***** - *_Sets the output image width and height, so that the output image will be resized accordingly. Accepted input parameters are in `inches` only._*
```swift
//swift

ImgHelper.shared.SetCustomLayOut(CustomWidth: 0.8, CustomHeight: 1.1)
```
```objectivec
//objective-c

[ImgHelper.shared  SetCustomLayOutWithCustomWidth:0.8  CustomHeight:1.1];
```
- *****SetCustomLayOutInPixels***** - *_Sets the output image width and height, so that the output image will be resized accordingly. Accepted input parameters are in `pixels` only._*
```swift
//swift

ImgHelper.shared.SetCustomLayOutInPixels(CustomWidth: 640, CustomHeight: 480)
```
```objectivec
//objective-c

[ImgHelper.shared  SetCustomLayOutInPixelsWithCustomWidth:640  CustomHeight:480];
```

- *****GetThumbnail***** - *_This method Will build thumbnail for the given image in custom width,height & AspectRatio._*

```swift
//Swift

do{
	try UIImage thumb = ImgHelper.shared.GetThumbnail(bm: image,rHeight: 600,rWidth: 600,AspectRatio: true)
}
catch{
	print(error);
}
/*
UIImage GetThumbnail(
@NonNull  UIImage bm,
int reqHeight,
int reqWidth,
Boolean AspectRatio )throws ImgException.
*/

```

```objectivec
//Objective-C

UIImage *thumb = [ImageHelper GetThumbnail:image :600 :600 :true :&err];

/*
UIImage GetThumbnail(
@NonNull  UIImage image,
int reqHeight,
int reqWidth,
Boolean AspectRatio,
NSError err ).
*/

```

- *****CompressToJPEG***** - *_This method will Compress the provided bitmap image and will save to given path._*

```swift
//Swift

let isCompressed = ImgHelper.shared.CompressToJPEG(image: image, outputURI: jpegURL.absoluteString)

/*
Boolean CompressToJPEG(UIImage image,String outputFilePath)
throws ImgException
*/

```

```objectivec
//Objective-C

BOOL isCompressed = [ImageHelper CompressToJPEG:image :outputJPEGURL.absoluteString];
```

- *****RotateBitmap***** - *_This method will rotate the image to preferred orientation._*

```swift

//Swift

UIImage rotatedBm = ImgHelper.shared.RotateBitmap(image: img, orientation: ImageOrientation.left);

/*
UIimage RotateBitmap(UIimage image,enum ImageOrientation)
throws ImgException
Available Options for Orientation
*/
enum ImageOrientation : Int {
	up
	down
	left
	right
	upMirrored
	downMirrored
	leftMirrored
	rightMirrored
}
```
```objectivec
//Objective-C

UIImage *rotatedImage = [ImageHelper RotateBitmap:image :ImageOrientationUp :&err];

```

- ****BuildTiff****  -  Build `.tiff file` output from the list of images shared.

```swift
//Swift

do{
	let status = try ImgHelper.shared.BuildTiff(ImageArray: fileArray, TiffFilePath: outputTiffURL.path)
	print(status)
}
catch{
	print(error)
}

*@param  "Image  File  path  collection  as  Array of String"

*@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::TIFF  file  path".

```
```objectivec
//Objective-C

NSError *error = nil;
NSString *outputPath = [ImgHelper.shared BuildTiff:imageArray TiffFilePath:tiffFilePath error:&error];

*@param  "Image  File  path  collection  as  Array of String"
*@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::TIFF  file  path".
```

- ****BuildPDF****  -  Build  PDF  file  output  file  from  last  captured  set  of  images.

```swift
//Swift
do {
	let status = try ImgHelper.shared.BuildPdf(ImageArray: fileArray, PdfFilePath: outputPDFURL.path)
	print(status)
}
catch {
	print(error)
}

*@param  "Image  File  path  collection  as  Array of String"
*@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::PDF  file  path".
```
```objectivec
//Objective-C

NSError *error = nil;
NSString *outputPath = [ImgHelper.shared BuildPdf:ImageArray PdfFilePath:pdfFilePath error:&error];


*@param  "Image  File  path  collection  as  Array of String"
*@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::PDF  file  path".
```
>  ****Recommended Settings:****

>  - ImageQuality: `Document_Quality`

>  - DPI: `150` or `200`

>  - LayoutType: `A4`

>  - ResizeMode: `PRESERVE_ASPECT_ONLY`

## ImgException

As a part of exceptional error handling ****ImgException**** class is available.

- *_Following are the possible errors and corresponding codes_*:

- CREATE_FILE_ERROR= ****-100****;

- IMAGE_ROTATION_ERROR= ****-101****;

- LOAD_TO_BUFFER_ERROR= ****-102****;

- DELETE_FILE_ERROR= ****-103****;

- GET_ROTATION_ERROR= ****-104****;

- ROTATE_BITMAP_ERROR= ****-105****;

- BITMAP_RESIZE_ERROR= ****-106****;

- CAMERA_HELPER_ERROR= ****-107****;

- LOG_CREATION_ERROR= ****-108****;

- IMAGE_COMPRESSION_ERROR= ****-109****;

## 4. `HumanFaceHelper`

QuickCapture SDK equipped with advanced face identification intelligence can accurately detect human faces within documents and match them precisely. ****SDK needs to be activated using a proper license**** with `Config.License.Acivate()`; for the plus features to initialize.

`Initialization Callback`:

```swift
//swift
//InitializationCallback is the protocol to inherit
class YourClassName: NSObject, InitializationCallback {
    //This will be called when initialization process is success
    func onInitializationSuccess() {
        print("Initialization succeeded.")
    }
    //This will be called when initialization process is failed
    func onInitializationFailure(error: Error) {
        print("Initialization failed with error: \(error.localizedDescription)")
    }
}
```
```objectivec
//objective-c
@interface HumanFaceHelperInitCallback : NSObject <InitializationCallback>
@end

@implementation HumanFaceHelperInitCallback

- (void)onInitializationSuccess {
	NSLog(@"Initialization succeeded");
}

- (void)onInitializationFailureWithError:(NSError *)error {
	NSLog(@"Initialization failed: %@", error.localizedDescription);
}
@end
```
*Instanciation :*
```swift
//swift

var humanFaceObj: HumanFaceHelper? = nil
do{
	humanFaceObj = try HumanFaceHelper.init(mainBundle: Bundle.main, callback: self)
}
catch let error as  FaceHelperException{
	print("Error code: \(error.code), Error message: \(error.Description)")
	return
}
catch{
	print("Unknown Error Occured: \(error)")
	return
}

@Param - mainBundle //bundle of the caller application.
@Param - callback 	//object of the class which inherits InitializationCallback or self if inherited by the same class which is instanciating.
@Return 			//instance  of the HumanFaceHelper class 
```
```objectivec
//objective-c

NSError *error = nil;
HumanFaceHelperInitCallback *initCallback = [HumanFaceHelperInitCallback  new];
NSBundle *bundle = [NSBundle mainBundle];
HumanFaceHelper *humanFaceObj = [[HumanFaceHelper alloc] initWithMainBundle:bundle callback:initCallback error:&error];

@Param - mainBundle //bundle of the caller application.
@Param - callback 	//object of the class which inherits InitializationCallback or self if inherited by the same class which is instanciating.
@Return 			//instance  of the HumanFaceHelper class 
```
OR
_You can directly instantiate using Anonymous style callbacks within the statement_
```swift
//swift

let humanFaceObj = try HumanFaceHelper(
    mainBundle: .main,
    callback: {
        class AnonymousCallback: NSObject, InitializationCallback {
            let onSuccess: () -> Void
            let onFailure: (Error) -> Void
            init(onSuccess: @escaping () -> Void, onFailure: @escaping (Error) -> Void) {
                self.onSuccess = onSuccess
                self.onFailure = onFailure
            }
            func onInitializationSuccess() {
                onSuccess()
            }
            func onInitializationFailure(error: Error) {
                onFailure(error)
            }
        }
        return AnonymousCallback(
            onSuccess: { print("✅ Init Success") },
            onFailure: { error in print("❌ Init Failed: \(error.localizedDescription)") }
        )
    }()
)
``` 

Following are the options/methods available from the class ****`HumanFaceHelper`**** :

- ****DetectHumanFaces**** \- DetectHumanFaces Method from `humanFaceObj`  will Identify human faces from provided image and return the detected details in json string format using `response callbacks`. It also supports both Anonymous style callback or inherited protocol style like we did while instantiating.

```swift
//swift

humanFaceObj.DetectHumanFaces(inputImage: yourUIImage, callback: {
	class AnonymousCallback: NSObject, ResponseCallback {
		let onSuccess: (String) -> Void
		let onFailure: (String) -> Void
		init(onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {

			self.onSuccess = onSuccess
			self.onFailure = onFailure
		}
		func onCompleted(response: String) { onSuccess(response) }
		func onFailed(error: String) { onFailure(error) }
	}
	return AnonymousCallback(
		onSuccess: { response **in** print("Detection Completed: \(response)") },
		onFailure: { error **in** print("Detection Failed: \(error)") }
	)
}())
```
```objectivec
//objective-c

//Inside - Header file
typedef void (^SuccessBlock)(NSString *response);
typedef void (^FailureBlock)(NSString *error);

@interface AnonymousResponseCallback : NSObject <ResponseCallback>

- (instancetype)initWithSuccess:(SuccessBlock)success
                        failure:(FailureBlock)failure;
@end

//----------------------------------------------//
//Inside - objectivec file

@interface AnonymousResponseCallback ()
@property (nonatomic, copy) SuccessBlock success;
@property (nonatomic, copy) FailureBlock failure;
@end
@implementation AnonymousResponseCallback
- (instancetype)initWithSuccess:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    self = [super init];
    if (self) {
        _success = [success copy];
        _failure = [failure copy];
    }
    return self;
}
- (void)onCompletedWithResponse:(NSString *)response {
    if (self.success) {
        self.success(response);
    }
}
- (void)onFailedWithError:(NSString *)error {
    if (self.failure) {
        self.failure(error);
    }
}
@end
//-------------------------------------------------------------------
//Macro definition
#define MAKE_RESPONSE_CALLBACK(successBlock, failureBlock) \
  [[AnonymousResponseCallback alloc] initWithSuccess:successBlock failure:failureBlock]

//Usage
[humanFaceObj DetectHumanFacesWithInputImage:inputUiimage
                                   callback:MAKE_RESPONSE_CALLBACK(
    ^(NSString *response) {
        NSLog(@"✅ Detection Completed: %@", response);
    },
    ^(NSString *error) {
        NSLog(@"❌ Detection Failed: %@", error);
    }
)];

```
Following is a sample of response structure :
```json
{
	STATUS:  true/false,  //Detection status
	DESCRIPTION :  "SUCCESS",  //Success or failure
	description DOC_ID :  0,  //Identifier/index of the used document.
	FACE_DATA :[  
	//Collection of identified face data 
		{
			ID :  0,  //Identifier/index of face.
			LEFT :  0, 
			TOP :  0, 
			RIGHT :  0, 
			BOTTOM :  0  
			//Each location of face in document  
		}  
	]  
}
```
- ****MatchHumanFaces**** \- DetectHumanFaces Method from ****`humanFaceObj`**** With AI intelligence, analyses the provided face data and returns a response on whether the provided faces are of same human or not. `Document Id` and `Face Id` will be provided by `DetectHumanFaces`, and same can be used.

```swift
//swift

humanFaceObj!.MatchHumanFaces(
    firstDocumentId: id1,
    firstDocumentFaceIndex: index1,
    secondDocumentId: id2,
    secondDocumentFaceIndex: index2,
    callback: {
        class AnonymousCallback: NSObject, ResponseCallback {
            let onSuccess: (String) -> Void
            let onFailure: (String) -> Void

            init(onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {
                self.onSuccess = onSuccess
                self.onFailure = onFailure
            }
            func onCompleted(response: String) {
                onSuccess(response)
            }
            func onFailed(error: String) {
                onFailure(error)
            }
        }

        return AnonymousCallback(
            onSuccess: { response in
                print("✅ Match Success: \(response)")
            },
            onFailure: { error in
                print("❌ Match Failed: \(error)")
            }
        )
    }()
)
```
```objectivec
//objective-c

//--------------------------------------------------------
//Optional if already updated for Detection skip to USAGE
//--------------------------------------------------------
//Inside - header
typedef void (^SuccessBlock)(NSString *response);
typedef void (^FailureBlock)(NSString *error);

@interface AnonymousResponseCallback : NSObject <ResponseCallback>

- (instancetype)initWithSuccess:(SuccessBlock)success
                        failure:(FailureBlock)failure;

@end

//Inside objective C file
@interface AnonymousResponseCallback ()
@property (nonatomic, copy) SuccessBlock success;
@property (nonatomic, copy) FailureBlock failure;
@end

@implementation AnonymousResponseCallback

- (instancetype)initWithSuccess:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    self = [super init];
    if (self) {
        _success = [success copy];
        _failure = [failure copy];
    }
    return self;
}

- (void)onCompletedWithResponse:(NSString *)response {
    if (self.success) {
        self.success(response);
    }
}

- (void)onFailedWithError:(NSString *)error {
    if (self.failure) {
        self.failure(error);
    }
}

@end
//-----------------------------------------------------


//MACRO define before usage
#define MAKE_RESPONSE_CALLBACK(successBlock, failureBlock) \
  [[AnonymousResponseCallback alloc] initWithSuccess:successBlock failure:failureBlock]


//Usage
[humanFaceObj MatchHumanFacesWithFirstDocumentId:id1
                        firstDocumentFaceIndex:index1
                           secondDocumentId:id2
                     secondDocumentFaceIndex:index2
                                     callback:MAKE_RESPONSE_CALLBACK(
    ^(NSString *response) {
        NSLog(@"✅ Match Success: %@", response);
    },
    ^(NSString *error) {
        NSLog(@"❌ Match Failed: %@", error);
    }
)];
```
Following is a sample response structure :
```json
{
	STATUS: true/false, //Match status

	DESCRIPTION : "SUCCESS",	//Success or failure description

	ACCURACY: 0,	//Accuracy of match

}
```
### Face Match Accuracy Interpretation

The match level is determined based on the accuracy percentage, which reflects the similarity between two facial images. The table below provides detailed descriptions for each match level.

| ****Match Percentage****  |  ****Match Level****  |  ****Description**** |

|--|--|--|

| ****90% - 100%**** | ✅ ****Highly Reliable Match**** | Faces match with extremely high confidence. They are almost certainly the same person. Suitable for critical identification applications. |

| ****75% - 89%**** | ✅ ****Strong Match**** | Faces matched successfully with a high probability of being the same person. Reliable for most identity verification use cases. |

| ****65% - 74%**** | ⚠️ ****Moderate Match**** | Faces show good similarity, but further validation may be required. Manual verification is recommended before confirmation. |

| ****50% - 64%**** | ⚠️ ****Low Confidence Match**** | Faces have some resemblance, but the similarity is not strong enough to confirm identity. Additional verification is needed. |

| ****0% - 49%**** | ❌ ****No Match**** | Faces do not match. There is minimal similarity, and they are highly unlikely to be the same person. |

  

### Usage of Results

  

#### ✅ ****Highly Reliable Match (90% - 100%)****

- ****Best for****: Secure identity verification, biometric authentication, and critical decision-making.

- ****Action****: ****Automatic acceptance. No further review required.****

  

#### ✅ ****Strong Match (75% - 89%)****

- ****Best for****: General identification scenarios where strong confidence is required.

- ****Action****: ****Safe for automatic approval**** in most applications.

  

#### ⚠️ ****Moderate Match (65% - 74%)****

- ****Best for****: Cases where additional review is acceptable before finalizing the decision.

- ****Action****: ****Manual verification recommended before confirming a match.****

  

#### ⚠️ ****Low Confidence Match (50% - 64%)****

- ****Best for****: Situations requiring strict validation before acceptance.

- ****Action****: ****Use alternative verification methods. Do not rely on this score alone.****

  

#### ❌ ****No Match (0% - 49%)****

- ****Best for****: Definitive rejection of mismatches.

- ****Action****: ****Automatically reject matches in this range.****

# Notes

### Regarding accuracy :

  
The accuracy of face detection and matching technologies depends on input image quality, including factors such as image distortion, rotation angles, lighting conditions, and color consistency. While offline solutions effectively reduce manual effort and operational costs, they do not guarantee 100% reliability in all scenarios.

  

This system enables on-device verification, efficiently identifying doubtful matches and flagging them for backend verification within the offline environment. By integrating backend validation, the system enhances reliability without relying on external APIs. Additionally, when a match achieves high accuracy as defined in the accuracy thresholds, the system can be considered reliable even without backend verification, making it a valuable solution for offline scenarios where external validation is limited.

  

For use cases demanding exceptionally high accuracy and reliability, an API-based advanced system is recommended.

  

****Extrieve**** - *_Your Expert in Document Management & AI Solutions._*

  

[© 1996 - 2025 Extrieve Technologies](https://www.extrieve.com/)
