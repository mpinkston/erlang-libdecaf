%% -*- mode: erlang; tab-width: 4; indent-tabs-mode: 1; st-rulers: [70] -*-
%% vim: ts=4 sw=4 ft=erlang noet
%%%-------------------------------------------------------------------
%%% @author Andrew Bennett <andrew@pixid.com>
%%% @copyright 2015-2016, Andrew Bennett
%%% @doc
%%%
%%% @end
%%% Created :  29 Feb 2016 by Andrew Bennett <andrew@pixid.com>
%%%-------------------------------------------------------------------
-module(libdecaf_curve448).

%% API
% EdDSA
-export([eddsa_keypair/0]).
-export([eddsa_keypair/1]).
-export([eddsa_secret_to_pk/1]).
-export([eddsa_sk_to_pk/1]).
-export([eddsa_sk_to_secret/1]).
% Ed448
-export([ed448_sign/2]).
-export([ed448_sign/3]).
-export([ed448_verify/3]).
-export([ed448_verify/4]).
% Ed448ph
-export([ed448ph_sign/2]).
-export([ed448ph_sign/3]).
-export([ed448ph_verify/3]).
-export([ed448ph_verify/4]).
% X448
-export([curve448/1]).
-export([curve448/2]).
-export([x448/1]).
-export([x448/2]).
-export([x448_keypair/0]).
-export([x448_keypair/1]).

%% Macro
% EdDSA
-define(EdDSA_SECRET_BYTES,  57).
-define(EdDSA_PK_BYTES,      57).
-define(EdDSA_SK_BYTES,     114).
-define(EdDSA_SIGN_BYTES,   114).
% EdDSA Short
-define(EdDSA_SHORT_SECRET_BYTES, 32).
-define(EdDSA_SHORT_SK_BYTES,     89).
% X448
-define(X448_PRIVATE_BYTES,  56).
-define(X448_PUBLIC_BYTES,   56).

%%%===================================================================
%%% API functions
%%%===================================================================

% EdDSA

eddsa_keypair() ->
	eddsa_keypair(crypto:strong_rand_bytes(?EdDSA_SECRET_BYTES)).

eddsa_keypair(Secret)
		when is_binary(Secret)
		andalso (byte_size(Secret) =:= ?EdDSA_SECRET_BYTES orelse byte_size(Secret) =:= ?EdDSA_SHORT_SECRET_BYTES) ->
	PK = eddsa_secret_to_pk(Secret),
	{PK, << Secret/binary, PK/binary >>}.

eddsa_secret_to_pk(Secret)
		when is_binary(Secret)
		andalso (byte_size(Secret) =:= ?EdDSA_SECRET_BYTES orelse byte_size(Secret) =:= ?EdDSA_SHORT_SECRET_BYTES) ->
	libdecaf:decaf_448_eddsa_derive_public_key(Secret).

eddsa_sk_to_pk(<< _:?EdDSA_SECRET_BYTES/binary, PK:?EdDSA_PK_BYTES/binary >>) ->
	PK;
eddsa_sk_to_pk(<< _:?EdDSA_SHORT_SECRET_BYTES/binary, PK:?EdDSA_PK_BYTES/binary >>) ->
	PK.

eddsa_sk_to_secret(<< Secret:?EdDSA_SECRET_BYTES/binary, _:?EdDSA_PK_BYTES/binary >>) ->
	Secret;
eddsa_sk_to_secret(<< Secret:?EdDSA_SHORT_SECRET_BYTES/binary, _:?EdDSA_PK_BYTES/binary >>) ->
	Secret.

% Ed448

ed448_sign(M, << SK:?EdDSA_SK_BYTES/binary >>) when is_binary(M) ->
	ed448_sign(M, SK, <<>>);
ed448_sign(M, << SK:?EdDSA_SHORT_SK_BYTES/binary >>) when is_binary(M) ->
	ed448_sign(M, SK, <<>>).

ed448_sign(M, << Secret:?EdDSA_SECRET_BYTES/binary, PK:?EdDSA_PK_BYTES/binary >>, C)
		when is_binary(M)
		andalso is_binary(C)
		andalso byte_size(C) =< 255 ->
	libdecaf:decaf_448_eddsa_sign(Secret, PK, M, 0, C);
ed448_sign(M, << Secret:?EdDSA_SHORT_SECRET_BYTES/binary, PK:?EdDSA_PK_BYTES/binary >>, C)
		when is_binary(M)
		andalso is_binary(C)
		andalso byte_size(C) =< 255 ->
	libdecaf:decaf_448_eddsa_sign(Secret, PK, M, 0, C).

