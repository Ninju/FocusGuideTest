//
//  ViewController.swift
//  FocusGuideTest
//
//  Created by Alex Watt on 18/03/2016.
//  Copyright © 2016 Alex Watt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    private var rightHandFocusGuide = UIFocusGuide()
    private var insetButton : UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let tableView = UITableView(frame: CGRectMake(0, 0, 450, 1080))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.blackColor().CGColor

        let rightHandView = UIView(frame: CGRectMake(480, 0, 1920 - 480, 1080))

        rightHandView.backgroundColor = UIColor.grayColor()
        rightHandView.layer.borderColor = UIColor.blackColor().CGColor
        rightHandView.layer.borderWidth = 1.0

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 50.0

        let collectionView = UICollectionView(frame: CGRectMake(50, 50, 1000, 500), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        rightHandView.addSubview(collectionView)

        insetButton.frame = CGRectMake(500, 700, 300, 100)
        insetButton.backgroundColor = UIColor.whiteColor()
        insetButton.layer.borderWidth = 1.0
        insetButton.layer.borderColor = UIColor.blackColor().CGColor
        insetButton.setTitle("Press This", forState: .Normal)
        insetButton.setTitle("Highlighted This", forState: .Highlighted)
        insetButton.setTitle("Selected This", forState: .Selected)
        insetButton.setTitle("Focused This", forState: .Focused)

        insetButton.setTitleColor(UIColor.blackColor(), forState: .Normal)

        let secondButton = UIButton(frame: CGRectMake(500, 900, 500, 100))
        secondButton.backgroundColor = UIColor.whiteColor()
        secondButton.layer.borderWidth = 1.0
        secondButton.layer.borderColor = UIColor.blackColor().CGColor
        secondButton.setTitle("Now press this!", forState: .Focused)
        secondButton.setTitle("Press this one instead", forState: .Normal)
        secondButton.setTitleColor(UIColor.blackColor(), forState: .Normal)

        rightHandView.addSubview(secondButton)
        rightHandView.addSubview(insetButton)

        view.addSubview(rightHandView)
        view.addSubview(tableView)


        view.addLayoutGuide(rightHandFocusGuide)

        rightHandFocusGuide.bottomAnchor.constraintEqualToAnchor(tableView.bottomAnchor).active = true
        rightHandFocusGuide.leftAnchor.constraintEqualToAnchor(tableView.rightAnchor).active = true
        rightHandFocusGuide.topAnchor.constraintEqualToAnchor(tableView.topAnchor).active = true
        rightHandFocusGuide.rightAnchor.constraintEqualToAnchor(rightHandView.leftAnchor).active = true

        rightHandFocusGuide.preferredFocusedView = insetButton
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        print("Did update focus")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "Item \(indexPath.row)"
        return cell
    }

    func tableView(tableView: UITableView, didUpdateFocusInContext context: UITableViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        guard let nextView = context.nextFocusedView else { return }
        if (nextView == insetButton) {
            guard let indexPath = context.previouslyFocusedIndexPath, let cell = tableView.cellForRowAtIndexPath(indexPath) else {
                return
            }
            rightHandFocusGuide.preferredFocusedView = cell
        } else {
            rightHandFocusGuide.preferredFocusedView = insetButton
        }

        guard let indexPath = context.nextFocusedIndexPath, let cell = tableView.cellForRowAtIndexPath(indexPath)
            else { return }

        cell.textLabel?.textColor = UIColor.orangeColor()

        guard let prevIndexPath = context.previouslyFocusedIndexPath, let prevCell = tableView.cellForRowAtIndexPath(prevIndexPath)
            else { return }

        prevCell.textLabel?.textColor = UIColor.blackColor()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }

    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        guard let prevView = context.previouslyFocusedView, let nextView = context.nextFocusedView else {
            return
        }

        let (offsetX, offsetY) : (CGFloat, CGFloat) = (5, -5)
        if (prevView.isDescendantOfView(collectionView)) {
            prevView.frame = CGRectOffset(prevView.frame, -offsetX, -offsetY)
        }

        if (nextView.isDescendantOfView(collectionView)) {
            nextView.frame = CGRectOffset(nextView.frame, offsetX, offsetY)
        }

    }
}

