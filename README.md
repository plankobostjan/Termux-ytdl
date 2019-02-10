# Download videos directly from the YouTube app on Android using Termux

## Boredom proves useful (again)

A week or so ago, I was a bit bored. I didn't really know what to do. This happens quite often, I reckon. But during that initial state of boredom I decided to search the Web for interesting things I can do using Termux on Android. And that's when the fun started. Just a quick Google search and I've came across a [Reddit post](https://www.reddit.com/r/linux/comments/66fh4f/what_do_you_use_termux_on_android_for/) that proved itself insanely valuable. I've found a way to download videos to my phone directly from the YouTube app.

## Following the Reddit post

As I've said before I had nothing in particular to do. Therefore I've decided to try what Reddit post has suggested.

Now come and join me on this epic journey. ;-)

If you haven't already, please install Termux from [Google Play Store](https://play.google.com/store/apps/details?id=com.termux).

Alternatively (preferably, if you ask me), download Termux from [F-Droid](https://f-droid.org/).

>Hint:
Termux is free in Google Play Store as well in F-Droid. But Termux:API, which you will need if you want to follow the second part of the tutorial (my customizations) costs 2.09 EUR in Google Play Store. However, it's free if you download it from F-Droid (you can still donate to the developer if you wish).

First, we update and upgrade Termux apps:

```bash
apt update && apt upgrade
```

Giving Termux access to phone's filesystem via *~/storage/shared* is a piece of cake:

```bash
termux-setup-storage
```

After that we need to install some packages:

```bash
#install python
pkg install python 

#install youtube-dl
pip install youtube-dl
```

I was already thinking about downloading not only video but also audio files (more on that later), therefore I've created folders in which I'll be saving downloaded video (and audio) files. We will do the same, because, why not:

```bash
mkdir -p /data/data/com.termux/files/home/storage/shared/Youtube/{audio,video}
```

In order to tell youtube-dl how and where to download files, we create a configuration file *~/.config/youtube-dl/config*:

```bash
#open new file using nano
nano ~/.config/youtube-dl/config
```

In that file, we put the following:

```bash
--no-mtime
-o /data/data/com.termux/files/home/storage/shared/Youtube/video/%(title)s.%(ext)s
-f "best[height<=1080]"
```
The *[height<=1080]* tells youtube-dl to download the best quality version up to 480px in width. You can change to 240, 360, 720 or 1080, etc. to suit your needs/bandwidth restrictions.

We then save the file with Ctrl+O ("Volume-down"+O) and close nano with Ctrl+X ("Vol-down"+X).

In order to be able to "open" YouTube videos using Termux, we need to create *termux-url-opener* file in *~/bin*:

```bash
mkdir ~/bin
cd ~/bin
nano termux-url-opener
```

In that file, we place:

```bash
youtube-dl $1
```

Save the file with Ctrl+O ("Volume-down"+O) and close nano with Ctrl+X ("Vol-down"+X).

And viola, we are done!

Now when you want to download a YouTube video from within the Youtube app, click the *Share* under the video, then choose *Termux*. Termux will open and the download will start. Downloaded videos will be available in the *Youtube* folder in the root of your internal storage.

## Making the experience even better

I know youtube-dl. I use it often enough on my computer. And I know that it is capable of downloading just the audio from any YouTube video. Therefore the idea of having the ability to choose which format to download seemed appealing to me. And I was 100% sure I can bring that idea to life. And I did it. I've made myself a script which opens a popup window where I choose the format. The chosen format is then downloaded into the appropriate folder on my phone.

Now come and follow me. I'm sure you won't regret it. :-)

First, install *Termux:API* either from [Google Play Store](https://play.google.com/store/apps/details?id=com.termux.api) (2.09 EUR) or from [F-Droid](https://f-droid.org/en/packages/com.termux.api/) (free).

Then open *Termux* app and run:

```bash
pkg install termux-api
```

Now we need to make a script which will ask us to choose the format and then download whatever format we choose. To get the user's choice, we will use a Termux:API implementation called *termux-dialog*.

Now go ahead and copy&paste the code below into *~/bin/ytdl.sh* in Termux. Or you can download the script from my [GitHub repository](https://github.com/plankobostjan/Termux-ytdl/blob/master/ytdl.sh) and save it into *~/bin/ytdl.sh* in Termux.

```bash
#!/bin/bash

CHOICE="$(termux-dialog radio -v "Video only,Audio only,Video and audio" -t "Select format:" | grep index | tr -d -c 0-9 &)"

if [ "$CHOICE" = 0 ]
then
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/video/%(title)s.%(ext)s" $1
elif [ "$CHOICE" = 1 ]
then
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/audio/%(title)s.%(ext)s" -f 140 $1 
else
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/video/%(title)s.%(ext)s" $1
    youtube-dl -o "/data/data/com.termux/files/home/storage/shared/Youtube/audio/%(title)s.%(ext)s" -f 140 $1
fi
```

Now we need to make this script executable. In Termux type:


```bash
chmod +x ~/bin/ytdl.sh
```

In order for youtube-dl to work properly we need to edit its configuration file:

```bash
#open youtube-dl config file with nano
nano ~/.config/youtube-dl/config
```

Now replace the current content of the configuration file with the following:

```bash
--no-mtime
-f "best[height<=1080]"
```
Again, the *[height<=1080]* tells youtube-dl to download the best quality version up to 480px in width. You can change to 240, 360, 720 or 1080, etc. to suit your needs/bandwidth restrictions.

The only thing to do now it to change the *termux-url-opener* file. GO ahead and open that file with nano:

```bash
nano ~/bin/termux-url-opener
```

Replace the current content of the file with the following:

```bash
bash /data/data/com.termux/files/home/bin/ytdl.sh $1
```
