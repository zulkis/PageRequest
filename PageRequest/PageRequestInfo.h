//
//  PageRequestInfo.h
//
//  Created by Alexey Minaev on 10/4/13.
//
//

#import "RequestInfo.h"
#import "PageRequesting.h"

@interface PageRequestInfo : RequestInfo

@property (nonatomic, readonly) NSUInteger currentPage;
@property (nonatomic, readonly) NSUInteger lastPage;

@property (nonatomic) BOOL requestErrorOccured;

- (BOOL)nextPageAvailable;

@end
