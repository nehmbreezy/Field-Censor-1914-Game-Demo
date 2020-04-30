# Field Censor 1914: Game Demo #

### Introduction ###
In the summer of my second year at college (2015) I tried to create a video game. I was inspired by [*Papers, Please*](https://en.wikipedia.org/wiki/Papers%2C_Please), an unusual indie game in which you play as an immigration officer at a fictional Soviet-Union like border. *Papers, Please* created ethical dilemmas and a complex narrative through what seemed like a very limited interface – you sat at a desk and stamped passports to let people in or not. It made immigration bureaucracy into a dystopian adventure.

I wanted to create similar dynamics – exciting narrative, ethical dilemmas, and subtle world-building – in Field Censor 1914. Having recently taken a class on the First World War, I was fascinated by the futile attrition of trench warfare on the Western Front – in stark contrast to the jingoistic propaganda that had escalated the conflict. When I found out that British officers had to censor the letters their troops were sending back home, I spotted an opportunity for a new type of game-story.

### Gameplay ###
In Field Censor 1914, you play as a junior officer in the trenches of the Western Front. The primary gameplay consists of reading through and censoring letters. Accurate censorship rewards you with points, inaccurate censorship deducts them; gradually, you're given more censorship instructions to follow. The storyline emerges organically from these game mechanics, as you learn more about the innermost lives of your soldiers.

### Creation Process ###
Creating the game required a mixture of project management, coding, creative writing, and graphics. I took an agile approach to the design -- iterating through loops of design, prototyping, and evaluation. To program the game, I used [HaxeFlixel](https://haxeflixel.com), a free 2D game engine powered by [Haxe](https://haxe.org),  an "open-source, high-level strictly-typed programming language with a fast-optimising cross-compiler." I didn't have formal training, so the code I produced was fairly amateurish, but it was sufficient for multiple prototypes.

### Features ###
The prototype includes some exciting features. Some highlights include:

**Dragging and dropping letters to the outbox using the "Move" tool.**

![Drag and Drop Example](https://github.com/nehmbreezy/Field-Censor-1914-Game-Demo/blob/master/gifs/Click%20and%20Drag1.gif "Drag and Drop Example")


**Censoring specific words on the letters using the "Pencil" tool.**

(This involved turning each word on the letter into a separate object with a unique hitbox and keeping track of which words needed to be censored, which words were optional, and which words the player actually censored.)
![Censor Example 1](https://github.com/nehmbreezy/Field-Censor-1914-Game-Demo/blob/master/gifs/Censor%20part%201.gif "Censor Example 1")


**Submitting censored letters and receiving feedback on accuracy.**

![Feedback](https://github.com/nehmbreezy/Field-Censor-1914-Game-Demo/blob/master/gifs/Censor%20part%202%20feedback.gif "Feedback 1")

*Including details on what you missed.*
<img src="https://github.com/nehmbreezy/Field-Censor-1914-Game-Demo/blob/master/gifs/censor%20feedback.JPG" alt="feedback negative" width="800"/>


**Progressing to a new day -- with new gameplay rules.**

![Progress](https://github.com/nehmbreezy/Field-Censor-1914-Game-Demo/blob/master/gifs/Day%202%20to%20day%203%20transition.gif "New Day")


**Easily checking the censorship rules with the "Rulebook" tool.**

![Rulebook](https://github.com/nehmbreezy/Field-Censor-1914-Game-Demo/blob/master/gifs/Rule%20book.gif "Rulebook")


**Stamping letters with your fancy approval stamp after censoring them.**

(Shoutout to *Papers, Please*!)

![Stamping](https://github.com/nehmbreezy/Field-Censor-1914-Game-Demo/blob/master/gifs/Stamp.gif "Stamping")


### Demo ###
Though I wasn't able to complete the game, I was able to compile a working demo. I'd be happy for anybody else to develop the concept or mechanics further. I have plenty more ideas for where this could go -- both in terms of gameplay and storyline! Do reach out to me.

To try the full demo yourself, download the ["demo.swf"](Link) file in this repository and open it with [Flash Player debugger.](https://www.adobe.com/support/flashplayer/debug_downloads.html)
