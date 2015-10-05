//
//  ViewController.m
//  TableViewWithParallaxHeader
//
//  Created by Ian Andoni Magarzo Fernández on 28/9/15.
//  Copyright (c) 2015 Ian Andoni Magarzo Fernández. All rights reserved.
//

#import "ViewController.h"
#import "StyleConstants.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>{
}

@property (weak, nonatomic) IBOutlet UIScrollView *canvasScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctBottomHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctBottomMediaView;
@property (weak, nonatomic) IBOutlet UIScrollView *mediaScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *images;

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctHeightTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctTopSpaceTableView;

@property (nonatomic)   CGFloat maxNegativeContentOffset;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadStyles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadContent{
    //_headerTitle.text = @"Ian Magarzo Fernández"; //2 lines
    _headerTitle.text = @"Ian Magarzo"; //1 line
    _headerTitle.textAlignment = NSTextAlignmentCenter;
    [self loadMediaScrollView];
}

#pragma mark - Styles

- (void)loadStyles{
    //[_headerTitle sizeToFit];
    
    _maxNegativeContentOffset = kHeaderMaxHeigth - kHeaderMinHeigth - (_headerTitle.frame.size.height - 44);
    
    _ctHeightTableView.constant = self.view.frame.size.height - (kHeaderMaxHeigth - _maxNegativeContentOffset);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - TableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    return cell;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1) { //TableViewScrollView
        
        //HEADER HEIGHT
        if (_table.contentOffset.y < 0){
            _ctBottomHeaderView.constant = _table.contentOffset.y;
            _ctBottomMediaView.constant = _table.contentOffset.y*2.0;
        
        }else{
            _ctBottomHeaderView.constant = _ctBottomMediaView.constant = 0;
        }
        
        //TABLE
        if (_table.contentOffset.y < _maxNegativeContentOffset) {
            _canvasScrollView.contentOffset = _table.contentOffset;
        }else if(_table.contentOffset.y > _maxNegativeContentOffset && _table.contentSize.height > (_table.frame.size.height + _table.contentOffset.y)){
            
            _canvasScrollView.contentOffset = CGPointMake(0.0, _maxNegativeContentOffset);
            
        }else if (_table.contentSize.height < (_table.frame.size.height + _table.contentOffset.y)) { //Disable Bottom Bounce
            _table.contentOffset = CGPointMake(0.0, _table.contentSize.height - _table.frame.size.height);
        }
        
    }
    if (scrollView.tag == 2) { //MediaScrollView
        [self updatePageControl];
    }
}


#pragma mark - MediaScrollViewSource

- (void)loadMediaScrollView{
    _images = @[@"image1", @"image2"];
    _pageControl.numberOfPages = _images.count;
    
    for (int p = 0; p < _images.count; p++) {
        CGRect actualFrameInScrollViewCanvas = CGRectMake(self.view.frame.size.width*(float)p, 0.0, self.view.frame.size.width, _mediaScrollView.frame.size.height);
        
        CGRect actualFrameInScrollViewMediaView = CGRectMake(0.0, 0.0, self.view.bounds.size.width, _mediaScrollView.frame.size.height);
        UIView *view = [[UIView alloc] initWithFrame:actualFrameInScrollViewCanvas];
        view.backgroundColor = [UIColor redColor];
        
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:actualFrameInScrollViewMediaView];
        imageView.backgroundColor = [UIColor purpleColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.alpha = 1.9;
        imageView.image = [UIImage imageNamed:[_images objectAtIndex:p]];
        imageView.clipsToBounds = YES;
        [view addSubview:imageView];
        view.clipsToBounds = YES;
        [_mediaScrollView addSubview:view];
    }
    _mediaScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _pageControl.numberOfPages, _mediaScrollView.frame.size.height);
    [self updatePageControl];
}

#pragma mark - MediaScrollViewDelegate

- (void)updatePageControl{
    _pageControl.currentPage = (int)(round(_mediaScrollView.contentOffset.x / _mediaScrollView.frame.size.width));
}

@end
