-module(knapsack).
-export([init/0, fit/3]).

init() ->
    % TODO load this from somewhere
    Knapsack = 200,
    % Items are { weight, price }
    % For this particular knapsack the cost should be at least 227.
    Items = [ { 51, 60 }, { 5, 2 }, { 12, 14 }, { 2, 1 } ],
    Population = [ random:uniform(Knapsack div Iw) || { Iw, _ } <- Items ],
    step(Knapsack, Items, Population, 0).

step(Knapsack, Items, Population, PrevVal) ->
    CrossPop = cross(Population),
    MutPop = mutate(CrossPop, 0.1),
    SelPop = select(MutPop, Knapsack, Items).

% TODO implement
cross(Population) ->
    Population.

mutate(Population, MutationProbability) ->
    Population.

select(Population, Knapsack, Items) ->
    Population.

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


