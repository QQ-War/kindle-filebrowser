## 使用方法
开始以下步骤前需确保你的Kindle已经成功越狱，并安装了KUAL插件。
1. 在[发布页面](https://github.com/guo-yong-zhi/kindle-filebrowser/releases)下载插件压缩包（如 `Source code (zip)` ），解压后得到一个文件夹（可重命名），将其拷贝到Kindle根目录下的extensions目录中。
2. 插件安装完成后，在Kindle上打开KUAL，可以在菜单中找到【File Browser】，可进行如下操作：
    * 【Start】启动免登录的WEB服务  
    * 【Start (Auth)】启动带登录验证的WEB服务（默认用户名密码均为：admin）  
    * 【Start (root path)】启动访问根目录的WEB服务（需手动`mntroot rw`和`mntroot ro`）  
    * 【Kill】终止后台的WEB服务
    * 【Update binary file】更新二进制文件 
    * 【Reset】删除包含配置信息的数据文件filebrowser.db。谨慎点击  

3. 服务启动时如果WiFi处于关闭状态，WiFi会被自动打开并在服务关闭后恢复原状。
4. 服务启动后，Kindle界面的顶部会显示IP地址，请在同一局域网下使用浏览器访问此地址来管理Kindle里的文件。
5. 服务启动后Kindle会保持屏幕常亮且不会休眠。
6. 关闭服务有3种方法：按电源键、手动关闭WiFi（即进入飞行模式）或点击【Kill】。部分设备上电源键可能无效。
7. 服务关闭后，Kindle会恢复到可以正常熄屏休眠的状态，电源键也会恢复其本来功能。
8. 如果有IP显示残留则意味着服务未正常退出，设备此时可能仍处在屏幕常亮不休眠的状态，请尝试通过点击【Kill】或重启设备来解决。相反，IP显示消失了则意味着服务已经完全关闭，不会有后台任务耗电。
9. 如果看不到IP及其它提示，或者它们显示的位置不合适，可以在电脑上修改文件`COL.txt`中的数字，例如从`10`改到`20`可以让显示更靠右。

## KOReader 插件使用方法
本仓库内已提供一个 KOReader 插件包装，可在 KOReader 内直接启动/停止 File Browser。

### 需要拷贝的文件
将 `filebrowser.koplugin` 目录复制到 KOReader 的 `plugins` 目录，例如：
```
/mnt/us/koreader/plugins/filebrowser.koplugin
```

**如果你使用 MRPI 的 extensions 版本（推荐）**  
插件目录内只包含两个文件：
- `filebrowser.koplugin/_meta.lua`
- `filebrowser.koplugin/main.lua`

不需要复制 `filebrowser` 二进制或任何 `.sh` 脚本。

### 插件菜单
在 KOReader 主菜单中会出现 **File Browser**，包含：
- Start
- Start (Auth)
- Start (root path)
- Show Status
- Kill
- Update binary file
- Reset

### 复用 MRPI 的 extensions 目录（必选）
如果你已经在 `/mnt/us/extensions/` 中安装了 MRPI 版插件，可在 KOReader 菜单里设置目录名：
- 进入 **File Browser** → **MRPI dir: ...**
- 输入目录名（例如 `kindle-filebrowser`）
- 插件将执行 `/mnt/us/extensions/<目录名>` 下的脚本

若留空，会回退使用 KOReader 插件自身自带的二进制与脚本。
（本仓库已移除自带二进制，因此请务必配置 MRPI 目录名）

## 其它说明
* 提供核心功能的二进制文件`extensions/filebrowser/filebrowser`来自 https://github.com/filebrowser/filebrowser ，使用linux-armv7版本的release  
* 有任何问题或建议欢迎提issue
* 书伴网站有详细说明及更多修改版本：https://bookfere.com/post/823.html
## 我的更多Kindle插件
* [**kindle-filebrowser**](https://github.com/guo-yong-zhi/kindle-filebrowser) 网页文件管理器 
* [**MailPush**](https://github.com/guo-yong-zhi/MailPush) 使用第三方邮箱推送文件
* [**BlockKindleOTA**](https://github.com/guo-yong-zhi/BlockKindleOTA) 阻止Kindle升级
* [**KOSSH**](https://github.com/guo-yong-zhi/KOSSH) WiFi连接的轻量ssh服务器
* [**ShuffleSS**](https://github.com/guo-yong-zhi/ShuffleSS) 打乱锁屏图片顺序
