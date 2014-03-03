//
//  RequestInfo.m
//
//  Created by Alexey Minaev on 10/4/13.
//
//

#import "RequestInfo.h"
#import <AFHTTPRequestOperation.h>

@implementation RequestInfo

- (void)setTargetClassToRequestFrom:(Class)targetClassToRequestFrom {
  NSAssert([targetClassToRequestFrom isSubclassOfClass:[NSManagedObject class]], @"targetClassToRequestFrom must be subclass of NSManagedObject");
  _targetClassToRequestFrom = targetClassToRequestFrom;
}

- (void)performRequestWithCompletion:(void (^)(NSError *))completion {
  NSAssert(nil, @"performRequestWithCompletion requires implementation");
}

- (void)truncateAllData {
  if (self.workingContext) {
    [self.targetClassToRequestFrom truncateAllInContext:self.fetchedRestsController.managedObjectContext];
  }
}

- (void)cancelRequest {
  [self.requestOperation setCompletionBlockWithSuccess:nil failure:nil];
  [self.requestOperation cancel];
  _requestOperation = nil;
}

@end
