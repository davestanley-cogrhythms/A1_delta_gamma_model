

% Ref: Carracedo LM, Kjeldsen H, Cunnington L, Jenkins a., Schofield I, Cunningham MO, Davies CH, Traub RD, Whittington M a. 2013. A Neocortical Delta Rhythm Facilitates Reciprocal Interlaminar Interactions via Nested Theta Rhythms. J Neurosci. 33:10750?10761.
function [y] = calc_carracedo2013(t)
    y = (1-exp(-(t-10)/38.1)).^4 .* (10.2 * exp(-(t-10)/122) + 1.1 * exp(-(t-10)/587));
end