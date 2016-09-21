//
//  ViewController.m
//  AnimationProject
//
//  Created by Jesse Sahli on 8/1/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIPushBehavior *pusher;
@property CGPoint start;
@property (strong, nonatomic) UILabel *scoreLabel;
@property int score;

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;

@property (nonatomic) CGFloat bottomBarPosition;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeScoreLabel];
    
    self.ball.layer.cornerRadius = 15;
    
    [self.loseLabel setHidden:YES];
    [self.finalScoreLabel setHidden:YES];
    self.start = self.ball.center;
    self.score = 0;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.bottomBar addGestureRecognizer:panGestureRecognizer];
    

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    if(self.bottomBarPosition == 0){
        self.bottomBarPosition = self.bottomBar.center.y;
    }
    //the following code only makes the Pan Gesture operate on the X axis!
    CGFloat yAxis = self.bottomBar.center.y;

    panGestureRecognizer.view.center = CGPointMake(touchLocation.x, self.bottomBarPosition);
    [self.animator updateItemUsingCurrentState:self.bottomBar];
}

-(void)makeScoreLabel {
    
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    self.scoreLabel.text = @"0";
    self.scoreLabel.font = [UIFont fontWithName:@"Chalkduster" size:26];
    self.scoreLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.scoreLabel];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)startButton:(id)sender {
    //timer not working
//    [NSTimer timerWithTimeInterval:2 target:self selector:@selector(startGame) userInfo:nil repeats:NO];
//    [self startGame];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(startGame)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)startGame{
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",_score];
    [self.finalScoreLabel setHidden:YES];
    [self.loseLabel setHidden:YES];
    [self.ball setHidden:NO];
    [self.bottomBar setHidden:NO];
    [self.startButtonOutlet setHidden:YES];
    
    self.ball.center = self.start;
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    [animator addBehavior:gravityBehavior];
    
    UIDynamicItemBehavior *barBehavior = [[UIDynamicItemBehavior alloc]init];
    [barBehavior addItem:self.bottomBar];
    barBehavior.allowsRotation = NO;
    barBehavior.density = 5000.0f;
    [animator addBehavior:barBehavior];
    
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc]init];
    [ballBehavior addItem:self.ball];
    ballBehavior.elasticity = 1.01f;
    ballBehavior.allowsRotation = YES;
    ballBehavior.friction = 0.0;
    ballBehavior.resistance = 0.0;
    ballBehavior.angularResistance = 0.0;
    [animator addBehavior:ballBehavior];
    
    
    self.pusher = [[UIPushBehavior alloc] initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    self.pusher.pushDirection = CGVectorMake(0.5, 1.0);
    self.pusher.magnitude = 0.3f;
    self.pusher.active = YES;
    [animator addBehavior:self.pusher];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ball, self.bottomBar]];
    
    
    CGFloat bottomY = CGRectGetMaxY(self.view.frame);
    CGFloat leftX = CGRectGetMinX(self.view.frame);
    CGFloat rightX = CGRectGetMaxX(self.view.frame);
    
    CGPoint bottomLeftCorner = CGPointMake(leftX, bottomY);
    CGPoint bottomRightCorner = CGPointMake(rightX, bottomY);
    
    [collisionBehavior addBoundaryWithIdentifier:@"bottom" fromPoint:bottomLeftCorner toPoint:bottomRightCorner];
    
    
    // Creates collision boundaries from the bounds of the dynamic animator's
    // reference view (self.view).
    
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [animator addBehavior:collisionBehavior];
    
    self.animator = animator;
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p{

   
    NSString *string = [NSString stringWithFormat:@"%@",identifier];
    if([string isEqualToString:@"bottom"] && item == self.ball){
        NSLog(@"You lose");
        [self.animator removeAllBehaviors];
        self.finalScoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.score];
        [self.finalScoreLabel setHidden:NO];
        [self.ball setHidden:YES];
        [self.bottomBar setHidden:YES];
        [self.loseLabel setHidden:NO];
        [self.startButtonOutlet setHidden:NO];
        self.score = 0;

        self.startButtonOutlet.titleLabel.text = @"Restart";
    }
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 {


   if ((item1 == self.ball && item2 == self.bottomBar) || (item1 == self.bottomBar && item2 == self.ball)) {
      _score++;
       //trying to shrink paddle after each hit
//       CGFloat shrinkedWidth = (self.bottomBar.frame.size.width / 1.55);
//       self.bottomBar.frame = CGRectMake(self.bottomBar.frame.origin.x, self.bottomBar.frame.origin.y, shrinkedWidth, self.bottomBar.frame.size.height);
//     [self.animator updateItemUsingCurrentState:self.bottomBar];
      self.scoreLabel.text = [NSString stringWithFormat:@"%d",_score];
   }
}

@end