ed448_verify(<< Sig:?EdDSA_SIGN_BYTES/binary >>, M, << PK:?EdDSA_PK_BYTES/binary >>) when is_binary(M) ->
	ed448_verify(Sig, M, PK, <<>>).

ed448_verify(<< Sig:?EdDSA_SIGN_BYTES/binary >>, M, << PK:?EdDSA_PK_BYTES/binary >>, C)
		when is_binary(M)
		andalso is_binary(C)
		andalso byte_size(C) =< 255 ->
	libdecaf:decaf_448_eddsa_verify(Sig, PK, M, 0, C).

% Ed448ph

ed448ph_sign(M, << SK:?EdDSA_SK_BYTES/binary >>) when is_binary(M) ->
	ed448ph_sign(M, SK, <<>>);
ed448ph_sign(M, << SK:?EdDSA_SHORT_SK_BYTES/binary >>) when is_binary(M) ->
	ed448ph_sign(M, SK, <<>>).

ed448ph_sign(M, << Secret:?EdDSA_SECRET_BYTES/binary, PK:?EdDSA_PK_BYTES/binary >>, C)
		when is_binary(M)
		andalso is_binary(C)
		andalso byte_size(C) =< 255 ->
	libdecaf:decaf_448_eddsa_sign(Secret, PK, M, 1, C);
ed448ph_sign(M, << Secret:?EdDSA_SHORT_SECRET_BYTES/binary, PK:?EdDSA_PK_BYTES/binary >>, C)
		when is_binary(M)
		andalso is_binary(C)
		andalso byte_size(C) =< 255 ->
	libdecaf:decaf_448_eddsa_sign(Secret, PK, M, 1, C).

ed448ph_verify(<< Sig:?EdDSA_SIGN_BYTES/binary >>, M, << PK:?EdDSA_PK_BYTES/binary >>) when is_binary(M) ->
	ed448ph_verify(Sig, M, PK, <<>>).

ed448ph_verify(<< Sig:?EdDSA_SIGN_BYTES/binary >>, M, << PK:?EdDSA_PK_BYTES/binary >>, C)
		when is_binary(M)
		andalso is_binary(C)
		andalso byte_size(C) =< 255 ->
	libdecaf:decaf_448_eddsa_verify(Sig, PK, M, 1, C).

% X448

curve448(Scalar) when is_integer(Scalar) ->
	curve448(<< Scalar:?X448_PRIVATE_BYTES/unsigned-little-integer-unit:8 >>);
curve448(Scalar)
		when is_binary(Scalar)
		andalso byte_size(Scalar) =:= ?X448_PRIVATE_BYTES ->
	<< U:?X448_PUBLIC_BYTES/unsigned-little-integer-unit:8 >> = libdecaf:decaf_x448_base_scalarmul(Scalar),
	U.

curve448(Scalar, Base) when is_integer(Scalar) ->
	curve448(<< Scalar:?X448_PRIVATE_BYTES/unsigned-little-integer-unit:8 >>, Base);
curve448(Scalar, Base) when is_integer(Base) ->
	curve448(Scalar, << Base:?X448_PUBLIC_BYTES/unsigned-little-integer-unit:8 >>);
curve448(Scalar, Base)
		when is_binary(Scalar)
		andalso byte_size(Scalar) =:= ?X448_PRIVATE_BYTES
		andalso is_binary(Base)
		andalso byte_size(Base) =:= ?X448_PUBLIC_BYTES ->
	<< U:?X448_PUBLIC_BYTES/unsigned-little-integer-unit:8 >> = libdecaf:decaf_x448_direct_scalarmul(Base, Scalar),
	U.

x448(K)
		when is_binary(K)
		andalso byte_size(K) =:= ?X448_PRIVATE_BYTES ->
	libdecaf:decaf_x448_base_scalarmul(K).

x448(K, U)
		when is_binary(K)
		andalso byte_size(K) =:= ?X448_PRIVATE_BYTES
		andalso is_binary(U)
		andalso byte_size(U) =:= ?X448_PUBLIC_BYTES ->
	libdecaf:decaf_x448_direct_scalarmul(U, K).

x448_keypair() ->
	x448_keypair(crypto:strong_rand_bytes(?X448_PRIVATE_BYTES)).

x448_keypair(Secret)
		when is_binary(Secret)
		andalso byte_size(Secret) =:= ?X448_PRIVATE_BYTES ->
	{x448(Secret), Secret}.

%%%-------------------------------------------------------------------
%%% Internal functions
%%%-------------------------------------------------------------------