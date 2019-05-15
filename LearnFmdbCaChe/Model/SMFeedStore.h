//
//  SMFeedItemModel.h
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import "JSONModel.h"
#import "SMFeedModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMFeedStore : NSObject

//数据转feed的model
- (SMFeedModel *)updateFeedModelWithData:(NSData *)feedData preModel:(SMFeedModel *)preModel;

//获取默认feeds
+ (NSMutableArray *)defaultFeeds;

@end

NS_ASSUME_NONNULL_END
