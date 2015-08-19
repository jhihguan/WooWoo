# WooWoo

This is my first ios application on AppStore. You can download and play it from [here.](https://itunes.apple.com/tw/app/woooo/id978438766?mt=8)

It's a breakdown sharing tool with the ability of showing nearby breakdowns.

I try to use Model-View-VideModel(MVVM) architecture to build this application. But I do not use Dependency Injection to init my ViewModel.

To run this application, you have to install [`Cocoapods`](https://cocoapods.org/), which was a good way to manage awesome libraries, and run `pod install` or `pod update`

After pod install success, open `Wooo.xcworkspace` and find [`Constants.h`](https://github.com/jhihguan/WooWoo/blob/master/Wooo/Constant.h)

Than replace `@""` with your Parse Key and Flurry Key and Run It!
```
static NSString *const PARSE_APPLICATION_ID = @"";
static NSString *const PARSE_CLIENT_KEY = @"";
static NSString *const FLURRY_SESSION_KEY = @"";
```

Now you will see what you want :)


Let me know if you have any questions. I'm still learning!

####You can find me at twitter [@jhihguan](https://twitter.com/jhihguan)