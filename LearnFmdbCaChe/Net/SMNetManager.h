//
//  SMNetManager.h
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMNetManager : AFHTTPSessionManager

@property (nonatomic, strong) NSMutableArray *feedsArray;

@property (nonatomic, strong) NSMutableDictionary *iconDict;

+ (SMNetManager *)shareInstance;

- (RACSignal *)fetchAllFeedWithModelArray:(NSMutableArray *)modelArray;

+ (BOOL)isWifi;

@end

NS_ASSUME_NONNULL_END
