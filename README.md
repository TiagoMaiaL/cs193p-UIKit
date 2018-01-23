# CS193P-assignments
The solutions for each assignment presented in Stanford's "developing iOS 11 apps with swift" course.

## Concentration:

1. Get the Concentration game working as demonstrated in lectures 1 and 2. Type in all the code. Do not copy/paste from anywhere.
2. Add more cards to the game.
3. Add a “New Game” button to your UI which ends the current game in progress and begins a brand new game.
4. Currently the cards in the Model are not randomized (that’s why matching cards end up always in the same place in our UI). Shuffle the cards in Concentration’s init() method.
5. Give your game the concept of a “theme”. A theme determines the set of emoji from which cards are chosen. All emoji in a given theme are related by that theme. See the Hints for example themes. Your game should have at least 6 different themes and should choose a random theme each time a new game starts.
6. Your architecture must make it possible to add a new theme in a single line of code.
7. Add a game score label to your UI. Score the game by giving 2 points for every match and penalizing 1 point for every previously seen card that is involved in a mismatch.
8. Tracking the flip count almost certainly does not belong in your Controller in a proper MVC architecture. Fix that.
9. All new UI you add should be nicely laid out and look good in portrait mode on an iPhone X.

## Set:

1. Implement a game of solo (i.e. one player) Set.
2. Have room on the screen for at least 24 Set cards. All cards are always face up in Set.
3. Deal 12 cards only to start. They can appear anywhere on screen (i.e. they don’t have to be aligned at the top or bottom or anything; they can be scattered to start if you want), but should not overlap.
4. You will also need a “Deal 3 More Cards” button (as per the rules of Set).
5. Allow the user to select cards to try to match as a Set by touching on the cards. It is up to you how you want to show “selection” in your UI. See Hints below for some ideas. Also support “deselection” (but when only 1 or 2 (not 3) cards are currently selected).
6. After 3 cards have been selected, you must indicate whether those 3 cards are a match or a mismatch (per Set rules). You can do this with coloration or however you choose, but it should be clear to the user whether the 3 cards they selected match or not.
7. When any card is chosen and there are already 3 non-matching Set cards selected, deselect those 3 non-matching cards and then select the chosen card.
8. As per the rules of Set, when any card is chosen and there are already 3 matching Set cards selected, replace those 3 matching Set cards with new ones from the deck of 81 Set cards (again, see Set rules for what’s in a Set deck). If the deck is empty then matched cards can’t be replaced, but they should be hidden in the UI. If the card that was chosen was one of the 3 matching cards, then no card should be selected (since the selected card was either replaced or is no longer visible in the UI).
9. When the Deal 3 More Cards button is pressed either a) replace the selected cards if they are a match or b) add 3 cards to the game.
10. The Deal 3 More Cards button should be disabled if there are a) no more cards in the Set deck or b) no more room in the UI to fit 3 more cards (note that there is always room for 3 more cards if the 3 currently-selected cards are a match since you replace them).
11. Instead of drawing the Set cards in the classic form (we’ll do that next week), we’ll use these three characters ▲ ● ■ and use attributes in NSAttributedString to draw them appropriately (i.e. colors and shading). That way your cards can just be UIButtons. See the Hints for some suggestions for how to show the various Set cards.
12. Use a method that takes a closure as an argument as a meaningful part of your solution. You cannot use one that was shown in lecture.
13. Use an enum as a meaningful part of your solution.
14. Add a sensible extension to some data structure as a meaningful part of your solution. You cannot use one that was shown in lecture.
15. Your UI should be nicely laid out and look good (at least in portrait mode, preferably in landscape as well, though not required) on any iPhone 7 or later device. This means you’ll need to do some simple Autolayout with stack views.
16. Like you did for Concentration, you must have a New Game button and show the Score in the UI. It is up to you how you want to score your Set game. For example, you could give 3 points for a match and -5 for a mismatch and maybe even -1 for a deselection. Perhaps fewer points are scored depending on how many cards are on the table (i.e. how many times Deal 3 More Cards has been touched). Whatever you think best evaluates how well the player is playing.

