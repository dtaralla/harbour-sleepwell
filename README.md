SleepWell!
=================
[This is a SailfishOS application.]
SleepWell is a basic media player, able to import your existings playlists. But it does more than that: you can configure presets with a playout duration and also set a volume fading interval.
Just run SleepWell when you are tired, select your favorite peaceful playlist and listen to it - SleepWell will automatically decrease the device volume as you fall asleep.
But that is still not all: you are also able to configure your presets to shutdown (or silence) your smartphone when the playout duration has elapsed, to guarantee a good rest.

### Features
* The app will import the playlists located under Music/playlists at each launch, overwriting playlists previous version to enforce up to date content.
* PLS and M3U formats supported
* HTTP content supported (you can use playlists containing a webradio for instance)
* Ability to program device shutdown when playout duration has elapsed (a remorse timer will be visible to cancel)
* Same thing but instead the action is silencing the device and exiting app
* Landscape mode supported
* French language supported

### Known issues
* QMediaPlayer volume still has an erratic behaviour. Put the starting volume setting at 0 for your presets and manually set the device volume when you hit the play button to ensure proper functionning.
* If a volume fade out duration is set, your device will end up with a volume of 0. Thus, do not forget to reset your device volume to your needs after use.
* The Media app stores its playlists in a non-standard PLS format. The app will try (and normally succeed) to fix these before importing. If for some reasons some playlists could not be loaded, they won't be available for your presets. Comment on SleepWell Harbour page if you have any trouble with this!
* Deleting presets from their popup menus should be done one after the other, when no other preset delete remorse timer is running. Else, the preset list does not refresh correctly.
* Some graphical artifacts can appear on the progress circles before starting a preset, because this Sailfish component is still experimental.

### Building
1. Download the source code
2. Open harbour-sleepwell.pro in Sailfish SDK IDE
3. To run on emulator, select the i486 target and press the run button
4. To build for the device, select the armv7hl target and deploy all, the rpm packages will be in the RPMS folder

### FAQ
For information about how to use the app, see "Help" in the pulley menu of its first page.

## LICENSE
Feel free to reuse anything you want from this code. All I want is a little mention somewhere of my name if you copy-pasted a big amount of this code "as it" :-) More info about the MIT license here below.

***

The MIT License (MIT)

Copyright (c) 2014 David Taralla

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
