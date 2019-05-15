//
//  SMFeedModel.h
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

//feed item
@interface SMFeedItemModel : JSONModel
@property (nonatomic) NSUInteger iid;
@property (nonatomic) NSUInteger fid;
@property (nonatomic, copy) NSString<Optional> *link;         //文章链接
@property (nonatomic, copy) NSString<Optional> *title;        //文章标题
@property (nonatomic, copy) NSString<Optional> *author;       //作者
@property (nonatomic, copy) NSString<Optional> *category;     //分类
@property (nonatomic, copy) NSString<Optional> *pubDate;      //发布日期
@property (nonatomic, copy) NSString<Optional> *des;          //正文内容
@property (nonatomic) NSUInteger isRead;                      //是否已读
@property (nonatomic) NSUInteger isCached;                    //是否缓存
@property (nonatomic, copy) NSString<Optional> *iconUrl;      //频道icon
@end

///////////////////////////////////////////////////////


@interface SMFeedModel : JSONModel
@property (nonatomic) NSUInteger fid;
@property (nonatomic, copy) NSString<Optional> *title;        //名称
@property (nonatomic, copy) NSString<Optional> *link;         //博客链接
@property (nonatomic, copy) NSString<Optional> *des;          //简介
@property (nonatomic, copy) NSString<Optional> *copyright;
@property (nonatomic, copy) NSString<Optional> *generator;
@property (nonatomic, copy) NSString<Optional> *imageUrl;     //icon图标
@property (nonatomic, strong) NSMutableArray *items;          //SMFeedItemModel
@property (nonatomic, copy) NSString<Optional> *feedUrl;      //博客feed的链接
@property (nonatomic) NSUInteger unReadCount;
@property (nonatomic) BOOL isSync;
@end

NS_ASSUME_NONNULL_END
