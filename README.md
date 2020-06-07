# Best-Backtester-In-The-Game
I'm trying to create the best backtester in the game. I think it might be harder than it seems but I just made something basic for now until I get smarter.

Lets walk through it!


### Test_Strat.m
_____________________________________________________________________________________________________________________________
Our main function is called 'test_strat' this function contains all the logic needed to run a backtest with other functions adding supplementary functionality.
You can call test_strat from your working directory the function has the following format:
#### [Equity_Curve, Statistics] = test_strat(Stock, BuySell_Vector, Fraction, TimeFrame, Init_Kapital, Plot)

#### INPUTS:
* ####Stock - the time series/asset you are doing your backtest on, I just use stock because thats the name of the structure I use
2000 you would write the date formated as '1-Jan-2000'
* BuySell_Vector - an array of the same length ast 'Stock' but holds just {1,-1,0} where 1 means to buy the asset at the specified index, -1 means sell it, and 0 means don't take a position. How you define this vector defines your logic for your strategy. Here is a suggested format for allocating to it:

![Screen Shot 2020-06-07 at 1 26 02 AM](https://user-images.githubusercontent.com/29047827/83961100-f68bbf80-a85d-11ea-82f4-737f8c50ca60.png)

* Fraction - is the fraction of your total *(imaginary)* money you want to bet on each trade, so for example 0.05 would be 5% of your total Kapital
* Init_Kapital - is the initial amount of kapital you have to start with during the backtest
* Plot - plot is a flag for plotting, set it equal to 1 if you want a plot output to be generated and 0 if you don't want one.


