#! /bin/sh

#############################
## 执行此脚本来把待发布的 source 打包，放到 dist/ 下
## 打包结果可用于： 1. 提供给内部测试； 2. 覆盖 github 上的项目
#############################

echo "Action - publish JChat sources"

############# 检查脚本执行目录

if [ ! -d JChat ] || [ ! -d JChat.xcodeproj ] || [ ! -f JMESSAGE_VERSION ]; then
    echo "This script is not executed in JChat project root dir. "
    exit 1
fi

############# 删除开发痕迹

# bundle-id / team 设置， 需要从 proj 配置文件里删除

projFile="JChat.xcodeproj/project.pbxproj"

if [ ! -f $projFile ]; then
    echo "iOS project file does not exist. "
    exit 1
fi

findTeam=`grep -o 'DevelopmentTeam = [0-9a-zA-Z]*;' $projFile`
echo "Found team config item - $findTeam"

if [ ! "$findTeam" ]; then
    echo "Unexpected: not found DevelopmentTeam config item."
    exit 1
fi

sed -i "" "/${findTeam}/d" $projFile
findTeam=`grep -o 'DevelopmentTeam = [0-9a-zA-Z]*;' $projFile`

if [ "$findTeam" ]; then
    echo "Unexpected: delete DevelopmentTeam failed. "
    exit 1
fi

echo "DevelopmentTeam config item is deleted. "

# bundleId 在配置文件里有 2 项

findBundleId=`grep -c -o 'PRODUCT_BUNDLE_IDENTIFIER = [.0-9a-zA-Z]*;' $projFile`
echo "Found bundleId config item - $findBundleId"

if [ ! ${findBundleId:=0} -gt 0 ]; then
    echo "Unexpected: not found PRODUCT_BUNDLE_IDENTIFIER config item."
    exit 1
fi


sed -i "" "/PRODUCT_BUNDLE_IDENTIFIER = [.0-9a-zA-Z]*;/d" $projFile

findBundleId=`grep -c -o 'PRODUCT_BUNDLE_IDENTIFIER = [.0-9a-zA-Z]*;' $projFile`

if [ ${findBundleId:=0} -gt 0 ]; then
    echo "Unexpected: delete PRODUCT_BUNDLE_IDENTIFIER failed."
    exit 1
fi

echo "PRODUCT_BUNDLE_IDENTIFIER config item is deleted."



############# 打包

# 可选参数：是否要打包 JMessage.framework

if [ -d dist ]; then
    rm -rf dist
fi
mkdir dist

currentDir=`pwd`
infoDir=$currentDir/JChat/Info
jchatVersion=`defaults read $infoDir CFBundleShortVersionString`
jchatBuildId=`defaults read $infoDir CFBundleVersion`

if [ ! $jchatVersion ] || [ ! $jchatBuildId ]; then
    echo "Unexpected: version or buildId not found."
    exit 1
fi


zipFile="$TMPDIR/jchat-source-${jchatVersion}b${jchatBuildId}.zip"
zip -r $zipFile ./JMESSAGE_VERSION
zip -r $zipFile ./LICENSE
zip -r $zipFile ./README.md
zip -r $zipFile ./Podfile
zip -r $zipFile ./Podfile.lock
zip -r $zipFile ./Pods
zip -r $zipFile ./check_jmessage_version.sh
zip -r $zipFile ./JChat
zip -r $zipFile ./JChat.xcodeproj
zip -r $zipFile ./JChat.xcworkspace

mv $zipFile dist/


