# Best-Backtester-In-The-Game
I'm trying to create the best backtester in the game. I think it might be harder than it seems but I just made something basic for now until I get smarter.

Lets walk through it!


### Test_Strat.m
____________________________________________________________________________________________________________________________
Our main function is called 'test_strat' this function contains all the logic needed to run a backtest with other functions adding supplementary calculations and tools.
You can call test_strat from your working directory the function has the following format:
#### [Equity_Curve, Statistics] = test_strat(Stock, BuySell_Vector, Fraction, TimeFrame, Init_Kapital, Plot)

#### INPUTS:
* Stock - the time series/asset you are doing your backtest on, I just use stock because thats the name of the structure I use
* BuySell_Vector - is an array with the same length ast 'Stock' but holds just values of {1,-1,0}, where '1' means to buy the asset at the specified index, '-1' means sell it, and '0' means don't take a position. How you define this vector defines your logic for your strategy. Here is a suggested format for allocating logic to it:

![Screen Shot 2020-06-07 at 1 26 02 AM](https://user-images.githubusercontent.com/29047827/83961100-f68bbf80-a85d-11ea-82f4-737f8c50ca60.png)

* Fraction - is the fraction of your total *(imaginary)* money you want to bet on each trade, so for example 0.05 would be 5% of your total Kapital
* Init_Kapital - is the initial amount of kapital you have to start with during the backtest
* Plot - plot is a flag for plotting, set it equal to '1' if you want a plot output to be generated and '0' if you don't want one
____________________________________________________________________________________________________________________________
#### OUTPUTS:
* Equity_Curve - the equity curve is an array that tracks how much the value of your portfolio fluctuates over time
* Statistics - statistics is a structure that holds a bunch of useful statistics based on the strategy used in the back test like Total Return, Sharpe Ratio, Annualized Returns, Win Rate (Probability of Making Money), Max Draw Down, and Max Draw Down Time (in days).
____________________________________________________________________________________________________________________________
### Plot:

If you chose to plot by setting the plot flag to '1' you will be greeted by this beautiful  subplot:

![Screen Shot 2020-06-07 at 1 04 53 AM](https://user-images.githubusercontent.com/29047827/83960816-153c8700-a85b-11ea-8d8c-90f2c082e16b.png)

The top subplot is of your equity curve and shows the value of your portfolio over time, the bottome subplot is of your drawdowns in your portfolio. Draw downs are defined as any decrease in the portfolios value from its most recent maximum, meaning that if your portolio increases from 100 to 150 then decreases to 125 you would have a 16.67% drawdown.

You will also get a bunch of statistics printed out to your command window like this:

![Screen Shot 2020-06-07 at 1 05 16 AM](https://user-images.githubusercontent.com/29047827/83960818-1bcafe80-a85b-11ea-85a0-cd99d2b1e792.png)






