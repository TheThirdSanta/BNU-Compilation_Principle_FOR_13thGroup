# **Linux下使用git的方法**

使用git主要是为了方便管理以及在虚拟机下上传文件的问题，由于linux系统本身以终端处理为主的特点，所以我觉得使用git来进行管理十分重要且合适，下面介绍的是linux下使用git并绑定GitHub仓库的办法，同时涉及文件的上传和下载删除操作。

第一次使用GitHub一定有一些烦恼，只要你成功创建了账号就算成功

当你找到本仓库(repository)的时候，请确保你同时打开虚拟机或者云主机并在Linux下打开终端(terminal)

## **一、Linux下Git的配置**

首先在终端中运行下面的指令安装git

```bash
sudo apt-get install git
```

当安装完成后运行

```bash
git version
```

验证是否安装成功

![image-20220919160912088](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919160912088.png)

之后需要进行配置用户名和用户邮件

```bash
git config --global user.name "用户名"
git config --global user.email "用户邮件"
```



用户名就是你自己在GitHub里面的名字，比如我是”TheThirdSanta“，用户邮件就是注册GitHub是用的邮件地址

![image-20220919161032181](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919161032181.png)

输入后运行

```bash
git config --list
```

验证是否配置成功

![image-20220919161312861](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919161312861.png)

这里的**color.ui = auto**指的是终端默认的彩色模式打开，你要是觉得花里胡哨你不喜欢，可以自行关闭

之后进行最重要的一步，**配置git的私钥和公钥**，如果没有这一步你的git没有办法和你的GitHub上的仓库联动，也无法从GitHub上下载或者上传任何文件到仓库中！！！

首先运行下面命令生成密钥

```bash
ssh-keygen -t rsa -C "用户邮箱"
```

之后的界面会有多个*Enter*，你只需要无脑按Enter就可以了，之后便是将生成的密钥文件添加到GitHub中去

运行

```bash
cd ~/.ssh/
ls
```

查看是否包含一个名为**id_rsa.pub**的文件，如果存在那么进行下一步，如果不存在找我！

之后点击GitHub网站，点击个人的**setting**，选择选项**SSH and GPG keys**，新建一个SSH key

![img](https://img-blog.csdn.net/20181004232747159?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hjSnNKcUpTU00=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

命名你的SSH Key，同时在linux中打开**id_rsa.pub**文件

```bash
cat id_rsa.pub
```

将打开后的所有内容复制到GitHub中Key的框框里面，之后点击添加即可

![img](https://img-blog.csdn.net/20181004233321485?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0hjSnNKcUpTU00=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

回到linux中，验证Git是否已经成功配置

```bash
ssh git@github.com
```

出现下面的情况就说明安装配置成功

![image-20220919162337553](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919162337553.png)

## **二、将库添加到本地并上传或者删除文件**

在仓库中点击绿色的Code按钮，将Clone下面的地址复制下来，之后在终端中运行（好吧我已经帮你复制好了）

```bash
git clone https://github.com/TheThirdSanta/BNU-Compilation_Principle_FOR_13thGroup.git
```

这时会将库中文件下载到当前的目录，默认为桌面上，你可以在桌面上看到一个以库名命名的文件

![image-20220919162945338](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919162945338.png)

可以在打开该文件夹查看里面的内容，和GitHub仓库中的内容以及分级一模一样，这样就成功将文件下载到本地

之后写完文件之后（可以是在当前的目录下，也可以是在其他目录下），记得一定要在终端中将文件移动到指定的位置，并运行上传一个指定的文件

```bash
git add 文件名
```

或者上传改目录下的所有文件

```bash
git add .
```

上传之后这时git会将这些文件暂时上传至缓冲区内，等待你下一步的确认上传操作

所有等待上传的文件均已添加到缓冲区后，运行

```bash
git commit -m "这里是注释"
```

注释内主要写你对仓库的修改

之后再运行

```bash
git push origin main
```

这里会将所有打好注释的缓冲区内容上传至GitHub的仓库中，这里会要求你填写GitHub的账户名称和密码，但是你填写密码后他会告诉你

![image-20220919164325407](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919164325407.png)

这是因为GitHub从2021.8.13之后因为安全原因不再支持本地密码输入管理远程仓库了，这时你需要填写个人的token来代替密码，配置个人token查看下面的部分，之后进行这一步操作都需要将密码替换为token

删除文件的操作也十分简单，运行下面命令即可

```bash
git rm FileName
git rm -r FolderName
```

上面一条命令是删除单个文件，下面一条命令是删除整个文件夹

运行完之后一样需要运行commit命令和push命令

## **三、配置个人token**

在设置里面选择最下面的**Developer settings**,选择**Personal access tokens(PAT)**,选择新建一个token

![image-20220919164730548](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919164730548.png)

**Note**中填写你关于这个token的用途，下面的**Expiration**选择Custom，设置一个尽可能久远的日期

下面的Select scopes中将前四个大类勾上：repo workflow write... delete...

点击下面的生成按钮，之后会生成一个token

**！！！注意！！！这里生成的token网页一旦关闭，则无法再看到，请一定要在这里选择复制token内容并妥善保存**

![image-20220919165149016](C:/Users/78793/AppData/Roaming/Typora/typora-user-images/image-20220919165149016.png)

之后再进行push操作的时候输入改token作为密码即可

至此初步的环境配置全部完成，希望接下来的一个学期内我们合作愉快😊
