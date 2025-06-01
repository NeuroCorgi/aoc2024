% swipl main.pl Input.txt
:- initialization main -> halt.

main :-
    current_prolog_flag(argv, Argv),
    [Arg|_] = Argv,
    atom_string(Arg, File),
    file_lines(File, Lines),
    atomics_to_string(Lines, String),
    atom_chars(String, Chars),
    corrupted(Number, Chars, _),
    write(Number), nl.

corrupted(Z) --> mul(X), corrupted(Y), {Z is X + Y}.
corrupted(N) --> mul(N).
corrupted(N) --> [_], corrupted(N).
corrupted(0) --> [_].

mul(Z) --> [m], [u], [l], ['('], digit(A), [','], digit(B), [')'], {
			   Z is A * B
			   %% write(A), write(' '), write(B), write(' '), write(Z), nl
		   }.

digit(Z) --> digit_str(T), {number_string(Z, T)}.
digit_str(Q) --> numbers(H), digit_str(R), {string_concat(H, R, Q)}.
digit_str(S) --> numbers(S).

%% digit(Z) --> numbers(X), numbers(Y), {write("Digit: "), write(X), write(' '), write(Y), nl, Z is X * 10 + Y}.
%% digit(N) --> numbers(N).
%% reverse_digit(M,N) :- write("Reverse:"), write(M), nl, number_string(M,W), string_codes(W,X), reverse(X,Y), string_codes(Z,Y), number_string(N,Z).

numbers("0") --> ['0'].
numbers("1") --> ['1'].
numbers("2") --> ['2'].
numbers("3") --> ['3'].
numbers("4") --> ['4'].
numbers("5") --> ['5'].
numbers("6") --> ['6'].
numbers("7") --> ['7'].
numbers("8") --> ['8'].
numbers("9") --> ['9'].

% Prolog doesn't seem to have a simple way to read a file all at once, so helper function was used instead. Reference: https://www.swi-prolog.org/pldoc/doc_for?object=read_string/3
file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In), stream_lines(In, Lines), close(In)).
stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).
