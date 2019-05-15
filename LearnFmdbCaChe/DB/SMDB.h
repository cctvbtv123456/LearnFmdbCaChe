//
//  SMDB.h
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMFeedModel.h"

NS_ASSUME_NONNULL_BEGIN

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface SMDB : NSObject
@property (nonatomic, strong) NSMutableDictionary *feedIcons;
+ (SMDB *)shareInstance;
// 插入feed内容
- (RACSignal *)insertWithFeedModel:(SMFeedModel *)feedModel;
// 读取所有feeds
- (RACSignal *)selectAllFeeds;
// 按照翻页取数据
- (RACSignal *)selectFeedItemsWithPage:(NSUInteger)page fid:(NSUInteger)fid;
// 标注已读
- (RACSignal *)markFeedItemAsReadiid:(NSUInteger)iid fid:(NSUInteger)fid;
// 标注全部已读
- (RACSignal *)markFeedAllItemsAsReadfid:(NSUInteger)fid;
// 读取所有未缓存的本地rss item
- (RACSignal *)selectAllUnCachedFeedItems;
//标记为已经缓存
- (RACSignal *)markFeedItemAsCached:(NSUInteger)iid;
//标记全部为已经缓存
- (RACSignal *)markAllFeedItemAsCached;

@end

NS_ASSUME_NONNULL_END
