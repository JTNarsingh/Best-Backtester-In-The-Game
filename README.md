# Best-Backtester-In-The-Game
I'm trying to create the best backtester in the game. I think it might be harder than it seems but I just made something basic for now until I get smarter.

Lets walk through it!


### Test_Strat.m
_____________________________________________________________________________________________________________________________
Our main function is called 'test_strat' this function contains all the logic needed to run a backtest with other functions adding supplementary functionality.
You can call test_strat from your working directory the function has the following format:
#### [Equity_Curve, Statistics] = test_strat(Stock, BuySell_Vector, Fraction, TimeFrame, Init_Kapital, Plot)


