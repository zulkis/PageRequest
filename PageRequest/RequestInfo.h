//
//  RequestInfo.h
//
//  Created by Alexey Minaev on 10/4/13.
//
//

#import <Foundation/Foundation.h>
#import "Requesting.h"

@class AFHTTPRequestOperation;

@interface RequestInfo : NSObject {
  @protected
  NSManagedObjectContext *_workingContext;
  AFHTTPRequestOperation *_requestOperation;
}

@property (nonatomic) Class targetClassToRequestFrom;
@property (nonatomic, copy) NSString *requestPath;
@property (nonatomic, strong) NSDictionary *requestParams;
@property (nonatomic, strong) NSFetchedRestsController *fetchedRestsController;
@property (nonatomic) BOOL requestInProgress;

@property (nonatomic, strong, readonly) AFHTTPRequestOperation *requestOperation;
@property (nonatomic, strong, readonly) NSManagedObjectContext *workingContext;

- (void)truncateAllData;
- (void)cancelRequest;
- (void)performRequestWithCompletion:(void(^)(NSError *error))completion;

@end
