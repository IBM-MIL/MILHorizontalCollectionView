/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import UIKit

class ViewController: UIViewController {
    
    //set in the prepareForSegue method
    var storyboardHorizontalCollectionView : MILHorizontalCollectionViewController!
    
    //set in the setUpProgramaticHorizontalCollectionViewController method
    var programaticHorizontalCollectionViewController : MILHorizontalCollectionViewController!
    
    //delay timer for fake server to return back data
    var kImageServerDelayTime : NSTimeInterval = 1.5
    
    //number of placeholder items you want to be shown by default while it waits for data
    var kNumberOfInitialPlaceHolderItems = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Initial set up needed to display programaticHorizontalCollectionView
        self.setUpProgramaticHorizontalCollectionViewController()
        
        //On initial load, query for images on fake "server" for demo purposes
        self.getImagesFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /**
    This method sets up the programaticHorizontalCollectionView so that it is a child view controller to this view controller. This method also sets up the placeholder items needed to be shown while we wait for for the server to return data. Finally this method sets the background color of the programaticHorizontalCollectionView to be white instead of its default color of black.
    */
    func setUpProgramaticHorizontalCollectionViewController(){
        
        //initialize programaticHorizontalCollectionViewController using MILHorizontalCollectionViewFlowLayout
        let flow = MILHorizontalCollectionViewFlowLayout()
        self.programaticHorizontalCollectionViewController = MILHorizontalCollectionViewController(collectionViewLayout: flow)
        
        //add programaticHorizontalCollectionViewController as child view controller to this view controller
        self.addChildViewController(self.programaticHorizontalCollectionViewController)
        self.programaticHorizontalCollectionViewController.didMoveToParentViewController(self)
        
        //set frame of programaticHorizontalCollectionViewController's view and add the programaticHorizontalCollectionViewController's view to this view controllers view
        self.programaticHorizontalCollectionViewController.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height/2, UIScreen.mainScreen().bounds.width, 180)
        self.view.addSubview(self.programaticHorizontalCollectionViewController.view)
        
        //set the locally stored place holder image to be shown in each cell while we wait for the server to return an array of imageURLs or for the images to download from the image url's
        self.programaticHorizontalCollectionViewController.localPlaceHolderImageName = "placeholder_gray"
        
         //set the number of placeholder cells to be displayed while we wait for the server to return an array of imageURLs
        self.programaticHorizontalCollectionViewController.setUpWithInitialPlaceHolderItems(self.kNumberOfInitialPlaceHolderItems)
        self.programaticHorizontalCollectionViewController.collectionView?.reloadData()
        
        //change default collectionView color of black to white
        self.programaticHorizontalCollectionViewController.collectionView?.backgroundColor = UIColor.whiteColor()
    }
    
    /**
    This method fakes a query to a server to get images. It assumes a kImageServerDelayTime second delay
    */
    func getImagesFromServer(){
       NSTimer.scheduledTimerWithTimeInterval(self.kImageServerDelayTime, target: self, selector: Selector("didReceiveImagesFromSever"), userInfo: nil, repeats: false)
    }
    
    
    /**
    This method fakes a call back from a server that has an array of imageURL's
    */
    func didReceiveImagesFromSever(){
        
        //imageURL array from server
        let imageURLArray = self.getImageURLArray()
        
        //refresh storyboardHorizontalCollectionView with newly receieved data
        self.storyboardHorizontalCollectionView.setToHandleImageURLStrings()
        self.storyboardHorizontalCollectionView.refresh(imageURLArray)
        
        //refresh programaticHorizontalCollectionView with newly received data
        self.programaticHorizontalCollectionViewController.setToHandleImageURLStrings()
        self.programaticHorizontalCollectionViewController.refresh(imageURLArray)
    }
    
    /**
    This method sets up the imageURLArray used to populate the horizontal collection view
    */
    func getImageURLArray() -> [String]{
        
        let red = "http://i.imgur.com/3Pqd3Oi.png"
        
        let blue = "http://i.imgur.com/Gg0UPZE.png"
        
        let green = "http://i.imgur.com/57BTbvG.png"
        
        let yellow = "http://i.imgur.com/UhDUBIL.png"
        
        let purple = "http://i.imgur.com/yOo7qM7.png"
        
        let teal = "http://i.imgur.com/Z9PYxs0.png"
        
        let orange = "http://i.imgur.com/BfkrZer.png"
        
        let imageURLArray = [red, blue, green, yellow, purple, teal, orange]
        
        return imageURLArray
    }
    

    /**
    This method is how we get access to the storyboardHorizontalCollectionView that is embeded in the container view on the Main.storyboard
    
    - parameter segue:
    - parameter sender:
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //check for the segue identifier defined for the container view's embeded segue connected to the MILHorizontalCollectionViewController on Main.storyboard
        if(segue.identifier == "horizontalCollectionView"){
            self.storyboardHorizontalCollectionView = segue.destinationViewController as! MILHorizontalCollectionViewController
            
            //set the locally stored place holder image to be shown in each cell while we wait for the server to return an array of imageURLs or for the images to download from the image url's
            self.storyboardHorizontalCollectionView.localPlaceHolderImageName = "placeholder_gray"
            
            //set the number of placeholder cells to be displayed while we wait for the server to return an array of imageURLs
            self.storyboardHorizontalCollectionView.setUpWithInitialPlaceHolderItems(self.kNumberOfInitialPlaceHolderItems)
        }
    }
}

