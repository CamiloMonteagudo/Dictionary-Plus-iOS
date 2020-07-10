//
//  ViewController.m
//  Dictionary Plus
//
//  Created by Admin on 13/3/18.
//  Copyright © 2018 bigxsoft. All rights reserved.
//

#import "ViewController.h"
#import "SelLangsView.h"

@interface ViewController ()
  {
  CGFloat xCent;
  CGFloat yCent;
  }

@property (weak, nonatomic) IBOutlet UIView *DictDataZone;
@property (weak, nonatomic) IBOutlet SelLangsView *selLangs;

@end

@implementation ViewController

- (void)viewDidLoad
  {
  [super viewDidLoad];
  
  [_selLangs SetDictWithSrc:2 AndDes:3];
  }


- (void)didReceiveMemoryWarning
  {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  }


//- (IBAction)PanGesture:(UIPanGestureRecognizer *)sender
//  {
//  if( sender.state == UIGestureRecognizerStateBegan )
//     {
//     CGPoint pnt = _DictDataZone.center;
//
//     xCent = pnt.x;
//     yCent = pnt.y;
//     }
//  else if( sender.state == UIGestureRecognizerStateChanged )
//     {
//     CGFloat x = xCent + [sender translationInView:self.view].x;
//     CGFloat w = self.view.frame.size.width;
//     
//     if( x>=0 && x<=w )
//       _DictDataZone.center = CGPointMake( x, yCent);
//     }
//  else if( sender.state == UIGestureRecognizerStateEnded )
//    {
//     CGFloat x = [sender translationInView:self.view].x;
//     CGFloat w = self.view.frame.size.width;
//
//     CGFloat desp = (x<0)? -x : x;
//    
//     if( desp > w/2 )
//       xCent = ( x<0 )? 0 : w;
//    
//     [UIView animateWithDuration:0.5
//                      animations:^{
//                                  _DictDataZone.center = CGPointMake(xCent, yCent);
//                                  }];
//    
//     }
//  }
@end
