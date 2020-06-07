function [Equity_Curve, Statistics] = test_strat(Stock, BuySell_Vector, Fraction, TimeFrame, Init_Kapital, Plot)
% Function outputs an Equity Curve for a given policy/strategy & statistics
% releated to the performance of the strategy. Takes as an input an object
% called Stock with attributes DateString (dates as string) and Close
% (closing price of the asset). BuySell_Vector is the policy/strategy where
% a value of '1' means going long, '-1' means going short, & '0' means
% taking no position at all. Fraction is the faction of the kapital used in
% a trade. TimeFrame is the holding period in days. Init_Kapital is the
% initial capital the strategy starts with. Plot is a flag '0' or '1' if an
% equity curve along with a max drawdown plot should be created.

% Setting variables equal to structure attributes for easier coding
Date_Series = Stock.DateString;
Time_Series = Stock.Close;
Ticker = Stock.Ticker;

% If the length of the Time Series is equal to BuySell Vector execute the
% back test
if (length(Time_Series) == length(BuySell_Vector))
    % Creating Equity Curve vector which will plot Profit/Loss over time
    Equity_Curve = zeros(length(BuySell_Vector)+1,1);
    Equity_Curve(1) = Init_Kapital;
    
    % Creating a vector to calculate our Roi
    Percent_Change = zeros(length(BuySell_Vector)-TimeFrame,1);
    
    % Allocating to the Percent Change Vector if a position is specified by
    % the BuySell Vector
    for i = 1:length(BuySell_Vector)-TimeFrame  
        
        if (BuySell_Vector(i) == 1) % Long - calculate percent change being long over the time frame
            Percent_Change(i:i+TimeFrame-1) = (Time_Series(i+(1:TimeFrame))-Time_Series(i))/Time_Series(i);
            
        elseif (BuySell_Vector(i) == -1) % Short - calculate the percent change being short over the timeframe
            Percent_Change(i:i+TimeFrame-1) = (Time_Series(i)-Time_Series(i+(1:TimeFrame)))/Time_Series(i);        
        
        elseif ~(BuySell_Vector(i) == 0 || BuySell_Vector(i) == 1 || BuySell_Vector(i) == -1) 
            % Printing an error if the BuySell Vector does not specify
            % long/short/no position
            error('BuySell Vector contains values other than 1,-1, or 0') 
        end
    end
    
    % Updating the Equity Curve Using the Percent Change Vector %
    for i = 1:length(Percent_Change)-1
        Equity_Curve(i+1) = Equity_Curve(i) + (Equity_Curve(i)*Fraction*Percent_Change(i));
    end
     
    % Reformatting the Equity_Curve & Date Vectors for plotting purposes
    Equity_Curve = Equity_Curve(Equity_Curve ~= 0); 
    Diff = length(Date_Series)-length(Equity_Curve);
    
    % Deleting a portion of the date series if the difference is greater
    % than zero 
    if (Diff > 0)
        Date_Series(end-Diff+1:end) = [];
    end
    
    % Plotting the Equity Curve & Max Draw Downs if we get a plot flag 
    if (Plot == 1)       
        % Calling the maxdrawdown function to calculate draw downs for the
        % given equity curve
        DrawDown_Vector = maxdrawdown(Equity_Curve);
         
        % Declaring a figure name and creating a subplot for the equity
        % curve and the max draw downs
        figure('Name',strcat(Ticker,' Back Test'))
        
        % Equity Curve subplot
        subplot(2,1,1)
        title('Equity Curve')
        plot(Date_Series, Equity_Curve, 'b')
        grid on
        
        % Max Draw Down subplot 
        subplot(2,1,2)
        title('Max Draw Down')
        plot(Date_Series, DrawDown_Vector, 'r')
        hold on
        
        % Drawing horizontal line at max drawdown
        Max_DrawDown = horizontal_line(DrawDown_Vector ,min(DrawDown_Vector)); 
        plot(Date_Series, Max_DrawDown,'g--')
        hold off
        
        % Updating limit of graph
        ylim([min(DrawDown_Vector)*1.5,0])
        grid on
    end
    
    % Function creates a vector 
    Count_DrawDown = count_drawdown(DrawDown_Vector);
    
    % Calculating and adding to the statistics object
    % Standard is setting risk free rate to  2% 
    Statistics = stats(Date_Series, Equity_Curve, Percent_Change, Init_Kapital, 0.02);
    Statistics.MaxDrawDown = min(DrawDown_Vector);
    Statistics.MaxDrawDownTime = max(Count_DrawDown);
    
    % Printing out my nice statistics %
    fprintf('\nStatistics:\n\nAnnualized Returns: %.2f\nTotal Returns: %.2f\nSharpe Ratio: %.2f\nWin Rate: %.2f\nMax Draw Down: %.2f\nMax Time in Draw Down: %.2f\n', ...
        Statistics.Annualized_Return, Statistics.Total_Return, Statistics.Sharpe_Ratio, Statistics.Probability, ...
        Statistics.MaxDrawDown, Statistics.MaxDrawDownTime)
