MILHorizontalCollectionView
=======================
<br>

<p align="center">
<img src="README_ASSETS/MILHorizontalCollectionViewControllerExample.gif"  alt="Drawing" height=250 border=0 /></p>

<br>
MILHorizontalCollectionView is an easy to use, drop-in, reusable UI component built in Swift to display in a horizontal row, collection view cells that are horizontally scrollable. When the collection view scrolls, it has momentum that allows it to continue to scroll and always land on a full collection view cell all the way to the left (without partially cropping a cell off screen). The collection view can be customized to handle and display any type of data after some minor changes (explained below). By default, the collection view is writen to display images in each cell. MILHorizontalCollectionView has the ability to display local images stored in the xcode project as well as has the ability to asynchronously download and cache images from image URLs using its built in functionality or using third party framework [SDWebImage](https://github.com/rs/SDWebImage). In addition, MILHorizontalCollectionView also supports displaying placeholder cells while it waits to receive data from a server.

While the MILHorizontalCollectionView is fully functional out the the box, I suspect you will have to modify it to some extent to match your app's UI design.

<br>

## Installation

Simply copy the **`MILHorizontalCollectionView`** **folder** into your Xcode project. This folder contains the following 4 files:

1. `MILHorizontalCollectionViewController.swift`
1. `MILHorizontalCollectionViewFlowLayout.swift`
1. `MILHorizontalCollectionViewCell.swift`
1. `MILHorizontalCollectionViewCell.xib`

<br>
## Adding MILHorizontalCollectionView To A View Controller

For both storyboard and programmatic implementations, you can reference the `ViewController.swift`file in the example xcode project to see an example in context.

<br>
### Programmatic Implementation 

1. In the view controller class file you would like to add a programmatic MILHorizontalCollectionViewController to, create a property at the top of the file:

	```swift
	var programmaticHorizontalCollectionViewController : MILHorizontalCollectionViewController!
```
    
1. To initialize an instance of MILHorizontalCollectionViewController programmatically and set it the view controller's property we do:

	```swift
	let flow = MILHorizontalCollectionViewFlowLayout()
    self.programmaticHorizontalCollectionViewController = MILHorizontalCollectionViewController(collectionViewLayout: flow)
```    
    
1. To set the frame of the MILHorizontalCollectionViewController's view we do:

	```swift
	self.programmaticHorizontalCollectionViewController.view.frame = CGRectMake(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
```
 		
 		
1. To add the MILHorizontalCollectionViewController's view to the view controller's view we do:

	```swift
	self.addChildViewController(self.programmaticHorizontalCollectionViewController)
   self.programmaticHorizontalCollectionViewController.didMoveToParentViewController(self)
    self.view.addSubview(self.programmaticHorizontalCollectionViewController.view)
```

<br>
### Storyboard Implementation

1. On the view controller you would like to add the MILHorizontalCollectionView to, add a `Container View` to the view controller's view and delete the `UIViewController` storyboard auto embeded in the container view. Add the appropriate autolayout constraints to the container view so that it displays to your liking within the view controller's view. The height you make the container view will define the height of the MILHorizontalCollectionView as well as the height of the collection view cells in the MILHorizontalCollectionView. Your storyboard should now look like this: <p align="center">
<img src="README_ASSETS/storyboard_implementation_step1.png"  alt="Drawing" width=600 border=0 /></p>
1. Next add a `UICollectionViewController` to the storyboard. Select this collection view controller on storyboard so that it's highlighted and then select the `Identity Inspector` of the `Utilies` sidebar. Under "Custom Class" make the UICollectionViewController a subclass of `MILHorizontalCollectionViewController`<p align="center">
<img src="README_ASSETS/identity_inspector.png"  alt="Drawing" height=150 border=0 /></p>
1. Hold down the control key while you click and drag from the container view on the view controller to the UICollectionViewController. A dialog box will show asking you what kind of segue you would like to choose, select `Embed`.<p align="center">
<img src="README_ASSETS/embed_segue.png"  alt="Drawing" width=200 border=0 /></p>Your storyboard should now look like this:<p align="center">
<img src="README_ASSETS/after_adding_embeded_segue.png"  alt="Drawing" width=700 border=0 /></p>
1. Select the segue arrow that was just added that goes from the Container View to the MILHorizontalCollectionViewController. In the `Attributes Inspector` change the `Storyboard Embed Segue Identifier` to  `horizontalCollectionView`.<p align="center">
<img src="README_ASSETS/embed_segue_identifier.png"  alt="Drawing" height=125 border=0 /></p>
1. Go to the swift file that represents the UIViewController that has the Container View you added. Create a property at the top of the file 

	```swift
	var storyboardHorizontalCollectionView : MILHorizontalCollectionViewController!
	```
        
1. Add a prepare for segue method to your view controller if it isn't already added and add the following lines to get the instance of the `MILHorizontalCollectionViewController` you added on the storyboard and to save this instance to the view controller's storyboardHorizontalCollectionView property

	```swift
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 	   if(segue.identifier == "horizontalCollectionView"){
 	   		self.storyboardHorizontalCollectionView = 
      		segue.destinationViewController as! MILHorizontalCollectionViewController
    	}
	}
	```           
        
<br>    
## Usage

###Set Placeholder Cell Image and Number of Placeholder Cells       
    
A placeholder cell is a cell that is displayed in the MILHorizontalCollectionView while it waits to be passed data from it's parent view controller. This can be useful if there is a delay from retrieving data from a server call. Typically you would want to display enough cells in the collection view to fill up the whole collection view horizontally. It should be noted that if you dont set the number of placeholder cells, the collection view won't show up and will appear as plain white. The following code snippets can be used after you init a MILHorizontalCollectionView programmatically, or once you get reference to the storyboard MILHorizontalCollectionView in the prepareForSegue method. (Examples shown in the example project)

To set the placeholder item image to a locally stored image within the Xcode project, we pass it the name:

```	swift
self.storyboardHorizontalCollectionView.localPlaceHolderImageName = "placeholder_name"
```
	
To set the number of placeholder items displayed we do:
		
```swift
self.storyboardHorizontalCollectionView.setUpWithInitialPlaceHolderItems(n)
```	
	
<br>	
###Passing Data to the MILHorizontalCollectionViewController
		
By default, the MILHorizontalCollectionViewController expects to handle an array of strings that represent a URL, with its built in asychronous image url downloading and caching mechanisms. However, it should be noted that it also supports handling image url strings using the [SDWebImage](https://github.com/rs/SDWebImage) framework. In addition, the MILHorizontalCollectionViewController can handle an array of strings that represent names of locally stored images in the Xcode project.  


Chances are when you try to resolve imageURL's to images you will get the following warning and you won't be able to download the images:

```
App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.
Error: The resource could not be loaded because the App Transport Security policy requires the use of a secure connection.
```

To fix this, go to your `info.plist` file and add the following:

```
<key>NSAppTransportSecurity</key>
<dict>
  <!--Include to allow all connections-->
  <key>NSAllowsArbitraryLoads</key>
      <true/>
</dict>
```

This of course is the lazy way to fix the problem. Eventually you would want to specify which specific web domains you want the app to accept. For more information about this try [this article](http://www.neglectedpotential.com/2015/06/working-with-apples-application-transport-security)

- To pass an array of `image url strings` to the collection view and have the collection view handle this using its **built in asychronous image url downloading and caching** we can do:

	```	swift
	self.horizontalCollectionView.setToHandleImageURLStrings()
		    
	let imageURLArray = [String]()
	//populate this array with url strings
		    
	//pass array of strings that represent URLs of images
	self.horizontalCollectionView.refresh(imageURLArray)
	
	```
<br>		    
- To pass an array of `image url strings` to the collection view and have the collection view handle this using the **[SDWebImage](https://github.com/rs/SDWebImage)** framework we can do:

	```	swift	
	self.horizontalCollectionView.setToHandleImageURLStringsUsingSDWebImage()
	 		
	let imageURLArray = [String]()
	//populate this array with url strings
		    
	//pass array of strings that represent URLs of images
	self.horizontalCollectionView.refresh(imageURLArray)
	
	```
	
	Note that in order to use SDWebImage, you must import SDWebImage into your xcode project yourself. As well you will need to uncomment the code in the `setUpCellWithImageURLUsingSDWebImage` method in the `MILHorizontalCollectionViewController.swift` file shown below:

	```swift	
private func setUpCellWithImageURLUsingSDWebImage(cell : MILHorizontalCollectionViewCell, indexPath : NSIndexPath) -> MILHorizontalCollectionViewCell {
        
        
        //Code commented out since SDWebImage isn't imported in the project and to surpress errors and warnings, uncomment to use with sdWebImage
       /* 
        let urlString = self.dataArray[indexPath.row]
        let url = NSURL(string: urlString)
        
        cell.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: self.localPlaceHolderImageName))
        */
        
        return cell
    }
```	 
<br>
- To pass an array of `strings that represent locally stored images` to the collection view we can do:

	```swift
	self.horizontalCollectionView.setToHandleLocalImageNameStrings()
	 		
	let imageNameArray = [String]()
	//populate this array with locally stored image names
		    
	//pass array of strings that represent names of locally stored images 
	self.horizontalCollectionView.refresh(imageNameArray)
	```

<br>
## Customizing MILHorizontalCollectionView

###Changing the Height and Width of the Collection View Cells

- The `height` of a collection view cell changes with respect to the collection view controller's view height. 
	- If you are dealing with a programmatic implementation of the MILHorizontalCollectionViewController, know that when you set the frame of the collection view controller's view, this will also be the height of each cell in the collection view
	- If you are dealing with a storyboard implementation of the MILHorizontalCollectionViewController, changing the height of the container view that holds the collection view controller will also set the height of each cell in the collection view
- The `width` of the collection view cell is set by the `kViewSizeWidth` property in the `MILHorizontalCollectionViewFlowLayout.swift` file. By default it is set to `160`

<br>
###Changing the Kind of Data the Collection View Can Handle

To change the kind of data the collection view can handle, first you will need to modify the dataArray property in the `MILHorizontalCollectionViewController.swift` file to be an array of different data types:

```swift
var dataArray : [MyDataObject] = []

```

As well you will need to change the way the collection view controller prepares the cell in the cellForItemAtIndexPath method

```swift
override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("horizontalcell", forIndexPath: indexPath) as! MILHorizontalCollectionViewCell
        
        //set up cell with method that sets up the cell with a custom data object
        return self.setUpCellWithCustomDataObject(cell, indexPath: indexPath)

    }
```

<br>
###Changing the Collection View Cell's UI

To change the UI of the collection view cell, you can do this by modifying the `MILHorizontalCollectionViewCell.xib` file. By default, the collection view cell only has an image view that stretches accross the whole cell. Of course, with modifying the collection view cell's UI, comes changing the way we prepare and set up the data in the cell using the cellForItemAtIndexPath method.

<br>
## Requirements
* MILHorizontalCollectionView has only been tested to work with iOS 9+ and Xcode 7.1.1

## Author

Created by [Alex Buck](https://www.linkedin.com/in/alexanderbuck)
 at the [IBM Mobile Innovation Lab](http://www-969.ibm.com/innovation/milab/)

## License

MILHorizontalCollectionView is available under the Apache 2.0 license. See the LICENSE file for more info.

## Sample App License
The MILHorizontalCollectionViewExample sample application is available under the Apple SDK Sample Code License. Details in the file called `SAMPLE_APP_LICENSE` under the Example directory.

