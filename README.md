(C) 2023 The original author [@PrathamRehil](https://github.com/prathamrehil)
<br/>
<br/>

# Scan And Shop App

Advanced Scan and shop app built on Flutter that uses machine learning models using TensorFlow and Google Ml Kit flutter packages. The app uses barcode scanner, text detector and TFLite object detection to detect the object precisely.

## 🔗 Android Apk

<a href="https://drive.google.com/file/d/1JpH69SwXWmqf8M9uehuEd954SF8b8KaE/view?usp=share_link"><img src="https://www.yt3dl.net/images/apk-download-badge.png" style="height:100px;"></a>

## 📸 Screenshots

<br/>
<br/>

**Barcode detection**
<img src="https://github.com/prathamrehil/Scan_And_Shop/blob/main/ScreenShots/Screenshot_20230430_231500.jpg" height="500em" /> &nbsp; &nbsp;

<img src="https://github.com/prathamrehil/Scan_And_Shop/blob/main/ScreenShots/Screenshot_20230430_231511.jpg" height="500em" /> &nbsp; &nbsp;

<br/>
<br/>

**TensorFlow object detection**
<img src="https://github.com/prathamrehil/Scan_And_Shop/blob/main/ScreenShots/Screenshot_20230430_231714.jpg" height="500em" /> &nbsp; &nbsp;

<img src="https://github.com/prathamrehil/AppGPT/blob/main/ScreenShots/Screenshot_20230430_231733.jpg" height="500em" /> &nbsp; &nbsp;

<br/>
<br/>

**Text detection**
<img src="https://github.com/prathamrehil/AppGPT/blob/main/ScreenShots/Screenshot_20230430_232231.jpg" height="500em" /> &nbsp; &nbsp;
<img src="https://github.com/prathamrehil/AppGPT/blob/main/ScreenShots/Screenshot_20230430_232242.jpg" height="500em" />

<br/>
<br/>

## Features

- The app uses flutter camera package for camera viewer and image_picker for selecting image.
- The image will be first checked for qr code and will go to qr code link if available
- If not available, then text will be checked to available in the image. if considerable amount of text is available, then search results based on the text will be shown.
- Finally, tensor flow object detection model will be used to detect the object.
- Google shopping website in webview has been used to show products search results.
