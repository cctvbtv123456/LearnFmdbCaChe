//
//  ViewController.m
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import "ViewController.h"
#import "SMNetManager.h"
#import "SMRootCell.h"
#import "SMFeedStore.h"
#import "SMDB.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,SMRootCellDelegate>
@property (nonatomic, strong) NSMutableArray *feeds;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tbHeaderView;
@property (nonatomic) NSUInteger fetchingCount;
@property (nonatomic) NSUInteger needCacheCount;
@property (nonatomic, strong) UILabel *tbHeaderLabel;
@end

@implementation ViewController

static NSString *rootViewControllerIdentifier = @"SMRootViewControllerCell";

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已阅";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:rootViewControllerIdentifier];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.tbHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    [self.tbHeaderView addSubview:self.tbHeaderLabel];
    
    [self.tbHeaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tbHeaderView);
        make.centerX.equalTo(self.tbHeaderView);
    }];
    
    //本地
    @weakify(self);
    //首页列表数据赋值，过滤无效数据
    RAC(self, feeds) = [[[SMDB shareInstance] selectAllFeeds]
                        map:^id(NSMutableArray *feedsArray) {
                            if (feedsArray.count > 0) {
                                //
                            } else {
                                feedsArray = [SMFeedStore defaultFeeds];
                            }
                            return feedsArray;
                        }];
    
    //监听列表数据变化进行列表更新
    [RACObserve(self, feeds) subscribeNext:^(id x) {
        @strongify(self);
        [self fetchAllFeeds];
    }];
    
    //网络获取
//    [[self rac_signalForSelector:@selector(smRootCellView:clickWithFeedModel:) fromProtocol:@protocol(SMRootCellDelegate)] subscribeNext:^(RACTuple *value) {
//        @strongify(self);
//        SMFeedModel *feedModel = (SMFeedModel *)value.second;
//        SMFeedListViewController *feedList = [[SMFeedListViewController alloc] initWithFeedModel:feedModel];
//        feedList.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:feedList animated:YES];
//    }];
}

#pragma mark - private
- (void)fetchAllFeeds {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.fetchingCount = 0; //统计抓取数量
    @weakify(self);
    [[[[[[SMNetManager shareInstance] fetchAllFeedWithModelArray:self.feeds] map:^id(NSNumber *value) {
        @strongify(self);
        NSUInteger index = [value integerValue];
        self.feeds[index] = [SMNetManager shareInstance].feedsArray[index];
        return self.feeds[index];
    }] doCompleted:^{
        //抓完所有的feeds
        @strongify(self);
        NSLog(@"fetch complete");
        //完成置为默认状态
        self.tbHeaderLabel.text = @"";
        self.tableView.tableHeaderView = [[UIView alloc] init];
        self.fetchingCount = 0;
        //下拉刷新关闭
        [self.tableView.mj_header endRefreshing];
        //更新列表
        [self.tableView reloadData];
        //检查是否需要增加源
        if ([SMFeedStore defaultFeeds].count > self.feeds.count) {
            self.feeds = [SMFeedStore defaultFeeds];
            [self fetchAllFeeds];
        }
        //缓存未缓存的页面
        [self cacheFeedItems];
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(SMFeedModel *feedModel) {
        //抓完一个
        @strongify(self);
        self.tableView.tableHeaderView = self.tbHeaderView;
        //显示抓取状态
        self.fetchingCount += 1;
        self.tbHeaderLabel.text = [NSString stringWithFormat:@"正在获取%@...(%lu/%lu)",feedModel.title,(unsigned long)self.fetchingCount,(unsigned long)self.feeds.count];
        feedModel.isSync = YES;
        [self.tableView reloadData];
    }];
}

- (void)cacheFeedItems {
    if (![SMNetManager isWifi]) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return;
    }
    
    [[[[[SMDB shareInstance] selectAllUnCachedFeedItems] subscribeOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault]] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSMutableArray *x) {
        NSMutableArray *urls = [NSMutableArray array];
        if (x.count > 0) {
            self.needCacheCount = x.count;
            for (SMFeedItemModel *aModel in x) {
                [urls addObject:aModel.des];
            }
        }
//        [[STMURLCache create:^(STMURLCacheMk *mk) {
//            mk.whiteUserAgent(@"gcdfetchfeed").diskCapacity(1000 * 1024 * 1024);
//        }] preloadByWebViewWithHtmls:[NSArray arrayWithArray:urls]].delegate = self;
        //标准都要缓存
        [[[SMDB shareInstance] markAllFeedItemAsCached] subscribeNext:^(id x) {
            //
        }];
        
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rootViewControllerIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    SMRootCell *v = (SMRootCell *)[cell viewWithTag:123432];
    
    if (!v) {
        v = [[SMRootCell alloc] init];
        v.tag = 123432;
        v.delegate = self;
        [cell.contentView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.top.bottom.equalTo(cell.contentView);
        }];
    }
    
    SMFeedModel *model = self.feeds[indexPath.row];
    SMRootCellViewModel *viewModel = [[SMRootCellViewModel alloc] init];
    viewModel.titleString = model.title;
    viewModel.contentString = model.des;
    viewModel.iconUrl = model.imageUrl;
    viewModel.isSync = model.isSync;
    viewModel.highlightString = [NSString stringWithFormat:@"%lu",(unsigned long)model.unReadCount];
    viewModel.feedModel = model;
    [v updateWithViewModel:viewModel];
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [SMStyle colorPaperLight];
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *tbFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        _tableView.tableFooterView = tbFooterView;
        
        //下拉刷新
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self fetchAllFeeds];
        }];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)_tableView.mj_header;
        header.lastUpdatedTimeLabel.hidden = YES;
        [header.arrowView setImage:[UIImage imageNamed:@""]];
        header.stateLabel.font = [SMStyle fontSmall];
        header.stateLabel.textColor = [SMStyle colorPaperGray];
        [header setTitle:@"下拉更新数据" forState:MJRefreshStateIdle];
        [header setTitle:@"松开立刻更新" forState:MJRefreshStatePulling];
        [header setTitle:@"更新数据..." forState:MJRefreshStateRefreshing];
        
    }
    return _tableView;
}

@end
