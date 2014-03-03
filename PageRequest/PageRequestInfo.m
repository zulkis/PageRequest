//
//  PageRequestInfo.m
//
//  Created by Alexey Minaev on 10/4/13.
//
//

#import "PageRequestInfo.h"

@interface PageRequestInfo ()

@property (nonatomic, readwrite) NSUInteger currentPage;
@property (nonatomic, readwrite) NSUInteger lastPage;

@end

@implementation PageRequestInfo

- (id)init {
  self = [super init];
  if (self) {
    self.currentPage = 0;
    self.lastPage = 0;
  }
  return self;
}

- (void)performRequestWithCompletion:(void(^)(NSError *error))completion {
  if ([self.targetClassToRequestFrom conformsToProtocol:@protocol(PageRequesting)]) {
    if (!self.requestInProgress && [self nextPageAvailable]) {
      self.requestInProgress = YES;
      if (!self.workingContext) {
        _workingContext = [NSManagedObjectContext contextWithParent:self.fetchedRestsController.managedObjectContext];
      }
      NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"page":@(self.currentPage+1)}];
      [dict addEntriesFromDictionary:self.requestParams];
      _requestOperation = [self.targetClassToRequestFrom pagedUpdateModelFromPath:self.requestPath
                                                                       withParams:dict
                                                                        inContext:self.workingContext
                                                                       completion:^(NSError* error, NSUInteger currentPage, NSUInteger lastPage) {
                                                                         if (!error) {
                                                                           self.currentPage = currentPage;
                                                                           self.lastPage = lastPage;
                                                                           completion(nil);
                                                                         } else {
                                                                           completion(error);
                                                                         }
                                                                         self->_requestOperation = nil;
                                                                         self.requestInProgress = NO;
                                                                       }];
    }
  }
}

- (void)truncateAllData {
  self.currentPage = 0;
  self.lastPage = NSUIntegerMax;
  self.requestErrorOccured = NO;
  [super truncateAllData];
}

- (BOOL)nextPageAvailable {
  return (self.currentPage < self.lastPage) && !self.requestErrorOccured;
}

@end
