-module(tree_test).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").

setup() ->
    ok = application:start(bktree),
    ?assertNot(undefined == whereis(bktree_sup)).

init_test() ->
    Word = "Apple",
    ?assertEqual({1, Word, dict:new()}, bk_trees:init(Word)).

insert_test() ->
    Root = bk_trees:init("apple"),
    Tree = bk_trees:insert("ape", Root),
    Children = dict:from_list([{2, {1, "ape", dict:new()}}]),
    ?assertEqual({2, "apple", Children}, Tree).

search_test() ->
    T = bk_trees:init("brewery"),
    T2 = bk_trees:insert("stone", T),
    T3 = bk_trees:insert("anchorsteam", T2),
    T4 = bk_trees:insert("delirium", T3),
    ?assertEqual(bk_trees:search("deli", T4, 4), [{4, "delirium"}]),
    ?assertEqual(bk_trees:search("deli", T4, 5), [{5, "stone"},{4, "delirium"}]).

size_test() ->
    T = bk_trees:init("brewery"),
    T2 = bk_trees:insert("stone", T),
    T3 = bk_trees:insert("anchorsteam", T2),
    T4 = bk_trees:insert("delirium", T3),
    ?assertEqual(4, bk_trees:size(T4)).
