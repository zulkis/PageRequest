//
//  BaseTableViewController.m
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end


@implementation BaseTableViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
//  [self.navigationItem setHidesBackButton:YES];
  
//  if (self.forceBackButton) {
//    self.navigationItem.leftBarButtonItem = [[UMBackBarButton alloc]
//                                             initWithTarget:self
//                                             action:@selector(onBackButtonTap:)];
//  } else if(self.presentingViewController && self.navigationController.viewControllers[0] == self) {
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                             target:self
//                                             action:@selector(onBackButtonTap:)];
//  } else {
//    self.navigationItem.leftBarButtonItem = [[UMBackBarButton alloc]
//                                             initWithTarget:self
//                                             action:@selector(onBackButtonTap:)];
//  }
}

- (void)onBackButtonTap:(UIBarButtonItem *)button
{
  if(self.presentingViewController && self.navigationController.viewControllers[0] == self) {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

@end
