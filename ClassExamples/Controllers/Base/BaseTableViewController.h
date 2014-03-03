//
//  BaseTableViewController.h
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

@property (nonatomic) BOOL forceBackButton;

- (void)onBackButtonTap:(UIBarButtonItem *)button;

@end
