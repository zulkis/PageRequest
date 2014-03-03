//
//  Business+Extension.h
//
//  Created by Alexey Minaev on 10/3/13.
//
//

#import "Business.h"
#import "Requesting.h"
#import "PageRequesting.h"

typedef NS_ENUM(NSInteger, BusinessRequestType) {
  BusinessRequestTypeAll,
  BusinessRequestTypeCurrentLocation
};

@interface Business (Extension) <Requesting, PageRequesting>

- (NSString*)sharingText;
+ (void)requestParamsForType:(BusinessRequestType)type paramsBlock:(void(^)(NSDictionary *dict, NSError *error))paramsBlock;

@end
