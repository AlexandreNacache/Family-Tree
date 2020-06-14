% Alexandre Nacache
% comp 333 Prolog
%  project 3
%  project3.pl
% due 11/20/18

%facts

parent(eliane, karine).
parent(eliane, linda).
parent(eliane, muriel).
parent(pierette, gerald).
parent(pierette, eric).
parent(lucien, karine).
parent(lucien, linda).
parent(lucien, muriel).
parent(charles, gerald).
parent(charles, eric).
parent(muriel, elena).
parent(muriel, julien).
parent(linda, ilan).
parent(linda, ethan).
parent(linda, dalya).
parent(karine, alexandre).
parent(karine,raphael).
parent(nathalie, david).
parent(nathalie, ruben).
parent(nathalie, sarah).
parent(henry, elena).
parent(henry, julien).
parent(stirling, ilan).
parent(stirling, ethan).
parent(stirling, dalya).
parent(gerald, alexandre).
parent(gerald, raphael).
parent(eric, david).
parent(eric, ruben).
parent(eric, sarah).
 female(eliane).
 female(pierette).
 female(muriel).
 female(linda).
 female(karine).
 female(nathalie).
 female(elena).
 female(dalya).
 female(sarah).
 male(lucien).
 male(charles).
 male(henry).
 male(stirling).
 male(gerald).
 male(eric).
 male(julien).
 male(ilan).
 male(ethan).
 male(alexandre).
 male(raphael).
 male(david).
 male(ruben).

%rules
mother(X,Y) :- parent(X,Y), female(X).
father(X,Y) :- parent(X,Y), male(X).
grandparent(X,Y) :- parent(X,Z), parent(Z,Y).
ancestor(X,Y) :- parent(X,Y) ;(parent(X,Z), ancestor(Z,Y)).
child(X,Y) :- parent(Y,X).
descendant(X,Y) :- child(X,Y),(X\=Y).
descendant(X,Y) :- child(X,Z), descendant(Z,Y), (X\=Y).
grandfather(X,Y) :- grandparent(X,Y), male(X).
grandmother(X,Y) :- grandparent(X,Y), female(X).
siblings(X,Y) :- parent(Z,X), parent(Z,Y),(X\=Y).
brother(X,Y) :- siblings(X,Y), male(X).
sister(X,Y) :- siblings(X,Y), female(X).
firstcousins(X,Y) :- grandparent(Z,X), grandparent(Z,Y),(not(siblings(X,Y))), (X\=Y). %
aunt(X,Y) :- female(X), siblings(X,Z), parent(Z,Y).
uncle(X,Y) :- male(X), siblings(X,Z), parent(Z,Y).

likes(sue, books).
likes(sue, music).
likes(john, music).
likes(joan,books).
likes(steven, art).
likes(nancy, music).
likes(nancy,art).
likes(cindy,movies).
likes(john, books).
likes(steven, movies).
likes(joan, movies).
likes(nancy, yoga).
likes(cindy,art).
likes(cynthia, yoga).
likes(tim,art).

%rules for Problem 3 and 4

sharedInterests(X,Y,Z) :- likes(X,Z), likes(Y,Z), not(X=Y).
moreThanOneInterest(X)  :-  likes(X,A), likes(X,B), not( A = B).
popular(Z,N) :- N is 0.
popular(Z,N) :-  setof(X, likes(X,Z), L), length(L,N).
popular(Z,N) :-  setof(X, likes(X,Z), L), length(L,A), N<A.


