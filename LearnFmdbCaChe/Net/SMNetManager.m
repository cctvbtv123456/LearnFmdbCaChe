//
//  SMNetManager.m
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import "SMNetManager.h"
#import "SMFeedModel.h"
#import "SMFeedStore.h"
#import "SMDB.h"

@interface SMNetManager()

@property (nonatomic, strong) SMFeedStore *feedStore;

@end


@implementation SMNetManager

+ (SMNetManager *)shareInstance{
    static SMNetManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SMNetManager manager];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
        instance.requestSerializer.timeoutInterval = 20.0;
    });
    return instance;
}

- (RACSignal *)fetchAllFeedWithModelArray:(NSMutableArray *)modelArray{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        // 创建并行队列
        dispatch_queue_t fetchFeedQueue = dispatch_queue_create("com.starming.fetchfeed.fetchfeed", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_t group = dispatch_group_create();
        self.feedsArray = modelArray;
        
        for (int i = 0; i < modelArray.count; i++) {
            dispatch_group_enter(group);
            
            SMFeedModel *feedModel = modelArray[i];
            feedModel.isSync = NO;
            
            [self GET:feedModel.feedUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                dispatch_async(fetchFeedQueue, ^{
                
                    @strongify(self);
                    // 解析feed
                    self.feedsArray[i] = [self.feedStore updateFeedModelWithData:responseObject preModel:feedModel];
                    // 入库存储
                    SMDB *db = [SMDB shareInstance];
                    @weakify(self);
                    [[db insertWithFeedModel:self.feedsArray[i]] subscribeNext:^(NSNumber *x) {
                        @strongify(self);
                        SMFeedModel *model = (SMFeedModel *)self.feedsArray[i];
                        model.fid = [x integerValue];
                        if (model.imageUrl.length > 0) {
                            NSString *fidStr = [x stringValue];
                            db.feedIcons[fidStr] = model.imageUrl;
                        }
                        // 插入本地数据库成功后开始sendNext
                        [subscriber sendNext:@(i)];
                        // 通知单个完成
                        dispatch_group_leave(group);
                    }];
                });//end dispatch async
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                dispatch_async(fetchFeedQueue, ^{
                    [[[SMDB shareInstance] insertWithFeedModel:self.feedsArray[i]] subscribeNext:^(NSNumber *x) {
                        SMFeedModel *model = (SMFeedModel *)self.feedsArray[i];
                        model.fid = [x integerValue];
                        dispatch_group_leave(group);
                    }];
                });//end dispatch async
            }];
        }//end for
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [subscriber sendCompleted];
        });
        return nil;
    }];
}

#pragma mark - Class method
+ (BOOL)isWifi {
    UIApplication *app = [UIApplication sharedApplication];
    NSMutableArray *children = [NSMutableArray new];
    if ([app valueForKeyPath:@"statusBar"]) {
        if ([[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]) {
            [children arrayByAddingObjectsFromArray:[[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews]];
        }
    }
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            // 0: 无网络  1:2G 2:3G 3:4G  5:WIFI
            NSLog(@"netType = %d", netType);
            if (netType == 5) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Getter
- (SMFeedStore *)feedStore {
    if (!_feedStore) {
        _feedStore = [[SMFeedStore alloc] init];
    }
    return _feedStore;
}
- (NSMutableArray *)feedsArray {
    if (!_feedsArray) {
        _feedsArray = [NSMutableArray array];
    }
    return _feedsArray;
}

@end
