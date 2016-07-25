//
//  ViewController.swift
//  Draft_Hypa_02
//
//  Created by mac on 11.07.16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    var view0: UIView!
    var view1: UIView!
    var view2: UIView!
    var view3: UIView!
    var view4: UIView!
    var view5: UIView!
    var views: [UIView]!

    var defaultViewsCenter: [CGPoint] = []
    var offset = CGPoint.zero
    var attachmentDistance: CGFloat = 80
    var passedAttachmentPoints: Int = 1
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    
    var view0PanGestureRecognizer: UIPanGestureRecognizer!
    var view1PanGestureRecognizer: UIPanGestureRecognizer!
    var view2PanGestureRecognizer: UIPanGestureRecognizer!
    var view3PanGestureRecognizer: UIPanGestureRecognizer!
    var view4PanGestureRecognizer: UIPanGestureRecognizer!
    var view5PanGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        createConstrants()
        views = [view0, view1, view2, view3, view4, view5]
        
        animator = UIDynamicAnimator(referenceView: view)
        animator.setValue(true, forKey: "debugEnabled")
        
        //Create UIPanGestureRecognizer
        view0PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        view1PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        view2PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        view3PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        view4PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        view5PanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        
        //Set delegate to UIPanGestureRecognizer
        view0PanGestureRecognizer.delegate = self
        view1PanGestureRecognizer.delegate = self
        view2PanGestureRecognizer.delegate = self
        view3PanGestureRecognizer.delegate = self
        view4PanGestureRecognizer.delegate = self
        view5PanGestureRecognizer.delegate = self
        
        //Set UIPanGestureRecognizer to views
        view0.addGestureRecognizer(view0PanGestureRecognizer)
        view1.addGestureRecognizer(view1PanGestureRecognizer)
        view2.addGestureRecognizer(view2PanGestureRecognizer)
        view3.addGestureRecognizer(view3PanGestureRecognizer)
        view4.addGestureRecognizer(view4PanGestureRecognizer)
        view5.addGestureRecognizer(view5PanGestureRecognizer)
        
        //MARK: Why we cant set isExclusiveTouch only for one view (in pan.view) and must setting for all views?
        //Turn off multi touch for views
        view0.isExclusiveTouch = true
        view1.isExclusiveTouch = true
        view2.isExclusiveTouch = true
        view3.isExclusiveTouch = true
        view4.isExclusiveTouch = true
        view5.isExclusiveTouch = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Set defaultViewCenter
        //FIXME: Not in the right place (viewDidAppear). And hardcode linking between array's index and view's tag
        defaultViewsCenter.append(view0.center)
        defaultViewsCenter.append(view1.center)
        defaultViewsCenter.append(view2.center)
        defaultViewsCenter.append(view3.center)
        defaultViewsCenter.append(view4.center)
        defaultViewsCenter.append(view5.center)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func pan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: self.view)
        guard let touchedView = pan.view else {
            print("Error with unwrap pan.view")
            return
        }
        let location = pan.location(in: view)
        print(translation.x)
        
        switch pan.state {
            case .began:
                //Set previus touched view to init position if user starts touching view due snaping
//                lastTouchedView.center = defaultViewsCenter[lastTouchedView.tag]
                
                //Set previous touched views to init default positions is user starts touching view due snaping
                //FIXME: Cycles in this function is not a good idea?
                for view in views {
                    view.center = defaultViewsCenter[view.tag]
                }
                
                animator.removeAllBehaviors()
                
                let dynamicItemBehavior = UIDynamicItemBehavior(items: views)
                dynamicItemBehavior.allowsRotation = false
                animator.addBehavior(dynamicItemBehavior)
//                let panViewCenter = panView.center
//                offset.x = location.x - panViewCenter.x
//                offset.y = location.y - panViewCenter.y
                
                if #available(iOS 9.0, *) {
                    attachmentBehavior = UIAttachmentBehavior.slidingAttachment(with: touchedView, attachmentAnchor: location, axisOfTranslation: CGVector(dx: 0, dy: 1))
                    animator.addBehavior(attachmentBehavior)
                } else { }
                
                attachmentDistance = 80
                passedAttachmentPoints = 1
            
                if translation.x < 0 {
                    if #available(iOS 9.0, *) {
                        //FIXME: 1) Vague appeal views[view.tag + 1]  2) Ugly "if pyramid"
                        for view in views {
                            if view.tag < (views.count - 1) {
                                let slidingAttachment = UIAttachmentBehavior.slidingAttachment(with: view, attachedTo: views[view.tag + 1], attachmentAnchor: views[view.tag + 1].center, axisOfTranslation: CGVector(dx: 0, dy: 1))
                                animator.addBehavior(slidingAttachment)
                            }
                        }
                    } else { }
                }

            
            case .changed:
