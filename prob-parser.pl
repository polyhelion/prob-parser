
%
% A probabilistic lexicalized context-free parser
%


utterance(Prob, X) :-
	sentence(Prob, Verb, Noun, X, [ ]).

sentence(Prob, Verb, Noun, Start, End) :-
	nounphrase(P1, Noun, Start, Rest), 
	verbphrase(P2, Verb, Rest, End),
	pr(r1, P),      % Probability of this structure
	pr([r1, Verb, Noun], PrDep),           % Probability of this noun/verb combo
	pr(shead, Verb, Pshead),           % Probability this verb heads the sentence
	Prob is Pshead*P*PrDep*P1*P2.

nounphrase(Prob, Noun, [Noun | End], End) :-  
	noun(P1, Noun),
	pr(r2, P), 
	Prob is P*P1.

nounphrase(Prob, Noun, [Article,Noun | End], End) :-
	article(P1, Article), 
	noun(P2,Noun), 
	pr(r3, P),
	pr([r3, Noun, Article], PrDep),           % Probability of art/noun combo
	Prob is P*PrDep*P1*P2.

verbphrase(Prob, Verb, [Verb | End], End) :-     
	verb(P1, Verb), 
	pr(r4, P), 
	Prob is P*P1.

verbphrase(Prob, Verb, [Verb,Object | Rest], End) :-
	verb(P1, Verb), 
	nounphrase(P2, Object, Rest, End),
	pr([r5, Verb, Object], PrDep),          % Probability of verb/object combo
	pr(r5, P), 	
	Prob is P*PrDep*P1*P2.

pr(r1, 1.0).
pr(r2, 0.3).
pr(r3, 0.7).
pr(r4, 0.2).
pr(r5, 0.8).
article(1.0, a).
article(1.0, the).
article(1.0, these).
noun(1.0, man).
noun(1.0, dogs).
verb(1.0, likes).
verb(1.0, bite).
pr(shead, likes, 0.5).
pr(shead, bite, 0.5).
pr([r1, likes, man], 1.0).
pr([r1, likes, dogs], 0.0).
pr([r1, bite, man], 0.0).
pr([r1, bite, dogs], 1.0).
pr([r3, man, a], 0.5).
pr([r3, man, the], 0.5).
pr([r3, man, these], 0.0).
pr([r3, dogs, a], 0.0).
pr([r3, dogs, the], 0.6).
pr([r3, dogs, these], 0.4).
pr([r5, likes, man], 0.2).
pr([r5, likes, dogs], 0.8).
pr([r5, bite, man], 0.8).
pr([r5, bite, dogs], 0.2).










