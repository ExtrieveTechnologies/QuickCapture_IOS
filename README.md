# Mobile-Scanning-SDK-IOS
QuickCapture Mobile Scanning SDK Specially designed for native IOS


Compatibility
-------------
* **Minimum IOS**: QuickCapture v1 requires a minimum iOS 11.

QuickCapture IOS SDK v 1.0.2

## API  and  integration  Details

Mainly the SDK will expose two  classes  and  two  supporting  classes :

 1. **CameraHelper**  -  *Handle the  camera  related  operations. Basically,  an  activity.* 
 2. **ImgHelper**  - *Purpose  of  this  class  is  to  handle  all  imaging  related operations.*
 3. **CameraSupport**  -  *Holds  various configurations  for  camera.* 
 4. **ImgException**  -  *Handle  all exceptions  on  Image  related  operations  on ImgHelper.*
 

Based on the requirement any one or all classes can be used. And need to import those from the  SDK.
```swift
    import QuickCaptureFW;
   ```
---
## CameraHelper
This  class  will  be  implemented  as  an  activity.  This  class  can  be  initialized  as  intent.
```swift
    var cameraHelper = CameraHelper();
```

```swift
cameraHelper.StartCapture(
    sender:self,
    //pathtowritabledirectorywherecaptured
    //files are stored temporarily for processing 
    workingDirectory:“”,
    callback:cameraHelperCallBack)

func cameraHelperCallback(_ImageArray:[String])->Void{
    //paths-  arrayofcapturedimagesavailablehere.
    //Use returned images
}
```
Camera Helper having a supporting class with static configuration  
CameraSupport.CamConfigClass.CamConfigClass  :  contains  various  configurations  as  follows:

- **OutputPath** - To set the output directory in which the captured images will be saved.  Base  app should  have  rights  to write  to the  provided  path.
	```java
	CameraSupport.CamConfigClass.OutputPath = “pass output path as 	string”;
	```
- **MaxPage** - To set the number of captures to do on each camera session. And this can also  control  whether  the  capture  mode  is  single  or  multi  i.e
	> if  MaxPage  <= 0 /  not  set:  means  unlimited.If  MaxPage  >= 1:
	> means  limited.
	```java
	// MaxPage <= 0  : Unlimited Capture Mode  
	// MaxPage = 1   : Limited Single Capture  
	// MaxPage > 1   : Limited Multi Capture Mode  
	public static int MaxPage = 0;
	```
- **ColorMode**  -  To  Set  the  capture  color  mode-  supporting  color  and  grayscale.
- **EnableFlash**  -  Enable  Document  capture  specific  flash  control  for  SDK  camera.
	```java
	CameraSupport.CamConfigClass.EnableFlash  =  true;
	```
- **CaptureSound**  -  To  Enable  camera  capture  sound.
	```java
	CameraSupport.CamConfigClass.CaptureSound  =  true;
	```
- **DeviceInfo**  -  Will  share  all  general  information  about  the  device.
	```java
	CameraSupport.CamConfigClass.DeviceInfo;
	```
- **SDKInfo**  - Contains  all  version  related  information  on  SDK.
	```java
	CameraSupport.CamConfigClass.SDKInfo;
	```

- CameraToggle  -  Toggle  camera  between  front  and  back.
	```java
	CameraSupport.CamConfigClass.CameraToggle  =  2;
	//0-Disable camera toggle option.
	//1-Enable camera toggle option with Front camera by default.
	//2-Enable camera toggle option with Back camera  by default.
	```

- **GetTiffForLastCapture**  -  Build  Tiff  file  output  file  from  last  captured  set  of  images.
	```java
	CameraHelper.GetTiffForLastCapture(outPutFileWithpath);
	//on success, will respond with string : "SUCCESS:::TiffFilePath";
	//use  ":::"  char.  key  to  split  the  response.
	//on failure,will respond with string : "FAILED:::Reason for failure";
	//use ":::" char. key to split the response.
	//on failure, error details can collect from CameraSupport.CamConfigClass.LastLogInfo
	```
- **GetPDFForLastCapture**  -  Build  PDF  file  output  file  from  last  captured  set  of  images.
	```java
	CameraHelper.GetPDFForLastCapture(outPutFileWithpath);
	//on success, will respond with string : "SUCCESS:::PdfFilePath";
	//use  ":::"  char.  key  to  split  the  response.
	//on failure,will respond with string : "FAILED:::Reason for failure";
	//use ":::" char. key to split the response.
	//on failure, error details can collect from CameraSupport.CamConfigClass.LastLogInfo
	```