//                panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y)
//                pan.setTranslation(CGPoint.zero, in: panView)
//
//                if location.x > 30 {
//                    for view in views {
//                        if view != panView {
//                            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y)
//                            pan.setTranslation(CGPoint.zero, in: view)
//                        }
//                    }
//                }
//                location.x -= offset.x
//                location.y -= offset.y
            
                // Bound the item position inside the reference view.
//                location.x = max(0, location.x)
//                location.x = min(view.bounds.width, location.x)
//                location.y = max(0, location.y)
//                location.y = min(view.bounds.height, location.y)
            
//                panView.center = location
                attachmentBehavior.anchorPoint = location
            
                //FIXME: 1) Ugly "if-pyramid" 2) Copypaste slidingAttachment
                if translation.x > attachmentDistance {
                    if #available(iOS 9.0, *) {
                        //FIXME: 1) Vague appeal "views[touchedView.tag - (passedTranslationPoins - 1)]"  2) Creating slidingAttachment behaviors with same variable name
                        //MARK: Why fixAttachmentBehavior does not work with "dynamicItemBehavior.allowsRotation = false" and all work fine with slidingAttachment?
                        if touchedView.tag - passedAttachmentPoints >= 0 {
                            let slidingAttachment = UIAttachmentBehavior.slidingAttachment(with: views[touchedView.tag - passedAttachmentPoints], attachedTo: views[touchedView.tag - (passedAttachmentPoints - 1)], attachmentAnchor: views[touchedView.tag - (passedAttachmentPoints - 1)].center, axisOfTranslation: CGVector(dx: 0, dy: 1))
                            animator.addBehavior(slidingAttachment)
                        }
                        if touchedView.tag + passedAttachmentPoints < views.count {
                            let slidingAttachment = UIAttachmentBehavior.slidingAttachment(with: views[touchedView.tag + passedAttachmentPoints], attachedTo: views[touchedView.tag + (passedAttachmentPoints - 1)], attachmentAnchor: views[touchedView.tag + (passedAttachmentPoints - 1)].center, axisOfTranslation: CGVector(dx: 0, dy: 1))
                            animator.addBehavior(slidingAttachment)
                        }
                    } else { }
                    
                    print("passedTranslationPoins: \(passedAttachmentPoints)")
                    attachmentDistance += 80
                    passedAttachmentPoints += 1
                }
            
            
            case .cancelled, .ended:
                animator.removeAllBehaviors()
                //MARK: Be carefull behaviors will affect to all views of your dynamicItemBehaviors, eg snapBehavior affect to all views when it active
                //Add UIDynamicItemBehavior to animator
                let dynamicItemBehavior = UIDynamicItemBehavior(items: views)
                dynamicItemBehavior.allowsRotation = false
                animator.addBehavior(dynamicItemBehavior)
                
                //FIXME: Cycles in this function is not a good idea?
                //FIXME: Creating snap behaviors with same variable name
                //Set UISnapBehavior to views
                for view in views {
                    let snapBehavior = UISnapBehavior(item: view, snapTo: defaultViewsCenter[view.tag])
                    snapBehavior.damping = 0.15
                    animator.addBehavior(snapBehavior)
                }
            
            default: ()
        }
    }
    
    func initViews() {
        //Init
        view0 = UIView()
        view1 = UIView()
        view2 = UIView()
        view3 = UIView()
        view4 = UIView()
        view5 = UIView()
        
        //FIXME: Hardcoding view's tag
        //Set tag
        view0.tag = 0
        view1.tag = 1
        view2.tag = 2
        view3.tag = 3
        view4.tag = 4
        view5.tag = 5
        
        //Prepare Auto Layout
        view0.translatesAutoresizingMaskIntoConstraints = false
        view1.translatesAutoresizingMaskIntoConstraints = false
        view2.translatesAutoresizingMaskIntoConstraints = false
        view3.translatesAutoresizingMaskIntoConstraints = false
        view4.translatesAutoresizingMaskIntoConstraints = false
        view5.translatesAutoresizingMaskIntoConstraints = false
        
        //Set background color
        view0.backgroundColor = UIColor.blue()
        view1.backgroundColor = UIColor.darkGray()
        view2.backgroundColor = UIColor.lightGray()
        view3.backgroundColor = UIColor.brown()
        view4.backgroundColor = UIColor.gray()
        view5.backgroundColor = UIColor.green()
        
        //Set view's corner radius
        view1.layer.cornerRadius = 4
        view2.layer.cornerRadius = 4
        view3.layer.cornerRadius = 4
        view4.layer.cornerRadius = 4
        view5.layer.cornerRadius = 4
        
        //Add to super view
        self.view.addSubview(view0)
        self.view.addSubview(view1)
        self.view.addSubview(view2)
        self.view.addSubview(view3)
        self.view.addSubview(view4)
        self.view.addSubview(view5)
    }
    
    func createConstrants() {
        //Create constrants view0
        let pinLeftView0 = NSLayoutConstraint(item: view0, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        let pinTopView0 = NSLayoutConstraint(item: view0, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 24)
        let pinRightView0 = NSLayoutConstraint(item: view0, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0)
        let heightView0 = NSLayoutConstraint(item: view0, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.25, constant: 0)
        
        //Create constraints view1
        let pinLeftView1 = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 12)
        let pinRightView1 = NSLayoutConstraint(item:view1, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -12)
        let topMarginView1ToView0 = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view0, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 12)
        let heightView1 = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.11, constant: 0)
        
        //Create constrants view2
        let pinLeftView2 = NSLayoutConstraint(item: view2, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 12)
        let pinRightView2 = NSLayoutConstraint(item: view2, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -12)
        let topMarginView2ToView1 = NSLayoutConstraint(item: view2, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view1, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 12)
        let heightView2 = NSLayoutConstraint(item: view2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.11, constant: 0)
        
        //Create constrants view3
        let pinLeftView3 = NSLayoutConstraint(item: view3, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 12)
        let pinRightView3 = NSLayoutConstraint(item: view3, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -12)
        let topMarginView3ToView2 = NSLayoutConstraint(item: view3, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view2, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 12)
        let heightView3 = NSLayoutConstraint(item: view3, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.11, constant: 0)
        
        //Create constrants view4
        let pinLeftView4 = NSLayoutConstraint(item: view4, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 12)
        let pinRightView4 = NSLayoutConstraint(item: view4, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -12)
        let topMarginView4ToView3 = NSLayoutConstraint(item: view4, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view3, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 12)
        let heightView4 = NSLayoutConstraint(item: view4, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.11, constant: 0)
        
        //Create constrants view5
        let pinLeftView5 = NSLayoutConstraint(item: view5, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 12)
        let pinRightView5 = NSLayoutConstraint(item: view5, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -12)
        let topMarginView5ToView4 = NSLayoutConstraint(item: view5, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view4, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 12)
        let heightView5 = NSLayoutConstraint(item: view5, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 0.11, constant: 0)
        
        //Adding to super view
        self.view.addConstraints([pinLeftView0, pinTopView0, pinRightView0, heightView0, pinLeftView1, pinRightView1, heightView1, topMarginView1ToView0, pinLeftView2, pinRightView2, topMarginView2ToView1, heightView2, pinLeftView3, pinRightView3, topMarginView3ToView2, heightView3, pinLeftView4, pinRightView4, topMarginView4ToView3, heightView4, pinLeftView5, pinRightView5, topMarginView5ToView4, heightView5])
    }
}

