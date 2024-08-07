# SwiftUI loop video player Video from URL or Local file

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FThe-Igor%2Fswiftui-loop-videoplayer%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/The-Igor/swiftui-loop-videoplayer)

## Disclaimer on Video Sources like YouTube
Please note that using videos from URLs requires ensuring that you have the right to use and stream these videos. Videos hosted on platforms like YouTube cannot be used directly due to restrictions in their terms of service. Always ensure the video URL is compliant with copyright laws and platform policies. 
  
![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/remote_video_player_swiftui.gif)

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/swiftui.gif)
  

## API Specifications

| Property/Method                       | Type                          | Description                                                            |
|---------------------------------------|-------------------------------|------------------------------------------------------------------------|
| `settings`                            | `Settings`                    | A struct containing configuration settings for the video player.       |
| `command`                             | `Binding<PlaybackCommand>`    | A binding to control playback actions (play, pause, or seek).          |
| `init(fileName:ext:gravity:eColor:eFontSize:command:)` | Constructor       | Initializes the player with specific video parameters and playback command binding. |
| `init(_ settings: () -> Settings, command:)` | Constructor | Initializes the player with a declarative settings block and playback command binding. |

### Playback Commands

| Command                     | Description                                                                                                                                          |
|-----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `play`                      | Command to play the video.                                                                                                                            |
| `pause`                     | Command to pause the video.                                                                                                                           |
| `seek(to: Double)`          | Command to seek to a specific time in the video. The parameter is the target position in seconds. Note: Errors such as seeking out of bounds are not currently handled and will be silently ignored. Potential errors include: <br> - `.seekTimeOutOfBounds` <br> - `.invalidDuration` <br> - `.playerOrCurrentItemNil`. Future versions may introduce error handling for these cases. |

### Initializer Parameters Settings

| Name | Description | Default |
| --- | --- |  --- |
| **SourceName** | The URL or local filename of the video. If a valid URL (http or https) is provided, the video will be streamed from the URL. If not a URL, the system will check if a video with the given name exists in the local bundle. The local name provided can either include an extension or be without one. The system first checks if the local name contains an extension. If the local name includes an extension, it extracts this extension and uses it as the default. If the local name does not contain an extension, the system assigns a default extension of .mp4 The default file extension can be set up via Ext param. | - |
| **Ext** | File extension for the video, used when loading from local resources. This is optional when a URL is provided and the URL ends with the video file extension. | "mp4" |
| **Gravity** | How the video content should be resized to fit the player's bounds. | .resizeAspect |
| **EColor** | Error message text color. | .red |
| **EFontSize** | Size of the error text. | 17.0 |

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/macos.gif)
 
## Remote Video URLs

### Video Source Compatibility

| Video Source | Possible to Use | Comments |
| --- | --- | --- |
| YouTube | No | Violates YouTube's policy as it doesn't allow direct video streaming outside its platform. |
| Direct MP4 URLs | Yes | Directly accessible MP4 URLs can be used if they are hosted on servers that permit CORS. |
| HLS Streams | Yes | HLS streams are supported and can be used for live streaming purposes. |

## Playback Commands

The package now supports playback commands, allowing you to control video playback actions such as play, pause, and seek to specific times. This provides greater flexibility and control over video playback.


![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/commands.gif)
  
## Practical idea for the package
You can introduce video hints about some functionality into the app, for example how to add positions to favorites. Put loop video hint into background or open as popup.

## [ SwiftUI loop video player package](https://github.com/The-Igor/swiftui-loop-videoplayer)

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/swiftui_video_hint.gif)

![The concept](https://github.com/The-Igor/swiftui-loop-videoplayer-example/blob/main/swiftui-loop-videoplayer-example/img/tip_video_swiftui.gif)

## Documentation(API)
- You need to have Xcode 13 installed in order to have access to Documentation Compiler (DocC)

- Go to Product > Build Documentation or **⌃⇧⌘ D**

### XCode 15 beta note (iOS 17)

- At the current time XCode 15 is in beta and in the console you might see message "A structure that defines how a layer displays a player’s visual content within the layer’s bounds" I found on Stack-overflow that many came across this message and at the time it is treated like XCode 15 beta bug
