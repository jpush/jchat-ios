//
//  HMPhotoSelectViewController.m
//  HMPhotoPickerDemo
//
//  Created by HuminiOS on 15/11/16.
//  Copyright © 2015年 HuminiOS. All rights reserved.
//

#import "JCHATPhotoSelectViewController.h"
#import "ThumbImageCollectionViewCell.h"
#import "JCHATPhotoBrowserViewController.h"
#import "JCHATPhotoModel.h"
#import "JCHATPhotoPickerConstants.h"
#import "AppDelegate.h"
#import "JCHATSelectImgCollectionView.h"
#define kPhotoGridViewFrame CGRectMake(0, 0, screenWidth,screenHeight - 45)
#define kBrowserBtnFrame CGRectMake(13, 10, 35, 16)
#define kSendBtnFrame CGRectMake(screenWidth - 45, 10, 35, 16)

@interface JCHATPhotoSelectViewController (){
  PHCachingImageManager *imageManager;
  NSMutableDictionary *selectedPhotoDic;// 已经选中的图片
  NSMutableArray *allPhotoArr;
  __weak IBOutlet JCHATSelectImgCollectionView *photoGridView;
  __weak IBOutlet UIButton *browserBtn;
  __weak IBOutlet UILabel *selectedPhotoLabel;
  __weak IBOutlet UIButton *sendBtn;
}



@end

@implementation JCHATPhotoSelectViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationController.navigationBar.translucent = NO;
  selectedPhotoDic = @{}.mutableCopy;
  allPhotoArr = @[].mutableCopy;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(cancel)];
  
  selectedPhotoLabel.layer.masksToBounds = YES;
  selectedPhotoLabel.layer.cornerRadius = selectedPhotoLabel.frame.size.height / 2;
  
  imageManager = [[PHCachingImageManager alloc] init];

  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//  [defaultCenter addObserver:self selector:@selector(didSelectStatusChange:) name:kSelectStatusChange object:nil];
//  [defaultCenter addObserver:self selector:@selector(finshToSelectPhoto:) name:kFinishToSelectPhoto object:nil];
  [self setUpCollectionView];
  
  if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8) {
    [self getAllPhotoWithPhotosFramework];
  } else {
    [self getAllPhotoWithAssert];
  }
}

- (void)cancel{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getAllPhotoWithPhotosFramework {
  if (_allFetchResult == nil) {
    _allFetchResult = [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)_photoCollection options:nil];
  }
  if (_photoCollection.localIdentifier == nil) {
    self.title = @"相机胶卷";
  } else {
    self.title = _photoCollection.localizedTitle;
  }
  
  PHFetchResult *allPhotoResult = _allFetchResult;
  for (int index = 0; index < [allPhotoResult count]; index ++) {
    PHAsset *asset = allPhotoResult[index];
    JCHATPhotoModel *model = [[JCHATPhotoModel alloc] init];
    [model setDataWithPhotoAsset:asset imageManager:imageManager];
    [allPhotoArr addObject:model];
  }
  [photoGridView reloadData];
  [self performSelector:@selector(scrollPhotoGridToBottom) withObject:nil afterDelay:0.1];
}