/*

Problem 2,

1) list of all my mom's siblings.

?- setof( Y, (siblings(X,Y), mother(X,alexandre)), L ).
X = karine,
L = [linda, muriel].

2) A list of all your firstcousins.

?- setof( X, firstcousins(X,alexandre), L ).
L = [dalya, david, elena, ethan, ilan, julien, ruben, sarah].

3) A list of all your aunts and uncles.

?- append([eric], [linda,muriel], R).
R = [eric, linda, muriel].


4) A list of all your siblings.

?- setof(X, siblings(alexandre,X), L).
L = [raphael].

5) A list of all your grandmother’s children.
[I picked my maternal grandmother]

?- setof(X, child(X,eliane),R).
R = [karine, linda, muriel].

6) A list of all your ancestors.

?- setof(X, ancestor(X,alexandre), R).
R = [charles, eliane, gerald, karine, lucien, pierette].

7) A list of all descendants of your grandfather.
[I picked my paternal grandfather]

?- setof(X, descendant(X,charles),R).
R = [alexandre, david, eric, gerald, raphael, ruben, sarah].


##################################################################
##################################################################

problem 3,

a. ?- likes(john,A).
A = music ;
A = books.

A is capitalised, that means prolog knows it is a variable, and prolog
will find values of A that would make "likes(john,A)." true.
prolog gives one answer at a time, ; means give me another answer, .
means stop giving me answers. likes(john,A). is really a list of all the
things john likes. We got A= music before A= books because the fact
likes(john,music) is written before likes(john,books).



b.?-likes(A,movies).
A = cindy ;
A = steven ;
A = joan.

This is all the people that likes movies.
In the facts, it says that cindy likes movies before steven, and it says
that steven likes movies before johan. Prolog will print out results
based on which fact is written first.


c.?- sharedInterests(sue, john, Z).
Z = books ;
Z = music ;
false.

sharedInterests is a rule that will return true if the two first
parameters both like the third parameter. In this example, the third
parameter is capitalized, so it is a variable. this query will find all
the activities that both sue and john like. we got books before music
because the rule for sharedInterests is sharedInterests(X,Y,Z) :-
likes(X,Z), likes(Y,Z), not(X=Y). which means that prolog will find the
first thing that sue likes, which is books, and prolog will search if
john also likes books. john does so books is printed. the next thing
that sue likes is music, so prolog will try to find if john likes music.
john does like music so music will be printed.



d.?- sharedInterests(nancy,X, books).
false.

There is no fact that says that nancy likes books, so no matter what X
we choose, since nancy does not like books, no X can share the interest
of liking books.
Also, the rule for sharedInterests is sharedInterests(X,Y,Z) :-
likes(X,Z), likes(Y,Z), not(X=Y).
"likes(X,Z)." really is "likes(nancy,books)." since we know that
"likes(nancy,books)." is false, prolog will return false.



e.?- sharedInterests(nancy, B,yoga).
B = cynthia.

This query will find all B such that both nancy and B likes yoya.
cynthia is the only other person than nancy that likes yoga, so prolog
will print out cynthia.




f.?- sharedInterests(nancy, B,Z).
B = sue,
Z = music ;
B = john,
Z = music ;
B = steven,
Z = art ;
B = cindy,
Z = art ;
B = tim,
Z = art ;
B = cynthia,
Z = yoga.


In this question, we have two capital letters, so prolog will print out
a list of pairs of answers, B= , Z= that satisfy that nancy and the
person B both have the interest Z. nancy's first interest is music, so
prolog will first find B's that likes music. since in the facts, it says
that sue likes music before we say that john likes music, prolog's first
solution is B=sue,Z=music then B=john,Z=music. nancy's next interest
after music is art, so prolog will try to find all B that have the
interest art. prolog goes to the top of the list of facts, and steven is
the first person that has the art interest, this is why steven is next.
the fact that cindy likes art is after steven, this is why we get
B=cindy,Z=aer after B=steven,Z=art.then the next person on the list who
likes art is tim. nancy's next and last interest is yoga, so prolog will
find all B that likes yoga. cynthia is the only person that likes yoga
other than nancy, so prolog will print out B=cynthia,Z=yoga.


g.?-setof(X, likes(X,Z), People).
Z = art,
People = [cindy, nancy, steven, tim] ;
Z = books,
People = [joan, john, sue] ;
Z = movies,
People = [cindy, joan, steven] ;
Z = music,
People = [john, nancy, sue] ;
Z = yoga,
People = [cynthia, nancy].


In this question, there are 3 distincts variables, X, Z and
People(because P of People is capitalised). People is the name of the
set. Prolog will try to find all X's and Z's such that likes(X,Z) is
true. And it will print out a set of Z, and People, where Z is an
activity because it is the second parameter of the likes(X,Z) fact.
X represents every elements of the set named People.
The Z's are listed in alphabetical orders, this is why we get the
results in this order. the names in the sets People are also in
alphabetical orders.


h.?-setof(Z, likes(X,Z), Activities).
X = cindy,
Activities = [art, movies] ;
X = cynthia,
Activities = [yoga] ;
X = joan,
Activities = [books, movies] ;
X = john,
Activities = [books, music] ;
X = nancy,
Activities = [art, music, yoga] ;
X = steven,
Activities = [art, movies] ;
X = sue,
Activities = [books, music] ;
X = tim,
Activities = [art].

In this question, there are 3 variables, Z, X, Activities.
Z represents all the element of each sets that satisfy likes(X,Z).
this query will return a pair of two solutions, X= ,Activities= .
prolog is telling us, when X = cindy, Activities = [art, movies].
that means that this query shows a person's name and a list of all their
interests. we get X=cindy before X=cynthia because prolog gives answers
alphabetically in this example, same for the names in each sets.


?- moreThanOneInterest(john).
true

This query has no variables, so it should return either true or false.
the rule for moreThanOneInterests is moreThanOneInterest:-  likes(X,A), likes(X,B), not(A=B).
so if john likes 2 different activities, moreThanOneInterest will return
true. since john has at least 2 interests we get true.


?-moreThanOneInterest(X).
X = sue ;
X = sue ;
X = john ;
X = joan ;
X = steven ;
X = nancy ;
X = nancy ;
X = nancy ;
X = nancy ;
X = cindy ;
X = john ;
X = steven ;
X = joan ;
X = nancy ;
X = nancy ;
X = cindy ;
false.


The parameter X is a variable, so moreThanOneInterest(X). will return
every person that has at least 2 interests. some names are listed twice
because prolog works like a graph, so if it finds 2 different path to
the same goal, prolog will give us 2 answers. nancy is listed 6 times
because the rule for moreThanOneInterest(X). is
moreThanOneInterest(X) :- likes(X,A), likes(X,B), not(A=B).
if prolog finds N set of X,A,B that makes the rule true, the name X will
appear N times. Since nancy likes 3 activities, there are 3! (so 6) set
of A,B,X that makes the rule true.
sue is the first answer because sue is at the top of the fact list. john
is after sue on the fact list, this is why john is after sue for the
answers. The same thing applies for joan and the rest of people.


?= setof(X, moreThanOneInterest(X), People).
People = [cindy, joan, john, nancy, steven, sue].

This query returns a set named People, where all the elements of the set
are all the X that makes moreThanOneInterest(X) true.
in other words, this query returns a list of people that have more than
one interest.
The elements in the set are ordered alphabetically.




Problem 4

here are the test results...

?- popular(yoga,2).
true .

?- popular(yoga,3).
false.

?- popular(music,3).
true .

?- popular(movies,0).
true .

?- popular(movies,6).
false.

?- popular(movies,3).
true .

?- popular(books,3).
true .

?- popular(books,4).
false.

?- popular(art,4).
true .

?- popular(art,2).
true.

?- popular(art,9).
false.

?- popular(art,0).
true .

?- popular(X,Y).
Y = 0 .

?- popular(X,3).
X = books ;
X = movies ;
X = music ;
X = art ;
false.

?- popular(X,10).
false.

*/































































































