-module (bk_trees).
-export ([init/1, insert/2, search/2, search/3, size/1]).

init(Word) ->
    {1, Word, dict:new()}.

%
% { "apple", dict{
%   2: { "ape", dict{} },
%   3: { "apes", dict{} }
%     }}
% }
insert(Word, {Size, NodeWord, NodeChildren}) ->
    Dist = levenshtein:distance(Word, NodeWord),
    case dict:is_key(Dist, NodeChildren) of
        true ->
            NewTree = dict:fetch(Dist, NodeChildren),
            {Size+1, NodeWord, dict:store(Dist, insert(Word, NewTree), NodeChildren)};
        false ->
            {Size+1, NodeWord, dict:store(Dist, {1, Word, dict:new()}, NodeChildren)}
    end.

search(Word, Tree) ->
    search(Word, Tree, 1, []).

search(Word, Tree, Depth) ->
    search(Word, Tree, Depth, []).

search(Word, {_, NodeWord, NodeChildren}, Depth, Found) ->
    Dist = levenshtein:distance(Word, NodeWord),
    MaxDepth = Dist+Depth,
    MinDepth = Dist-Depth,
    SubtreeSearch =
        fun(ChildDist, Child, Acc) when ChildDist >= MinDepth, ChildDist =< MaxDepth ->
                search(Word, Child, Depth, Acc);
           (_,_,Acc) ->
                Acc
        end,
    SubtreeRes = dict:fold(SubtreeSearch, Found, NodeChildren),
    case Depth >= Dist of
        true ->
            [{Dist, NodeWord} | SubtreeRes];
        false ->
            SubtreeRes
    end.

size({Size, _, _}) ->
    Size.
    
