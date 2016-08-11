
# Code share

This is a quick exploration into Elm hosted at:
[https://hankyates.github.io/code-share/](https://hankyates.github.io/code-share/).
I just made a quick little code sharing site that pulls from githubs gist api.

## My Impressions on Elm
###Pros
- No runtime errors.
- Not alot of boilerplate.
- Strong types.

###Cons
- Not newbie friendly at all.
- Docs can be out of date and confusing (Signals, Effects)
- Simple Debugging is difficult.

A big selling point on Elm is 'no runtime errors' and this was true and amazing. If it compiled it worked. The tradeoff is that instead of debugging errors in dev tools, you spent more time figuring out what the compiler error was trying to tell you. The compilers errors are helpful though.  

There wasn't a need for linting either. The types kept you in line and made sure you weren't doing anything silly. I really enjoyed writing signatures for my functions and then figuring out the implementation later. It makes designing nice API's easier.  

Simple debugging was way too difficult. My Json Decoder wasn't working properly, and I had no real way of knowing that was where the problem was, because there is no simple way to `console.error` error messages when they occur. I eventually got it all wired up, but if I were a newbie coming in, I don't think I would have been able to get past this problem. Googling questions and error messages didnt always yield great results either. For figuring out how to Json Decode a JS Object into a List, I found an old blog post using out of date Elm API's. I eventually got what I needed from it, but considerable updates to the blog code needed to be made.

All in all though I really loved working with Elm and I think it's great for lightweight projects! I still think it doesn't quite have the community support or ecosystem to try and bring it in for a major project at work. 
