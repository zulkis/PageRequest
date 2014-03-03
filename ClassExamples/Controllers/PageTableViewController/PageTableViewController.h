//
//  PageTableViewController.h
//
//  Created by Alexey Minaev on 10/7/13.
//
//

#import "BaseTableViewControllerWithFetchedResultController.h"
#import "Paging.h"

@class PageRequestInfo;

/*
 Pure abstract class
 */
@interface PageTableViewController : BaseTableViewControllerWithFetchedResultController <Paging> {
  @protected
  PageRequestInfo *_requestInfo;
}

@property (nonatomic, strong) PageRequestInfo *requestInfo;
@property (nonatomic) NSUInteger moreDataCellsOffset;

@property (nonatomic) BOOL updatingInProgress;

@end