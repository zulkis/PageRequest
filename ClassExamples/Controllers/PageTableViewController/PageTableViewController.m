//
//  PageTableViewController.m
//
//  Created by Alexey Minaev on 10/7/13.
//
//

#import "PageTableViewController.h"
#import "LoadingFooterView.h"
#import "PageRequestInfo.h"

@interface PageTableViewController ()

@property (nonatomic, strong) IBOutlet LoadingFooterView *loadingFooterView;

@end

@implementation PageTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.moreDataCellsOffset = 4;
}

- (NSFetchedResultsController *)fetchedResultsController {
  return self.requestInfo.fetchedResultsController;
}

- (IBAction)refreshControlDidChangeValue:(UIRefreshControl*)sender {
  if (!self.refreshControl.refreshing) {
    [self.refreshControl beginRefreshing];
  }
  [self loadFirstPage];
}

- (NSString *)noMoreEntitiesLeftString {
  return [NSString stringWithFormat:NSLocalizedString(@"NoMoreEntityFormat", nil), NSLocalizedString(NSStringFromClass(self.requestInfo.targetClassToRequestFrom), nil)];
}

- (NSString *)noEntitiesLeftString {
  return [NSString stringWithFormat:NSLocalizedString(@"NoEntityFormat", nil), NSLocalizedString(NSStringFromClass(self.requestInfo.targetClassToRequestFrom), nil)];
}

- (void)setUpdatingInProgress:(BOOL)updatingInProgress {
  _updatingInProgress = updatingInProgress;
  BOOL nextPageAvailable = self.requestInfo.nextPageAvailable;
  
  if(updatingInProgress)
  {
    self.loadingFooterView.activityIndicatorView.hidden = self.requestInfo.currentPage < 2;
    self.loadingFooterView.noMoreLeftLabel.hidden = YES;
  }
  else
  {
    self.loadingFooterView.activityIndicatorView.hidden = !nextPageAvailable;
    self.loadingFooterView.noMoreLeftLabel.text = self.requestInfo.currentPage > 1 ?
                                                 [self noMoreEntitiesLeftString] :
                                                 [self noEntitiesLeftString];
    
    self.loadingFooterView.noMoreLeftLabel.hidden = nextPageAvailable;
    if (self.refreshControl.refreshing) {
      [self.refreshControl endRefreshing];
    }
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = NSClassFromString([NSStringFromClass(self.requestInfo.targetClassToRequestFrom) stringByAppendingString:@"Cell"]);
  NSAssert(cellClass, @"CellClass must exist");
  return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  uint32_t count = [[self.fetchedResultsController fetchedObjects] count];
  if (indexPath.row == count - self.moreDataCellsOffset) {
    [self loadNextPage];
  }
}

#pragma mark - Paging

- (void)loadFirstPage {
  OverrideException
}

- (void)loadNextPage {
  OverrideException
}


@end