- **BuildTiff**  -  Build  .tiff  file  output  from  the list  of  images  shared.
	```java
	CameraHelper.BuildTiff(ArrayList<String>  ImageCol,  String  OutputTiffFilePath)
	 *@param  "Image  File  path  collection  as  ArrayList<String>"
	 *@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::TIFF  file  path".
	```
- **BuildPDF**  -  Build  PDF  file  output  file  from  last  captured  set  of  images.
	```java
	CameraHelper.BuildPDF(outPutFileWithpath);
	*@param  "Image  File  path  collection  as  ArrayList<String>"
	*@return  on  failure  =  "FAILED:::REASON"  ||  on  success  =  "SUCCESS:::PDF  file  path".
	```
## ImgHelper
Following  are  the  options/methods  available  from  class  **ImgHelper** :
```java
ImgHelper ImageHelper = new ImgHelper(this);
```
- ***SetImageQuality*** - *Set the Quality of the image, Document_Qualityisused.If documents are used further for any automations and OCR, use Document_Quality.*
	 >*Available Image Qualities* :
		1. Photo_Quality.
		2. Document_Quality.
		3. Compressed_Document.
		
	```java
	ImageHelper.SetImageQuality(ImgHelper.ImageQuality.Photo_Quality.ordinal());
	//OR
	ImageHelper.SetImageQuality(1);//0,1,2 - Photo_Quality, Document_Quality, Compressed_Document
	```
- ***SetPageLayout*** - *Set the Layout for the images generated/processed by the system.*
	```java
	ImageHelper.SetPageLayout(ImgHelper.LayoutType.A4.ordinal());
	//OR
	ImageHelper.SetPageLayout(4);//A1-A7(1-7),PHOTO,CUSTOM,ID(8,9,10)
	```
	 >*Available layouts* : A1, A2, A3, **A4**, A5, A6, A7,PHOTO & CUSTOM
	 
	*A4 is the most recommended layout for document capture scenarios.*
	 
- ***SetDPI*** - *Set DPI (depth per inch) for the image.*
	```java
	ImageHelper.SetDPI(ImgHelper.DPI.DPI_200.ordinal());
	//OR
	ImageHelper.SetDPI(200);//int dpi_val = 150, 200, 300, 500, 600;
	```
	
	 >*Available DPI* : DPI_150, DPI_200, DPI_300, DPI_500, DPI_600
	 
	 *150 & 200 DPI is most used.And 200 DPI recommended for OCR and other image extraction prior to capture.*
	 
- ***GetThumbnail*** - *This method Will build thumbnail for the given image in custom width,height & AspectRatio.*
	```java
   
	Bitmap thumb = ImageHelper.GetThumbnail(ImageBitmap, 600, 600, true);
	/*
	Bitmap GetThumbnail(
		@NonNull  Bitmap bm,
	    int reqHeight,
	    int reqWidth,
	    Boolean AspectRatio )throws ImgException.
	*/
	```
- ***CompressToJPEG*** - *This method will Compress the provided bitmap image and will save to given path..*
	```java

	Boolean Iscompressed = CompressToJPEG(bitmap,outputFilePath);
	/*
	Boolean CompressToJPEG(Bitmap bm,String outputFilePath)
		throws ImgException

	*/
	```
	
- ***rotateBitmap*** - *This method will rotate the image to preferred orientation.*
	 ```java

	Bitmap rotatedBm = rotateBitmapDegree(nBm, RotationDegree);
	/*
	Bitmap rotateBitmapDegree(Bitmap bitmap,int Degree)
		throws ImgException
	*/
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
	
## SDK Licensing

*License file provided that should keep inside assets folder of main application and call UnlockImagingLibrary from ImgHelper class to unlock the SDK.*
> **QuickCapture** SDK is absolutely **free** to use.But for image operations on enterprise use cases, license required.
> [Click for license details ](https://www.extrieve.com/mobile-document-scanning/)

```java
	
String licData = readAssetFile("com.extrieve.lic", this);  
Boolean IsUnlocked = ImageHelper.UnlockImagingLibrary(licData)

/*
boolean UnlockImagingLibrary(String licenseFileData)
	throws Exception
*/

```

	
[© 1996 - 2023 Extrieve Technologies](https://www.extrieve.com/)
