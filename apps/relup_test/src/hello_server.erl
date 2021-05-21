%%%-------------------------------------------------------------------
%%% @author
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(hello_server).

-behaviour(gen_server).

-vsn("1.1.1").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(hello_server_state, {name}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    erlang:send_after(10000, self(), hello),
    {ok, #hello_server_state{name = "w"}}.

handle_call(_Request, _From, State = #hello_server_state{}) ->
    {reply, ok, State}.

handle_cast(_Request, State = #hello_server_state{}) ->
    {noreply, State}.

handle_info(hello, State = #hello_server_state{name = Name}) ->
    io:format("Hello : ~p~n", [{?MODULE, ?LINE, "hello", Name}]),
    erlang:send_after(10000, self(), hello),
    {noreply, State};
handle_info(_Info, State = #hello_server_state{}) ->
    {noreply, State}.

terminate(_Reason, _State = #hello_server_state{}) ->
    ok.

code_change(_OldVsn, State = #hello_server_state{}, _Extra) ->
    io:format("Code_Change : ~p~n", [{?MODULE, ?LINE, _OldVsn, _Extra}]),
    {ok, State#hello_server_state{name = "world"}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
