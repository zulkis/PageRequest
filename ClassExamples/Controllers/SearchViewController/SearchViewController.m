//
//  SearchViewController.m
//
//  Created by Alexey Minaev on 10/14/13.
//
//

#import "SearchViewController.h"
#import "PageRequestInfo.h"
#import "HTTPClient.h"
#import "Business+Extension.h"
#import "BusinessCell.h"
#import "UIAlertView+Alert.h"
#import "BusinessDetailsViewController.h"

@interface SearchViewController () <UISearchBarDelegate, Paging>

@property (nonatomic) BusinessRequestType businessRequestType;
@property (nonatomic) Class classToSearchFrom;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSString *searchString;

@end

@implementation SearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    _businessRequestType = BusinessRequestTypeAll;
    _classToSearchFrom = [Business class];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.updatingInProgress = NO;
  NSString *className = NSStringFromClass([BusinessCell class]);
  [self.tableView registerNib:[UINib nibWithNibName:className bundle:[NSBundle mainBundle]] forCellReuseIdentifier:className];
  [self.searchBar becomeFirstResponder];
}

- (PageRequestInfo *)requestInfo {
  if (!_requestInfo) {
    _requestInfo = [PageRequestInfo new];
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = [NSPersistentStoreCoordinator defaultStoreCoordinator];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Business class])];
    request.includesPendingChanges = YES;
    request.fetchLimit = 20;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    frc.delegate = self;
    NSError *error;
    [frc performFetch:&error];
    if (error) {
      DBGLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    }
    self.requestInfo.fetchedResultsController = frc;
    self.requestInfo.targetClassToRequestFrom = self.classToSearchFrom;
    self.requestInfo.requestPath = @"businesses";
  }
  return _requestInfo;
}

#pragma mark - Request

- (void)loadFromExternalStorageFromStart:(BOOL)fromStart {
  __block PageRequestInfo *requestInfo = self.requestInfo;
  
  if (self.requestInfo.requestOperation && !self.requestInfo.requestOperation.isFinished) {
    [self.requestInfo cancelRequest];
  }
  
  if (!self.requestInfo.requestInProgress && ([self.requestInfo nextPageAvailable] || fromStart)) {
    self.requestInfo.requestErrorOccured = NO;
    self.updatingInProgress = YES;
    
    [Business requestParamsForType:self.businessRequestType paramsBlock:^(NSDictionary *dict, NSError *error) {
      if (error) {
        self.requestInfo.requestErrorOccured = YES;
        self.updatingInProgress = NO;
        [UIAlertView showStaticAlertWithError:error];
      } else {
        if (fromStart) {
          [self.requestInfo truncateAllData];
        }
        NSMutableDictionary *requestParams = [NSMutableDictionary dictionaryWithDictionary:dict];
        requestParams[@"term"] = self.searchString;
        self.requestInfo.requestParams =  requestParams;
        [self.requestInfo performRequestWithCompletion:^(NSError *error) {
          requestInfo.requestErrorOccured = error != nil;
          if (requestInfo == self.requestInfo) {
            self.updatingInProgress = NO;
          }
          if (error) {
            [UIAlertView showStaticAlertWithError:error];
          }
        }];
      }
    }];
    
  }
}

- (void)layoutCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
  id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  if ([cell isKindOfClass:[BusinessCell class]]) {
    Business *business = object;
    BusinessCell *bc = (BusinessCell*)cell;
    [bc setBusiness:business];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [self performSegueWithIdentifier:NSStringFromClass([cell class]) sender:cell];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  [self layoutCell:cell atIndexPath:indexPath];
  [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark - Segue Actions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.destinationViewController isKindOfClass:[BusinessDetailsViewController class]]) {
    Business *business = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    ((BusinessDetailsViewController*)segue.destinationViewController).business = business;
  }
}

#pragma mark - Paging

- (void)loadFirstPage {
  self.tableView.contentOffset = CGPointZero;
  [self loadFromExternalStorageFromStart:YES];
}

- (void)loadNextPage {
  [self loadFromExternalStorageFromStart:NO];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  self.searchString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  [searchBar resignFirstResponder];
  [self loadFirstPage];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	[searchBar setShowsCancelButton:NO animated:YES];
  
	return YES;
}

@end
