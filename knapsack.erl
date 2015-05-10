-module(knapsack).
-export([init/0, fit/3]).

-record(with_fit, {knapsack_config, fit}).

init() ->
    % TODO load this from somewhere
    Knapsack = 200,
    % Items are { weight, price }
    % For this particular knapsack the cost should be at least 227.
    Items = [ { 51, 60 }, { 5, 2 }, { 12, 14 }, { 2, 1 } ],
    Population = [ random:uniform(Knapsack div Iw) || { Iw, _ } <- Items ],
    step(Knapsack, Items, Population, 0).

step(Knapsack, Items, Population, PrevVal) ->
    PopSize = length(Population),
    PreCrossPop = select(Population, PopSize div 2, Knapsack, Items),
    CrossPop = cross(PreCrossPop),
    MutPop = mutate(CrossPop, 0.1),
    SelPop = select(MutPop, PopSize, Knapsack, Items).

% TODO implement
cross(Population) ->
    Population.

mutate(Population, MutationProbability) ->
    Population.

select(Population, Size, Knapsack, Items) ->
    PopWithFit = population_with_fit(Population),
    TotalFit = sum([ I#with_fit.fit || I <- PopWithFit ]).
    SelectedPopWithFit = select(partial, [], PopWithFit, Size, TotalFit),
    [ element(1, X) || X <- SelectedPopWithFit ].

select(partial, Selected, NotSelected, Size, TotalFit) ->
    Rn = random:uniform(TotalFit),
    {El, Rest} = probability_select(Rn, NotSelected),
    select([ El | Selected], Rest, Size - 1, TotalFit - El#with_fit.fit)

fit(KnapsackConfig, Knapsack, Items) ->
    fit(KnapsackConfig, Knapsack, Items, 0, 0).

fit(_, Knapsack, _, _, Weight) when Weight > Knapsack ->
    0.1;
fit([], _, _, Value, _) ->
    Value;
fit([Kc|Kcs], Knapsack, [I|Is], Value, Weight) ->
    {IWeight, IValue} = I,
    NewWeight = Weight + Kc * IWeight,
    NewValue = Value + Kc * IValue,
    fit(Kcs, Knapsack, Is, NewValue, NewWeight).

population_with_fit(Population, Knapsack, Items) ->
    [ with_fit:new(X, fit(X, Knapsack, Items)) || X <- Population ].

probability_select(Rn, [X | _]) when X#with_fit.fit <= Rn ->
    X;
probability_select(Rn, [X, Xs]) ->
    probability_select(Rn - X#with_fit.fit, Xs).