end


% Printing errors if BuySell Vector is not the same size as the time series
if (length(Time_Series) > length(BuySell_Vector))
        error('Time Series vector is longer than BuySell Vector !!!')
end

if (length(Time_Series) < length(BuySell_Vector))
        error('Buy Sell Vector is longer than Time Series vector !!!')
end

end

%% ************************ Functions used in test_strat function **************************************
%% Function that calculates the max draw downs of the Equity Curve over time 

function DrawDown_Vector = maxdrawdown(Equity_Curve)   
    % Initializing the Draw Down Vector & a variable Max 
    DrawDown_Vector = zeros(length(Equity_Curve),1);
    Max = Equity_Curve(1);
    
    % For loop allocates to Draw Down Vector by checking if the Equity
    % Curve is less than the value set for Max if not it updates Max to the
    % current value of the Equity Curve
    for i = 2:length(Equity_Curve)
        if (Max > Equity_Curve(i))
            DrawDown_Vector(i) = -(Max - Equity_Curve(i))/Equity_Curve(i);
        else
            Max = Equity_Curve(i);
        end 
    end
end

%% Function that counts the amount of time in days the equity curve is in a draw down

function Count_DrawDown = count_drawdown(DrawDown)
    Count = 0;
    Count_DrawDown = zeros(length(DrawDown),1);

    for i = 2:length(DrawDown)
        if (DrawDown(i) < 0)
            Count = Count + 1;
            Count_DrawDown(i) = Count;
        
        elseif (DrawDown(i-1) < 0 && DrawDown(i) == 0)
            Count = 0;
            Count_DrawDown(i) = Count;
        end
    end
end

%% Function that returns statistics based on the equity curve

function Statistics = stats(Date_Series, Equity_Curve, Percent_Change, Init_Kapital, Rf_Rate)
    
    % Calculating Annual Change in Assets Under Management (AUM)
    Years = year(Date_Series);
    Annual_AUM = [];
    
    for i = 1:length(Years)-1
        if (Years(i) < Years(i+1))
            Annual_AUM = [Annual_AUM; Equity_Curve(i)];
        end
    end
    
    Annual_AUM = [Init_Kapital; Annual_AUM];
    
    % Calculating Annual Returns
    Annual_Returns = diff(Annual_AUM)./Annual_AUM(1:end-1);
    
    % Calculating Sharpe Ratio
    Mean_Return = mean(Annual_Returns);
    Std_Return = std(Annual_Returns);
    Sharpe_Ratio = (Mean_Return-Rf_Rate)/Std_Return;
    
    % Calculating Annualized Return %
    Total_Return = (Equity_Curve(end)-Equity_Curve(1))/Equity_Curve(1);
    Total_Time = datenum(Date_Series(end)-Date_Series(1))/365;
    Annualized_Return = nthroot(1+Total_Return, Total_Time)-1;    
    
    % Calculating probability of a profitable trade
    Trade_Returns = Percent_Change(Percent_Change ~= 0);
    Probability = sum(Trade_Returns > 0)/length(Trade_Returns);
     
    % Allocating variable to statistics object
    Statistics.Annual_Returns = Annual_Returns;
    Statistics.Annualized_Return = Annualized_Return;
    Statistics.Total_Return = Total_Return;
    Statistics.Sharpe_Ratio = Sharpe_Ratio;
    Statistics.Probability = Probability;
end

%% Function that creates a horizontal line of the same length of a given vector for a given value

function Line = horizontal_line(Vector, Value)
    Line = Value*ones(length(Vector),1);
end
