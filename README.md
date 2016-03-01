# libdecaf NIF (EdDSA, Ed25519, Ed25519ph, Ed448, Ed448ph, X25519, X448)

[![Build Status](https://travis-ci.org/potatosalad/erlang-libdecaf.png?branch=master)](https://travis-ci.org/potatosalad/erlang-libdecaf) [![Hex.pm](https://img.shields.io/hexpm/v/libdecaf.svg)](https://hex.pm/packages/libdecaf)

[ed448goldilocks libdecaf](https://sourceforge.net/p/ed448goldilocks) NIF with timeslice reductions for Erlang and Elixir.

*Work In Progress* - not yet ready for production.

## Usage

```erlang
M = <<>>. % Message used below for signing
C = <<"test">>. % Context used below by Ed448 and Ed448ph

%% EdDSA (edwards25519) Key Generation
{PK25519, SK25519} = libdecaf_curve25519:eddsa_keypair().
% {<<211,65,121,173,153,86,193,196,218,254,23,46,4,146,26,
%    124,131,219,63,144,210,48,209,178,189,10,233,246,248,
%    65,158,48>>,
%  <<63,238,247,145,210,20,146,223,78,100,90,126,134,45,223,
%    41,104,231,121,9,5,104,69,122,233,171,44,76,57,171,155,
%    211,211,65,121,173,153,86,193,196,218,254,23,46,4,146,
%    26,124,131,219,63,144,210,48,209,178,189,10,233,246,
%    248,65,158,48>>}

%% Ed25519 Sign
SigEd25519 = libdecaf_curve25519:ed25519_sign(M, SK25519).
% <<206,59,70,86,114,42,116,11,30,183,149,16,90,90,105,162,
%   112,182,99,62,90,20,207,102,102,98,230,18,23,175,212,
%   150,146,27,83,120,107,135,209,56,75,214,152,204,24,205,
%   48,128,129,191,174,137,11,189,75,14,7,242,3,255,122,176,
%   182,2>>

%% Ed25519 Verify
libdecaf_curve25519:ed25519_verify(SigEd25519, M, PK25519).
% true

%% Ed25519ph Sign
SigEd25519ph = libdecaf_curve25519:ed25519ph_sign(M, SK25519).
% <<34,229,75,109,157,147,185,162,202,43,43,58,115,7,220,
%   142,97,81,244,163,14,61,142,70,69,162,182,175,178,131,
%   83,19,42,70,36,191,81,59,166,185,193,194,184,107,163,
%   239,170,254,84,250,196,111,90,255,216,120,166,233,137,
%   208,32,57,23,12>>

%% Ed25519ph Verify
libdecaf_curve25519:ed25519ph_verify(SigEd25519ph, M, PK25519).
% true

%% EdDSA (edwards448) Key Generation
{PK448, SK448} = libdecaf_curve448:eddsa_keypair().
% {<<241,233,41,181,164,174,226,117,24,66,133,47,149,210,
%    164,224,28,126,128,72,91,188,104,161,195,124,68,135,92,
%    239,242,16,54,103,127,106,169,175,41,108,92,133,176,
%    221,9,217,123,174,85,37,243,51,184,123,208,112,0>>,
%  <<208,201,124,71,171,63,19,141,159,70,248,214,101,209,
%    110,44,221,16,92,150,231,227,56,223,39,52,47,163,35,76,
%    103,204,158,103,184,236,28,255,121,25,147,183,188,212,
%    197,107,37,71,183,104,96,32,107,139,114,245,155,241,
%    233,41,181,164,174,226,117,24,66,133,47,149,210,164,
%    224,28,126,128,72,91,188,104,161,195,124,68,135,92,239,
%    242,16,54,103,127,106,169,175,41,108,92,133,176,221,9,
%    217,123,174,85,37,243,51,184,123,208,112,0>>}

%% Ed448 Sign
SigEd448 = libdecaf_curve448:ed448_sign(M, SK448).
% <<119,207,247,95,201,79,152,97,43,180,45,185,35,106,183,
%   196,49,213,79,187,29,138,177,18,179,169,69,199,186,168,
%   245,4,237,201,28,60,238,248,239,35,24,16,96,225,82,210,
%   43,71,15,26,235,67,34,209,41,34,0,196,180,145,251,47,
%   102,57,80,10,3,131,169,40,130,129,165,20,33,208,230,218,
%   127,231,61,84,146,237,77,239,56,241,73,165,24,89,55,149,
%   175,238,154,238,27,88,206,242,238,5,161,22,157,229,47,
%   171,26,168,6,0>>

%% Ed448 Verify
libdecaf_curve448:ed448_verify(SigEd448, M, PK448).
% true

%% Ed448 Sign with Context
SigEd448C = libdecaf_curve448:ed448_sign(M, SK448, C).
% <<198,30,160,202,201,28,194,205,148,240,61,130,243,165,24,
%   200,41,118,93,214,56,253,177,171,146,176,149,237,247,
%   108,171,59,123,218,127,48,4,191,227,3,193,177,33,211,
%   120,44,104,86,71,202,97,76,109,41,178,54,0,214,106,192,
%   185,186,130,72,187,199,95,189,203,25,173,26,36,89,1,91,
%   220,192,18,141,7,168,190,107,76,243,251,56,248,121,183,
%   193,138,72,130,96,119,44,97,69,224,186,129,29,205,60,
%   242,222,247,123,130,7,54,0>>

%% Ed448 Verify with Context
libdecaf_curve448:ed448_verify(SigEd448C, M, PK448, C).
% true

%% Ed448ph Sign with Context
SigEd448phC = libdecaf_curve448:ed448ph_sign(M, SK448, C).
% <<239,203,149,217,206,16,137,29,96,249,110,60,192,24,210,
%   70,151,212,67,17,176,174,157,59,0,125,174,39,5,68,41,
%   147,182,88,71,83,190,8,131,226,107,255,214,186,40,1,207,
%   19,29,12,20,34,88,170,95,129,0,214,103,171,2,142,1,245,
%   102,206,109,152,21,251,17,100,2,224,182,244,68,34,53,2,
%   249,188,198,31,37,18,54,132,157,126,9,100,100,55,2,31,
%   119,47,228,230,136,130,219,222,2,191,177,150,219,134,32,
%   231,21,0>>

%% Ed448ph Verify with Context
libdecaf_curve448:ed448ph_verify(SigEd448phC, M, PK448, C).
% true

%% X25519 (curve25519) Key Generation
{AlicePK25519, AliceSK25519} = libdecaf_curve25519:x25519_keypair().
% {<<155,64,184,119,41,134,146,219,250,18,4,67,204,130,43,
%    123,254,96,68,174,200,23,238,126,79,238,85,159,186,4,
%    120,75>>,
%  <<32,212,161,45,202,186,28,152,196,19,74,127,44,14,73,
%    165,194,228,179,252,108,220,81,163,201,183,167,144,143,
%    160,212,206>>}
{BobPK25519, BobSK25519} = libdecaf_curve25519:x25519_keypair().
% {<<31,100,69,143,46,85,11,129,240,52,225,219,164,100,9,
%    171,242,98,210,112,8,222,150,66,16,160,143,122,102,188,
%    146,10>>,
%  <<39,232,51,250,201,211,41,191,120,143,42,86,105,150,4,
%    24,169,238,245,77,238,40,179,198,96,157,144,229,162,41,
%    205,77>>}

%% X25519 Shared Secret
SharedSecretX25519 = libdecaf_curve25519:x25519(AliceSK25519, BobPK25519).
% <<83,191,246,24,100,87,227,192,3,237,26,132,143,40,62,213,
%   67,232,33,97,240,8,73,139,64,160,13,107,150,146,246,30>>
SharedSecretX25519 =:= libdecaf_curve25519:x25519(BobSK25519, AlicePK25519).
% true

%% X448 (curve448) Key Generation
{AlicePK448, AliceSK448} = libdecaf_curve448:x448_keypair().
% {<<105,143,129,11,70,98,185,191,191,50,127,193,175,72,161,
%    79,83,138,120,81,31,104,18,241,113,197,243,49,93,92,
%    165,124,198,141,92,186,199,33,67,132,244,217,138,213,
%    64,67,106,63,33,144,227,46,158,169,74,242>>,
%  <<167,49,168,47,44,91,156,96,5,153,110,156,108,175,53,
%    145,63,251,245,180,129,161,206,122,26,197,27,146,248,
%    100,74,167,70,130,43,193,21,169,118,30,80,74,145,200,
%    176,112,94,139,59,250,167,118,103,50,209,53>>}
{BobPK448, BobSK448} = libdecaf_curve448:x448_keypair().
% {<<83,3,128,166,199,125,249,189,28,86,204,99,239,204,162,
%    180,230,199,198,77,55,120,44,169,165,153,238,230,47,
%    255,223,187,18,7,65,152,205,235,76,65,152,93,38,236,
%    177,36,70,199,146,235,67,245,226,142,27,24>>,
%  <<90,248,1,221,137,251,205,121,215,99,121,204,122,92,97,
%    157,88,173,213,171,171,83,64,140,72,156,96,242,230,239,
%    89,242,76,190,148,109,13,145,159,138,105,240,246,86,
%    169,137,144,80,241,224,91,73,108,165,156,31>>}

%% X448 Shared Secret
SharedSecretX448 = libdecaf_curve448:x448(AliceSK448, BobPK448).
% <<114,107,110,164,14,165,169,174,160,230,53,253,116,87,
%   238,193,5,2,210,229,81,43,197,195,128,229,181,13,30,139,
%   203,164,6,24,167,53,193,173,199,233,232,41,221,244,18,
%   176,233,77,209,27,22,90,189,218,201,227>>
SharedSecretX448 =:= libdecaf_curve448:x448(BobSK448, AlicePK448).
% true
```