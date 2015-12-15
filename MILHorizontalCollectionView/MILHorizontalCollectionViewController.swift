/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class MILHorizontalCollectionViewController: UICollectionViewController {

    //here you can customize what kind of objects the dataArray would hold, in this case we used strings for imageURL's
    var dataArray : [String] = []
    
    //ideally the MILHorizontalCollectionView wouldn't have a imageCache itself, instead we would be caching to a global image cache so anywhere in the app we could access cached images
    var imageCache : [String : UIImage] = [String : UIImage]()
    
    //Must set this string for placeHolder images to show while it waits for image URL's to download
    var localPlaceHolderImageName = ""
    
    //sets the MILHorizontalCollectionView to handle image URL strings with built in mechanisms to display data in the cell
    private var handleImageURLStrings = true
    
    //sets the MILHorizontalCollectionView to handle image URL strings with SDWebImage to display data in the cell
    private var handleImageURLStringsUsingSDWebImage = false
    
    //sets the MILHorizontalCollectionView to handle local image name strings with built in mechanisms to display data in the cell
    private var handleLocalImageNameStrings = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initial set up of the collection view
        self.setUpCollectionView()
    }
    
    /**
    This method sets up the collectionview to have n placeholder items while it waits for a call back from the server (when the refresh method is called)
    */
    func setUpWithInitialPlaceHolderItems(numberOfPlaceHolderCells : Int){
        for(var i = 0; i<numberOfPlaceHolderCells; i++){
            self.dataArray.append("")
        }
    }
    
    /**
    This method is called when there has been data recieved from the server. It sets up the collectionview to handle this new data.
    
    - parameter newDataArray:
    */
    func refresh(newDataArray : [String]){
        if(newDataArray.count > 0){
            self.dataArray = newDataArray
            self.collectionView!.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /**
    This method sets up the collectionView with various inital settings.
    */
    private func setUpCollectionView(){
        //hide horizontal scroll indicator
        self.collectionView!.showsHorizontalScrollIndicator = false;
        
        //set up the collection view with custom collection view flow layout
        let collectionPageViewLayout : MILHorizontalCollectionViewFlowLayout = MILHorizontalCollectionViewFlowLayout()
        self.collectionView!.setCollectionViewLayout(collectionPageViewLayout, animated: false);
        
        //set up the collection view with custom collection view nib
        let nib : UINib = UINib(nibName: "MILHorizontalCollectionViewCell", bundle:nil)
        self.collectionView!.registerNib(nib,
            forCellWithReuseIdentifier: "horizontalcell");
    }
    
    
    /**
     This method sets the MILHorizontalCollectionView to handle image URL strings with built in mechanisms to display data in the cell
     */
    func setToHandleImageURLStrings(){
        
        self.handleLocalImageNameStrings = false
        self.handleImageURLStrings = true
        self.handleImageURLStringsUsingSDWebImage = false
        
    }
    
    
    /**
     This method sets the MILHorizontalCollectionView to handle image URL strings with SDWebImage to display data in the cell
     */
    func setToHandleImageURLStringsUsingSDWebImage(){
        
        self.handleLocalImageNameStrings = false
        self.handleImageURLStrings = false
        self.handleImageURLStringsUsingSDWebImage = true
        
    }

    
    /**
     This method sets the MILHorizontalCollectionView to handle local image name strings with built in mechanisms to display data in the cell
     */
    func setToHandleLocalImageNameStrings(){
        
        self.handleLocalImageNameStrings = true
        self.handleImageURLStrings = false
        self.handleImageURLStringsUsingSDWebImage = false
        
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    /**
    This method defines the number of items in a section
    */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return dataArray.count
    }


    /**
    This method generates the cell for item at indexPath
    
    - parameter collectionView:
    - parameter indexPath:
    
    - returns:
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("horizontalcell", forIndexPath: indexPath) as! MILHorizontalCollectionViewCell
        
        //1. Setup cell with image from image url (download image asynchronously and cache image)
        if(handleImageURLStrings == true){
            return self.setUpCellWithImageURL(cell, indexPath: indexPath)
        }
        //2. Setup cell with image from image url (Using SDWebImage framework to download image asynchronously and cache image)
        else if(handleImageURLStringsUsingSDWebImage == true){
            return self.setUpCellWithImageURLUsingSDWebImage(cell, indexPath: indexPath)
        }
            
        //3. Setup cell with locally stored images
        else{
            return self.setUpCellWithLocallyStoredImage(cell, indexPath: indexPath)
        }

    }
    
    
    
    /**
    This method sets up the MILHorizontalCollectionViewCell with a locally stored image with respect to indexPath.row in the dataArray. This method can be used when it is assumed that the strings the data array holds represent the names of locally stored images in Images.xcassets
    
    - parameter cell:
    - parameter indexPath:
    
    - returns: MILHorizontalCollectionViewCell
    */
    private func setUpCellWithLocallyStoredImage(cell : MILHorizontalCollectionViewCell, indexPath : NSIndexPath) -> MILHorizontalCollectionViewCell {
        
        let imageString : String = dataArray[indexPath.row] as String
        let image = UIImage(named: imageString)
        cell.imageView.image = image
        
        return cell
    }
    
    
    /**
    This method sets up the MILHorizontalCollectionViewCell with an image from a url. It first will set up the cell with a placeholder image. Then it will check the cache to see if the image has already been downloaded and cached. If the cache has the image, it sets the cell with the image. If not, then it will asynchronously download the image, cache it, and then set the cell with this image.
    
    - parameter cell:
    - parameter indexPath:
    
    - returns: MILHorizontalCollectionViewCell
    */
    private func setUpCellWithImageURL(cell : MILHorizontalCollectionViewCell, indexPath : NSIndexPath) -> MILHorizontalCollectionViewCell{
        
        //set the cell with temporary locally stored placeholder image
        let placeholderImage = UIImage(named: self.localPlaceHolderImageName)
        cell.imageView.image = placeholderImage
        
        let urlString = self.dataArray[indexPath.row]
        
        //check the image cache to see if cell has been previously downloaded and cached. If so set the cell with the image
        if let image = self.imageCache[urlString] {
            cell.imageView.image = image
        }
        //cache doesn't contain image, asynchronously download image and then cache it, then set cell.
        else{
            self.asychronouslyDownloadImageFromURLAndSetCollectionViewCellAtIndexPath(urlString, indexPath: indexPath)
        }
        
        return cell
    }
    
    
    /**
    This method sets up the MILHorizontalCollectionViewCell with an image from a url using the SDWebImage framework. The SDWebImage framework will out of the box asynchronously download the image, cache the image, and persist this cache accross multiple app instances.
    
    - parameter cell:
    - parameter indexPath:
    
    - returns: MILHorizontalCollectionViewCell
    */
    private func setUpCellWithImageURLUsingSDWebImage(cell : MILHorizontalCollectionViewCell, indexPath : NSIndexPath) -> MILHorizontalCollectionViewCell {
        
        
        //Code commented out since SDWebImage isn't imported in the project and to surpress errors and warnings, uncomment to use with sdWebImage
       /* 
        let urlString = self.dataArray[indexPath.row]
        let url = NSURL(string: urlString)
        
        cell.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: self.localPlaceHolderImageName))
        */
        
        return cell
    }
    
    
    /**
    This method asychronously downloades an image from the specified urlString, caches this image, and then updates the the collection view cell with this image.
    
    - parameter collectionView:
    - parameter indexPath:
    */
    private func asychronouslyDownloadImageFromURLAndSetCollectionViewCellAtIndexPath(urlString : String, indexPath : NSIndexPath){
        if(urlString != ""){
            if let url  = NSURL(string: urlString){
        
                let request: NSURLRequest = NSURLRequest(URL: url)
                let mainQueue = NSOperationQueue.mainQueue()
        
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        let image = UIImage(data: data!)
                        // Store the image in the cache
                        self.imageCache[urlString] = image
                        // Update the cell with this image
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) {
                                (cell as! MILHorizontalCollectionViewCell).imageView.image = image
                            }
                        })
                    }
                    else {
                        print("Error: \(error!.localizedDescription)")
                    }
                })
            }
        }
    }
    
    /**
    This method determines the action that is taken when an item is tapped.
    
    - parameter collectionView:
    - parameter indexPath:
    */
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        
    }

}
