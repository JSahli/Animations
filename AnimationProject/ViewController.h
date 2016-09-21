//
//  ViewController.h
//  AnimationProject
//
//  Created by Jesse Sahli on 8/1/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollisionBehaviorDelegate>

@property (strong, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) IBOutlet UIImageView *ball;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (strong, nonatomic) IBOutlet UILabel *loseLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *finalScoreLabel;



- (IBAction)startButton:(id)sender;

@end