- (void)scrollPhotoGridToBottom {
  [photoGridView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:allPhotoArr.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)getAllPhotoWithAssert {
        [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
          if (group != nil) {
            
            //设置过滤对象
            ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:filter];
            
            //通过文件夹枚举遍历所有的相片ALAsset对象，有多少照片，则调用多少次block
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
              if (result != nil) {
                //将result对象存储到数组中
                JCHATPhotoModel *model = [[JCHATPhotoModel alloc] init];
                [model setDatawithAsset:result];
                [allPhotoArr addObject:model];
              }
            }];
            // 将所有获取的 照片模型 交给manager统一管理
            [photoGridView reloadData];
            [photoGridView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:allPhotoArr.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
          }
        } failureBlock:^(NSError *error) {
          UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"请允许访问相册,方可使用此功能!\n您可以在\"设置->隐私->照片\"中启用",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:NSLocalizedString(@"设置",nil), nil];
          [alertView show];
        }];
}
- (void)setUpCollectionView {
  photoGridView.minimumZoomScale = 0;
  photoGridView.contentOffset = CGPointMake(0, 64);
  [photoGridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
  [photoGridView registerNib:[UINib nibWithNibName:@"ThumbImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbImageCollectionViewCell"];
  [self.view addSubview:photoGridView];
  UICollectionViewFlowLayout *collectLayout = (UICollectionViewFlowLayout *)photoGridView.collectionViewLayout;
  NSLog(@"translucent %@",[UINavigationBar appearance].translucent?@"yes":@"no");
  if ([UINavigationBar appearance].translucent == YES) {
    collectLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 64);
  }
  
  photoGridView.backgroundColor = [UIColor whiteColor];
  photoGridView.delegate = self;
  photoGridView.dataSource = self;
  [photoGridView reloadData];
}

- (IBAction)clickToBrowserSelectedPhotos:(id)sender {
  JCHATPhotoBrowserViewController *photoBrowserVC = [[JCHATPhotoBrowserViewController alloc] init];
  photoBrowserVC.photoCollection = _photoCollection;
  photoBrowserVC.imageManager = imageManager;
  photoBrowserVC.allFetchResult = _allFetchResult;
  photoBrowserVC.photoDelegate = _photoDelegate;
  photoBrowserVC.selectVCDelegate = self;
  photoBrowserVC.allPhotoArr = [NSMutableArray arrayWithArray:[selectedPhotoDic allValues]];
  NSIndexPath *browserIndex= [NSIndexPath indexPathForItem:0 inSection:0];
  photoBrowserVC.currentIndex = browserIndex;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
}

- (IBAction)sendSelectedPhotos:(id)sender {
  [self finshToSelectPhoto:nil];
}

- (void)finshToSelectPhoto:(JCHATPhotoModel *)model {
//  if (notification != nil) {
//    if (selectedPhotoDic.count == 0) {
//      HMPhotoModel *model = notification.object;
//      if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8) {//宏
//        [selectedPhotoDic setObject:model forKey:model.photoAsset];
//      } else {
//        [selectedPhotoDic setObject:model forKey:model.imgURL];
//      }
//    }
//  }
  if (selectedPhotoDic.count == 0) {
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8) {//宏
      [selectedPhotoDic setObject:model forKey:model.photoAsset];
    } else {
      [selectedPhotoDic setObject:model forKey:model.imgURL];
    }
  }
  if ([_photoDelegate respondsToSelector:@selector(JCHATPhotoPickerViewController:selectedPhotoArray:)]){
    __block NSMutableArray *selectedImageArr = @[].mutableCopy;
    
    for (NSString *key in selectedPhotoDic) {
      JCHATPhotoModel *photoModel = selectedPhotoDic[key];
      
      if (photoModel.largeImage == nil) {
        NSLog(@"fail to get large image");
        break;
      }
      
      [selectedImageArr addObject:photoModel.largeImage];
    }
    [_photoDelegate JCHATPhotoPickerViewController:self selectedPhotoArray:selectedImageArr];
  }
  [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didSelectStatusChange:(JCHATPhotoModel *)model {

  if ([[[UIDevice currentDevice]systemVersion] floatValue]>= 8) {
    if (selectedPhotoDic[model.photoAsset] == nil) {
      if (selectedPhotoDic.count > 8) {
        [MBProgressHUD showMessage:@"最多选择9张图片" view:self.view];
        return;
      }
      [selectedPhotoDic setObject:model forKey:model.photoAsset];
    } else {
      [selectedPhotoDic removeObjectForKey:model.photoAsset];
    }
  } else {
    if (selectedPhotoDic[model.asset] == nil) {
      if (selectedPhotoDic.count > 8) {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        [MBProgressHUD showMessage:@"最多选择9张图片" view:appDelegate.window];
        return;
      }
      [selectedPhotoDic setObject:model forKey:model.imgURL];
    } else {
      [selectedPhotoDic removeObjectForKey:model.imgURL];
    }
  }

  if ([selectedPhotoDic count] > 0) {
    browserBtn.enabled = YES;
    selectedPhotoLabel.hidden = NO;
    selectedPhotoLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[selectedPhotoDic count]];
    sendBtn.enabled = YES;
  } else {
    browserBtn.enabled = NO;
    selectedPhotoLabel.hidden = YES;
    sendBtn.enabled = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO];
  [photoGridView reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return allPhotoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  return CGSizeMake(80, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"ThumbImageCollectionViewCell";
  ThumbImageCollectionViewCell *cell = (ThumbImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  [cell setDataWithModel:allPhotoArr[indexPath.item] withDelegate:self];
  return cell;
}

- (void)collectionView:(UICollectionView * _Nonnull)collectionView
didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
  JCHATPhotoBrowserViewController *photoBrowserVC = [[JCHATPhotoBrowserViewController alloc] init];
  photoBrowserVC.photoCollection = _photoCollection;
  photoBrowserVC.imageManager = imageManager;
  photoBrowserVC.allFetchResult = _allFetchResult;
  photoBrowserVC.allPhotoArr = allPhotoArr;
  photoBrowserVC.photoDelegate = _photoDelegate;
  photoBrowserVC.currentIndex = indexPath;
  photoBrowserVC.selectVCDelegate = self;
  [self.navigationController pushViewController:photoBrowserVC animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
@end
