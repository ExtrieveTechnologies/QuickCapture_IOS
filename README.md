<img class="img-fluid" align="center" src="https://github.com/ExtrieveTechnologies/QuickCapture/blob/main/QuickCapture.png?raw=true" width="30%" alt="img-verification"><img align="right" class="img-fluid" width="8%" src="https://github.com/ExtrieveTechnologies/QuickCapture/blob/main/apple-ios.png?raw=true?raw=true?raw=true" alt="img-verification">

## Document Scanning-Capture SDK IOS v2
QuickCapture Mobile Scanning SDK Specially designed for native IOS from [Extrieve](https://www.extrieve.com/).

> It's not "just" a scanning SDK. It's a "document" scanning/capture SDK evolved with **Best Quality**, **Highest Possible Compression**, **Image Optimisation**, of output document in mind.

> **Developer-friendly** & **Easy to integration** SDK.

> **End of support Notice** :  QuickCapture SDK IOS **V1** deprecated by June. 2023.For any further updates and support, can use **V2**
> which having no major modifications.But with improved funcionalities,feature additions and fixes.

### Other available platform options
- [Android](https://github.com/ExtrieveTechnologies/QuickCapture_Android)
- [Fultter Plugin](https://pub.dev/packages/quickcapture)
- [Web SDK](https://github.com/ExtrieveTechnologies/QuickCapture_WEB)


Compatibility
-------------
* **Minimum IOS**: QuickCapture v2 requires a minimum iOS 11.

Download
--------
You can download sdk as **framework** in **.zip** file from GitHub's [releases page](https://github.com/ExtrieveTechnologies/QuickCapture_IOS/releases).

QuickCapture IOS SDK **v 2.0.0.5**

## API  and  integration  Details

Mainly the SDK will expose two  classes  and  two  supporting  classes :

 1. **CameraHelper**  -  *Handle the  camera  related  operations. Basically,  an  activity.* 
 2. **ImgHelper**  - *Purpose of this class is to handle all imaging related operations.*
 3. **Config**  -  *Holds various configurations of SDK.* 
 4. **ImgException**  -  *Handle all exceptions on Image related operations on ImgHelper.*
 

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
## CameraHelper
This  class  will  be  implemented  as  an  activity.  This  class  can  be  initialized  as  normal class.
```swift
//Swift
var cameraHelper = CameraHelper();
```
```objectivec
//Objective-C
CameraHelper *camerahelper = [[CameraHelper alloc] init];
```
```swift
//Swift
cameraHelper.StartCapture(
sender:self,
//pathtowritabledirectorywherecaptured
//files are stored temporarily for processing 
workingDirectory:“”,
callback:cameraHelperCallBack)

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
Camera Helper having a supporting class with static configuration  
Config.CaptureSupport  :  contains  various  configurations  as  follows:

- **OutputPath** - To set the output directory in which the captured images will be saved.  Base  app should  have  rights  to write  to the  provided  path.
	```swift
	//Swift
	Config.CaptureSupport.OutputPath = “pass output path as string”
	//Objective-C
	CaptureSupport.OutputPath = “pass output path as string”;
	```
- **MaxPage** - To set the number of captures to do on each camera session. And this can also  control  whether  the  capture  mode  is  single  or  multi  i.e
	> if  MaxPage  <= 0 /  not  set:  means  unlimited.If  MaxPage  >= 1:
	> means  limited.
	```swift
	// MaxPage <= 0  : Unlimited Capture Mode  
	// MaxPage = 1   : Limited Single Capture  
	// MaxPage > 1   : Limited Multi Capture Mode 
	
	//Swift 
	Config.CaptureSupport.MaxPage = 0
	//Objective-C
	CaptureSupport.MaxPage = 0;
	```
- **ColorMode**  -  To  Set  the  capture  color  mode-  supporting  color  and  grayscale.
	```swift
	//Swift
	Config.CaptureSupport.ColorMode = ColorModes.RGB
	//Objective-C
	CaptureSupport.ColorMode = ColorModesRGB
	```
- **EnableFlash**  -  Enable  Document  capture  specific  flash  control  for  SDK  camera.
	```swift
	//Swift
	Config.CaptureSupport.EnableFlash  =  true;
	//Objective-C
	CaptureSupport.EnableFlash  =  true;
	```
- **CaptureSound**  -  To  Enable  camera  capture  sound.
	```swift
	//Swift
	Config.CaptureSupport.CaptureSound  =  true;
	//Objective-C
	CaptureSupport.CaptureSound  =  true;
	```
- **ShowCaptureCountAndLimit**  - Enable/Disable  Capture count as toast at bottom while capturing from  SDK camera.
	```swift
	//Swift
	Config.CaptureSupport.ShowCaptureCountAndLimit  =  true;
	//Objective-C
	CaptureSupport.ShowCaptureCountAndLimit  =  true;
	```
- **SDKInfo**  - Contains  all  version  related  information  on  SDK.
	```swift
	//Swift
	Config.CaptureSupport.SDKInfo
	//Objective-C
	CaptureSupport.SDKInfo;
	```

- **CameraToggle**  -  Toggle  camera  between  front  and  back.
	```swift
	//Swift
	Config.CaptureSupport.CameraToggle  =  2;
	//Objective-C
	CaptureSupport.CameraToggle  =  2;
	//0-Disable camera toggle option.
	//1-Enable camera toggle option with Front camera by default.
	//2-Enable camera toggle option with Back camera  by default.
	```
- **BuildTiff**  -  Build  .tiff  file  output  from  the list  of  images  shared.
	```swift
	//Swift
	do
	{
		let status = try cameraHelper.BuildTiff(ImageArray: fileArray, TiffFilePath: outputTiffURL.path)
		print(status)
	}
	catch
	{
		print(error)
	}
	 *@param  "Image  File  path  collection  as  Array of String"
	 *@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::TIFF  file  path".
	```
	```objectivec
	//Objective-C
	NSString* str = [cameraHelper BuildTiff:imagePathArray :outputTiffURL.path :nil];
	*@param  "Image  File  path  collection  as  Array of String"
	*@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::TIFF  file  path".
	```
- **BuildPDF**  -  Build  PDF  file  output  file  from  last  captured  set  of  images.
	```swift
	//Swift
	do {
		let status = try cameraHelper.BuildPdf(ImageArray: fileArray, PdfFilePath: outputPDFURL.path)
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
	NSString* str = [cameraHelper BuildPdf:imagePathArray :outputPdfURL.path :nil];
	*@param  "Image  File  path  collection  as  Array of String"
	*@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::PDF  file  path".
	```
	## ImgHelper
	Following  are  the  options/methods  available  from  class  **ImgHelper** :
	To instanciate this class
	```swift
	//Swift
	let ImgHelper = ImgHelper.GetInstance()
	```
	```objectivec
	//Objective-C
	ImgHelper *ImgHelper = [ImgHelper GetInstance];
	```
- ***SetImageQuality*** - *Set the Quality of the image, Document_Qualityisused.If documents are used further for any automations and OCR, use Document_Quality.*
	 >*Available Image Qualities* :
		1. Photo_Quality.
		2. Document_Quality.
		3. Compressed_Document.
		
	```swift
	//Swift
	ImgHelper.shared.setImageQuality(value: ImageQuality.Document_Quality)
	//OR
	ImgHelper.setImageQuality(value: ImageQuality.Document_Quality)
	```
	```objectivec
	//Objective-C
	[ImgHelper setImageQuality:ImageQualityDocument_Quality];
	```
- ***SetPageLayout*** - *Set the Layout for the images generated/processed by the system.*
	```swift
	ImgHelper.shared.setPageLayout(LayoutType.A4)
	//OR
	ImgHelper.setPageLayout(LayoutType.A4)
	```
	 >*Available layouts* : A1, A2, A3, **A4**, A5, A6, A7,PHOTO & CUSTOM
	 
	*A4 is the most recommended layout for document capture scenarios.*
	 
- ***SetDPI*** - *Set DPI (depth per inch) for the image.*
	```swift
	ImgHelper.shared.setDPI(DPI._200)
	//OR
	ImgHelper.setDPI(DPI._200)
	```
	
	 >*Available DPI* : DPI_150, DPI_200, DPI_300, DPI_500, DPI_600
	 
	 *150 & 200 DPI is most used.And 200 DPI recommended for OCR and other image extraction prior to capture.*
	 
- ***GetThumbnail*** - *This method Will build thumbnail for the given image in custom width,height & AspectRatio.*
	```swift
   //Swift
   	do
   	{
	   try UIImage thumb = ImgHelper.shared.GetThumbnail(bm: image, rHeight: 600, rWidth: 600, AspectRatio: true)
   	}
	catch
	{
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
- ***CompressToJPEG*** - *This method will Compress the provided bitmap image and will save to given path..*
	```swift
	//Swift
	Boolean Iscompressed = ImgHelper.shared.CompressToJPEG(image: image, outputURI: jpegURL.absoluteString)
	/*
	Boolean CompressToJPEG(UIImage image,String outputFilePath)
		throws ImgException
	*/
	```
	```objectivec
	//Objective-C
	BOOL isCompressed = [ImageHelper CompressToJPEG:image :outputJPEGURL.absoluteString];
	```
	
- ***rotateBitmap*** - *This method will rotate the image to preferred orientation.*
	 ```swift
	 //Swift
	UIImage rotatedBm = ImgHelper.shared.rotateBitmap(image: img, orientation: ImageOrientation.left);
	/*
	UIimage rotateBitmapDegree(UIimage image,enum ImageOrientation)
		throws ImgException
	
	Available Options for Orientation
	enum ImageOrientation :
		up
	    down
	    left
	    right
	    upMirrored
	    downMirrored
	    leftMirrored
	    rightMirrored
	*/
	```	
	```objectivec
	//Objective-C
	UIImage *rotatedImage = [ImageHelper rotateBitmap:image :ImageOrientationUp :&err];
	
	```

## ImgException 
As a part of exceptional error handling **ImgException** class is available.
- *Following are the possible errors and corresponding codes*:
	- CREATE_FILE_ERROR= **-100**;
	- IMAGE_ROTATION_ERROR= **-101**;
	- LOAD_TO_BUFFER_ERROR= **-102**;
	- DELETE_FILE_ERROR= **-103**;
	- GET_ROTATION_ERROR= **-104**;
	- ROTATE_BITMAP_ERROR= **-105**;
	- BITMAP_RESIZE_ERROR= **-106**;
	- CAMERA_HELPER_ERROR= **-107**;
	- LOG_CREATION_ERROR= **-108**;
	- IMAGE_COMPRESSION_ERROR= **-109**;
	
## SDK Licensing

*License file provided that should keep inside assets folder of main application and call UnlockImagingLibrary from ImgHelper class to unlock the SDK.*
> **QuickCapture** SDK is absolutely **free** to use.But for image operations on enterprise use cases, license required.
> [Click for license details ](https://www.extrieve.com/mobile-document-scanning/)

```swift
//Swift
let licenseData : String = try String(contentsOf: licenseFileURL) 
Bool IsUnlocked = ImgHelper.shared.UnlockLibrary(mainBundle: Bundle.main, licenseFile: licenseData)

/*
Bool UnlockLibrary(Bundle.main, String licenseFileData)
	throws Exception
*/
```
```objectivec
//Objective-C
BOOL isUnLocked = [ImgHelper UnlockLibrary:NSBundle.mainBundle :licenseData];
```

	
[© 1996 - 2023 Extrieve Technologies](https://www.extrieve.com/)
