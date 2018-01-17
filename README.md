# CS193P-assignments
The solutions for each assignment presented in Stanford's "developing iOS 11 apps with swift" course.

Concentration:

1. Get the Concentration game working as demonstrated in lectures 1 and 2. Type in all the code. Do not copy/paste from anywhere.
2. Add more cards to the game.
3. Add a “New Game” button to your UI which ends the current game in progress and begins a brand new game.
4. Currently the cards in the Model are not randomized (that’s why matching cards end up always in the same place in our UI). Shuffle the cards in Concentration’s init() method.
5. Give your game the concept of a “theme”. A theme determines the set of emoji from which cards are chosen. All emoji in a given theme are related by that theme. See the Hints for example themes. Your game should have at least 6 different themes and should choose a random theme each time a new game starts.
6. Your architecture must make it possible to add a new theme in a single line of code.
7. Add a game score label to your UI. Score the game by giving 2 points for every match and penalizing 1 point for every previously seen card that is involved in a mismatch.
8. Tracking the flip count almost certainly does not belong in your Controller in a proper MVC architecture. Fix that.
9. All new UI you add should be nicely laid out and look good in portrait mode on an iPhone X.
