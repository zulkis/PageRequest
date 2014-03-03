//
//  Paging.h
//
//  Created by Alexey Minaev on 10/8/13.
//
//

#import <Foundation/Foundation.h>

@protocol Paging <NSObject>

@required
- (void)loadFirstPage;
- (void)loadNextPage;

@end
